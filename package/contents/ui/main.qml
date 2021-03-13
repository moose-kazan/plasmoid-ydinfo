/*
    SPDX-FileCopyrightText: 2020 Vadim Kalinnikov <moose@ylsoftware.com>
    SPDX-License-Identifier: LGPL-2.1
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
	Plasmoid.fullRepresentation: GridLayout {
        anchors.fill: parent
        rows: 4
        columns: 2
        PlasmaComponents.Label {
            Layout.alignment: Qt.AlignCenter
            Layout.columnSpan: 2
            Layout.rowSpan: 1
            Layout.row: 1
            Layout.column: 1
            text: i18n('Yandex.Disk usage')
        }
        PlasmaComponents.Label {
			Layout.alignment: Qt.AlignLeft
            Layout.columnSpan: 1
            Layout.rowSpan: 1
            Layout.row: 2
            Layout.column: 1
            Layout.fillWidth: true
			text: valueTotal
		}
		PlasmaComponents.Label {
			Layout.alignment: Qt.AlignLeft
            Layout.columnSpan: 1
            Layout.rowSpan: 1
            Layout.row: 3
            Layout.column: 1
            Layout.fillWidth: true
			text: valueUsed
		}
        Image {
			Layout.alignment: Qt.AlignRight
            Layout.columnSpan: 1
            Layout.rowSpan: 2
            Layout.row: 2
            Layout.column: 2
            fillMode: Image.PreserveAspectFit
            Layout.fillHeight: true
            Layout.fillWidth: true
            source: "../images/yandexdisk.svg"
		}
        PlasmaComponents.ProgressBar {
			Layout.alignment: Qt.AlignLeft
            Layout.columnSpan: 2
            Layout.rowSpan: 1
            Layout.row: 4
            Layout.column: 1
			minimumValue: 0
			maximumValue: 100
			value: valueOpacity
		}
    }
    
    PlasmaCore.DataSource {
		id: ydStatus
		engine: "executable"
		interval: plasmoid.configuration.UpdateInterval*60000
		connectedSources: [
			(
				'/bin/sh -c "env LANG=C yandex-disk %1 status"'
			).arg(plasmoid.configuration.AdditionalParams)
		]
		onNewData: {
			var stdout = data["stdout"]
			//console.debug(stdout)
			try {
				var raw_used = stdout.match(/Used: ([0-9]+(?:\.[0-9]+)?) ([KMGT]B)/)
				var raw_total = stdout.match(/Total: ([0-9]+(?:\.[0-9]+)?) ([KMGT]B)/)
				
				var yd_used = i18n("Data not fetched")
				var yd_total = i18n("Data not fetched")
				if (raw_used.length == 3 && raw_total.length == 3) {
					yd_used = i18n("Used: %L1 %L2").arg(raw_used[1]).arg(raw_used[2])
					yd_total = i18n("Total: %L1 %L2").arg(raw_total[1]).arg(raw_total[2])
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
			catch(error) {
				console.log("Problem with data from yandex-disk service!")
			}
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
