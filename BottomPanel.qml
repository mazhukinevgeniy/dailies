import QtQuick 2.0
import QtQuick.Controls 2.1

Item {
    Row {
        anchors.fill: parent
        anchors.margins: normalSpacing * 0.5
        spacing: normalSpacing * 0.5

        Button {
            text: qsTr("Call it a day")
            height: parent.height

            onClicked: newDay()
        }

        Button {
            text: qsTr("Reset DB")
            height: parent.height
            visible: developingDB

            onClicked: resetDB()
        }

        Button {
            text: qsTr("Fix DB")
            height: parent.height
            visible: developingDB

            onClicked: fixDB()
        }
    }
}
