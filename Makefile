help:
	@echo "Available targets:"
	@echo "build - build plasmoid"
	@echo "clean - cleanup build directory"
	@echo "test  - run plasmoid in test mode"
	@echo "help  - show this help"


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

	
