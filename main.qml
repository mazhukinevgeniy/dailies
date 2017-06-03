import QtQuick 2.8
import QtQuick.Window 2.2

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    property int tileWidth: 80

    Item {
        id: contentSpace
        width: parent.width
        height: parent.height - bottomPanel.height
    }

    Item {
        Rectangle {
            width: parent.width
            height: 1
            color: "black"
        }

        id: bottomPanel
        width: parent.width
        height: 60
        anchors.top: contentSpace.bottom
    }

    DailyCheckList {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 20
        height: tileWidth
    }
}
