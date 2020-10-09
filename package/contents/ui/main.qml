/*
    SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>
    SPDX-License-Identifier: LGPL-2.1-or-later
*/

import QtQuick 2.1
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
	property string valueUsed: ''
	property string valueTotal: ''
	property real valueOpacity: 0
	Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation
    Plasmoid.fullRepresentation: ColumnLayout {
        anchors.fill: parent
        PlasmaComponents.Label {
			id: ydTitle
            Layout.alignment: Qt.AlignCenter
            text: qsTr('Yandex.Disk usage')
        }
        PlasmaComponents.Label {
			id: ydTotal
			Layout.alignment: Qt.AlignLeft
			text: valueTotal
		}
		PlasmaComponents.Label {
			id: ydUsed
			Layout.alignment: Qt.AlignLeft
			text: valueUsed
		}
        PlasmaComponents.ProgressBar {
			Layout.alignment: Qt.AlignLeft
			minimumValue: 0
			maximumValue: 100
			value: valueOpacity
		}
    }
    PlasmaCore.DataSource {
		id: ydStatus
		engine: "executable"
		interval: 300000
		connectedSources: [
			'/bin/sh -c "env LANG=C yandex-disk status"'
		]
		onNewData: {
			var stdout = data["stdout"]
			//console.debug(stdout)
			var raw_used = stdout.match(/Used: ([0-9]+(?:\.[0-9]+)?) ([KMGT]B)/)
			var raw_total = stdout.match(/Total: ([0-9]+(?:\.[0-9]+)?) ([KMGT]B)/)
			
			var yd_used = qsTr("Data not fetched")
			var yd_total = qsTr("Data not fetched")
			if (raw_used.length == 3 && raw_total.length == 3) {
				yd_used = qsTr("Used: %1 %2").arg(raw_used[1]).arg(raw_used[2])
				yd_total = qsTr("Total: %1 %2").arg(raw_total[1]).arg(raw_total[2])
			}
			//console.log(yd_used)
			//console.log(yd_total)
			
			valueUsed = yd_used
			valueTotal = yd_total
			
			var yd_used_num = formatSrcNum(raw_used[1], raw_used[2])
			var yd_total_num = formatSrcNum(raw_total[1], raw_total[2])
			valueOpacity = yd_used_num * 100 / yd_total_num
			//console.log(valueOpacity)
		}
		
		function formatSrcNum(n, k) {
			if (k == "TB") {
				k = k*1024*1024*1024*1024
			}
			else if (k == "GB") {
				k = k*1024*1024*1024
			}
			else if (k == "MB") {
				k = k*1024*1024
			}
			else if (k == "KB") {
				k = k*1024
			}
			
			return n;
		}
	}
}
