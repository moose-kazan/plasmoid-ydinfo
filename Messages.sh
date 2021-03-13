#!/usr/bin/env bash

mkdir -p translations/po
touch translations/po/plasma_applet_com.ylsoftware.plasma.ydinfo.pot

XGETTEXT="xgettext --from-code=UTF-8 -kde -ci18n -ki18n:1 \
	-ki18nc:1c,2 -ki18np:1,2 -ki18ncp:1c,2,3 -ktr2i18n:1 \
	-kI18N_NOOP:1 -kI18N_NOOP2:1c,2 -kaliasLocale -kki18n:1 \
	-kki18nc:1c,2 -kki18np:1,2 -kki18ncp:1c,2,3xgettext \
	-ki18n -ki18nc -ki18ncp -ki18np"

$XGETTEXT -L Java `find . -name \*.qml` -j \
	-o translations/po/plasma_applet_com.ylsoftware.plasma.ydinfo.pot \
	--package-name=plasmoidydinfo --package-version=2.1

find translations/po -name "plasma_applet_com.ylsoftware.plasma.ydinfo_*.po" \
	-exec msgmerge --update --backup=none \
	--previous {} translations/po/plasma_applet_com.ylsoftware.plasma.ydinfo.pot \;


#
# On system wide all translations stored in files like:
#	/usr/share/locale/ar/LC_MESSAGES/plasma_applet_org.kde.plasma.quicklaunch.mo
#
# And in QML it used i18n() function
#
