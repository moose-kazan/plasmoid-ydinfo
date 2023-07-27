.PHONY: help package deb ppa-push test

help:
	@echo "Available targets:"
	@echo "build   - build plasmoid"
	@echo "clean   - cleanup build directory"
	@echo "test    - run plasmoid in test mode"
	@echo "package - build zip archive"
	@echo "help    - show this help"


build:
	mkdir -p build
	cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release
	cd build && make

clean:
	rm -rfv build

test:
	cd package && plasmoidviewer --applet ./ --size 750x550

deb:
	dpkg-buildpackage -rfakeroot --build=source

ppa-push: deb
	${eval DEBVERSION=${shell head -n 1 debian/changelog | sed -r 's/[^(]*\((.*)\).*/\1/'}}
	dput ppa:bulvinkl/ppa ../plasmoid-ydinfo_${DEBVERSION}_source.changes

package:
	${eval PKGVERSION=${shell git tag -l|sort|tail -n 1|sed 's/v//'}}
	${eval TMPDIR=${shell mktemp -d}}
	${eval PKGBUILDDIR="${TMPDIR}/ydinfo-${PKGVERSION}"}
	${eval CWD=${shell pwd}}
	cp -r package ${PKGBUILDDIR}
	${foreach t,${wildcard translations/po/*.po}, \
		${eval CURRENT_LOCALE=${shell echo ${t} | sed -r 's/.*([a-z][a-z]).po/\1/'}} \
		${eval PROJECT_NAME=${shell echo ${t} | sed -r 's/.*\/([^\/]*)_[a-z][a-z].po/\1/'}} \
		mkdir -p "${PKGBUILDDIR}/locale/${CURRENT_LOCALE}/LC_MESSAGES" ; \
		msgfmt -o "${PKGBUILDDIR}/locale/${CURRENT_LOCALE}/LC_MESSAGES/${CURRENT_LOCALE}.mo" ${t} ; \
	}
	cd ${TMPDIR} && zip -r ${CWD}/../ydinfo-${PKGVERSION}.zip ydinfo-${PKGVERSION}
	rm -rf ${TMPDIR}
	@echo "Packed into ../ydinfo-${PKGVERSION}.zip"

