import QtQuick 2.8
import QtQuick.Window 2.2

Window {
    id: app
    visible: true
    width: 640
    height: 480
    title: "Daily app title"

    property int tileWidth: 64
    property int taskRowHeight: tileWidth
    property int titlePanelWidth: tileWidth * 2.0
    property int normalSpacing: 10

    Item {
        id: contentSpace
        width: parent.width
        height: parent.height - bottomPanel.height

        TaskList {
            anchors.fill: parent
            anchors.topMargin: normalSpacing * 0.5
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

    Notification {
        id: acknowledgements
        anchors.fill: parent
        visible: false
    }//TODO(low priority): make it loader-based someday

    Timer {
        id: titleTimer
        interval: 1000*40
        repeat: true
        running: true
        triggeredOnStart: true

        property var titles: [
            "Enough of this",
            "Let's get down to the real business now",
            "Such resilence!",
            "Still sane, exile?",
            "Down to biz, down to work",
            "HeyGuys",
            "What are you procrastinating on?",
            "Maybe it's time to relax",
            "We're only in it for the money"
        ]

        onTriggered: {
            app.title = titles[Math.floor(Math.random() * titles.length)]
        }
    }
}
