/*
    SPDX-FileCopyrightText: 2020 Vadim Kalinnikov <moose@ylsoftware.com>
    SPDX-License-Identifier: LGPL-2.1
*/

import QtQuick 2.15
import QtQuick.Controls as QtControls
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
	id: page

	property var title
	property var cfg_UpdateIntervalDefault
	property var cfg_AdditionalParamsDefault

	property alias cfg_AdditionalParams: cfgAdditionalParams.text
	property alias cfg_UpdateInterval: cfgUpdateInterval.value
	
	QtControls.TextField {
		id: cfgAdditionalParams
		Kirigami.FormData.label: i18n("Additional params for \"yandex-disk status\" command:")
	}

	QtControls.SpinBox {
		id: cfgUpdateInterval
		from: 1
		to: 10
		Kirigami.FormData.label: i18n("Update info every ... minutes:")
	}

}
