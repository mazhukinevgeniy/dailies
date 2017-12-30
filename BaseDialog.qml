import QtQuick 2.0

Item {
    id: dialog
    anchors.fill: parent
    visible: false

    property bool interactive: true
    property Component contentDelegate: undefined

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 0.5

        MouseArea {
            anchors.fill: parent
            onClicked: {
                dialog.visible = false
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: 100
        radius: 30
        color: "white"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                dialog.visible = dialog.interactive
            }
        }

        Loader {
            anchors.fill: parent
            sourceComponent: contentDelegate
        }
    }
}
