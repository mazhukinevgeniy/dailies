import QtQuick 2.8
import QtQuick.Window 2.2

Window {
    id: app
    visible: true
    minimumWidth: 800 * 1.1
    minimumHeight: 600 * 1.1
    title: "Daily app title"

    property int tileWidth: 64
    property int taskRowHeight: tileWidth
    property int titlePanelWidth: tileWidth * 2.5
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

    Acknowledgements {
        id: acknowledgements
    }//TODO: (low priority) make it loader-based someday

    AddTaskDialog {
        id: addTaskDialog
    }

    ConfirmationDialog {
        id: confirmationDialog
    }

    Timer {
        id: titleTimer
        interval: 1000*40
        repeat: true
        running: true
        triggeredOnStart: true

        property var titles: [
            qsTr("Coding on the weekend"),
            qsTr("Good enough to ship"),
            qsTr("Checklists")
        ]

        onTriggered: {
            app.title = titles[Math.floor(Math.random() * titles.length)]
        }
    }

    Item {
        id: quick

        function bound(value, min, max) {
            return Math.min(max, Math.max(value, min))
        }
    }
}
