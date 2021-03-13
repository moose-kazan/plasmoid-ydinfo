LANGUAGES=en ru

run:
	plasmoidviewer --applet package/

distr: lrelease
	$(eval P_VER=$(shell grep X-KDE-PluginInfo-Version= package/metadata.desktop \
		| sed 's/X-KDE-PluginInfo-Version=//'))
	$(eval P_NAME=$(shell grep X-KDE-PluginInfo-Name= package/metadata.desktop \
		| sed 's/X-KDE-PluginInfo-Name=//'))
	mkdir -p build
	tar cfvz build/${P_NAME}-${P_VER}.tar.gz -C package/ .

clean:
	rm -rf build
	rm -f translations/*.po
	rm -rf package/contents/locale

lupdate:
	mkdir -p translations
	$(foreach lng,$(LANGUAGES), \
		lupdate package/contents/ui/*.qml \
			package/contents/config/*.qml \
			-ts translations/$(lng).ts;)


lrelease: lupdate
	$(eval P_NAME=$(shell grep X-KDE-PluginInfo-Name= package/metadata.desktop \
		| sed 's/X-KDE-PluginInfo-Name=//'))
	
	$(foreach lng,$(LANGUAGES), \
		mkdir -p package/contents/locale/$(lng)/LC_MESSAGES;)
	$(foreach lng,$(LANGUAGES), \
		lconvert -of po -o translations/$(lng).po \
			translations/$(lng).ts;)
	$(foreach lng,$(LANGUAGES), \
		msgfmt -o package/contents/locale/$(lng)/LC_MESSAGES/plasma_applet_$(P_NAME).mo \
			translations/$(lng).po;)
	
	$(foreach lng,$(LANGUAGES), \
		lrelease translations/$(lng).ts \
			-qm package/contents/locale/$(lng)/LC_MESSAGES/plasma_applet_$(P_NAME).qm;)
