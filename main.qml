import QtQuick 2.8
import QtQuick.Window 2.2

Window {
    id: app
    visible: true
    width: 640
    height: 480
    title: qsTr("HeyGuys")

    property int tileWidth: 80
    property int taskRowHeight: tileWidth
    property int titlePanelWidth: tileWidth * 2.0
    property int normalSpacing: 20

    signal newDay()

    signal resetDB()
    signal fixDB()
    property bool developingDB: true

    Item {
        id: contentSpace
        width: parent.width
        height: parent.height - bottomPanel.height

        TaskList {
            anchors.fill: parent
        }

        Rectangle {
            width: 1
            height: parent.height
            color: "black"
            anchors.right: parent.right
            anchors.rightMargin: titlePanelWidth
        }
    }

    BottomPanel {
        id: bottomPanel
        width: parent.width
        height: 60

        anchors.top: contentSpace.bottom

        Rectangle {
            width: parent.width
            height: 1
            color: "black"
        }
    }
}
