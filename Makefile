run:
	plasmoidviewer --applet package/

distr:
	$(eval P_VER=$(shell grep X-KDE-PluginInfo-Version= package/metadata.desktop | sed 's/X-KDE-PluginInfo-Version=//'))
	$(eval P_NAME=$(shell grep X-KDE-PluginInfo-Name= package/metadata.desktop | sed 's/X-KDE-PluginInfo-Name=//'))
	mkdir -p build
	tar cfvz build/${P_NAME}-${P_VER}.tar.gz -C package/ .

clean:
	rm -rf build
