import QtQuick 2.0
import QtQuick.Controls 2.1

Rectangle {
    color: "white"

    Row {
        anchors.fill: parent
        anchors.margins: normalSpacing
        spacing: normalSpacing

        Button {
            text: qsTr("Call it a day")
            height: parent.height

            onClicked: tasks.endDay()
        }

        Button {
            text: qsTr("Reset DB")
            height: parent.height

            onClicked: tasks.resetDatabase()
        }
    }

    Row {
        anchors.fill: parent
        anchors.margins: normalSpacing
        spacing: normalSpacing
        layoutDirection: Qt.RightToLeft

        Button {
            text: qsTr("Acknowledgements")
            height: parent.height

            onClicked: {
                acknowledgements.visible = true
            }
        }
    }
}
