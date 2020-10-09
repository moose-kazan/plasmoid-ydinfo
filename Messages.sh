#!/bin/bash
cd `dirname $0`

xgettext `find package -name \*.qml` -o package/translate/com.ylsoftware.ydinfo.pot
