import QtQuick 2.0
import QtQuick.Controls 2.1

ListView {
    id: list
    spacing: normalSpacing

    displaced: Transition {
        NumberAnimation { properties: "x,y"; duration: 500 }
    }//TODO: make it work with sql models

    model: tasks.getTasksQueryModel()

    property real sharedX: 0

    delegate: Row {
        id: taskListDelegate
        width: parent.width
        height: taskRowHeight
        spacing: normalSpacing * 0.5
        layoutDirection: Qt.RightToLeft

        property var taskId: model.taskId

        Item {
            width: titlePanelWidth
            height: parent.height

            Button {
                anchors.fill: parent
                anchors.margins: normalSpacing * 0.5
                text: model.description

                Image {
                    width: height * sourceSize.width / sourceSize.height
                    height: parent.height * 0.3
                    anchors.right: parent.right
                    anchors.top: parent.top
                    source: "assets/doable.png"
                }

                onClicked: {
                    //TODO: open edit dialog
                    tasks.disableTask(model.taskId)
                }
            }
        }

        DailyCheckList {
            id: checks
            width: parent.width - titlePanelWidth - parent.spacing
            height: parent.height
            interactive: false

            Binding {
                target: list
                property: "sharedX"
                value: contentX
                when: flickingHorizontally
            }
            Binding {
                target: checks
                property: "contentX"
                value: sharedX
                when: !flickingHorizontally
            }
            //TODO: make it work or remove
            //atm synchronous flicking isn't even needed
        }
    }

    header: Column {
        width: parent.width
        height: taskRowHeight + resetDates.height

        Row {
            width: parent.width
            height: taskRowHeight
            spacing: normalSpacing
            layoutDirection: Qt.RightToLeft


            Item {
                width: titlePanelWidth
                height: parent.height

                Button {
                    anchors.fill: parent
                    anchors.margins: normalSpacing * 0.5
                    text: qsTr("Add new task")

                    onClicked: {
                        addTaskDialog.visible = true
                    }
                }
            }

            Text {
                height: parent.height
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Day started %1 ago").arg(variableTime)

                property string variableTime: "00:00:00.000"

                Timer {
                    interval: 1000
                    repeat: true
                    running: true
                    triggeredOnStart: true

                    onTriggered: {
                        var timeDifference = new Date().getTime() - stat.dayStarted.getTime()
                        parent.variableTime =
                                timeDifference < 1000 * 60 * 60 * 24 ?
                                    new Date(timeDifference).toISOString().slice(11, -1).substring(0, 8) :
                                    qsTr("over 24 hours")
                        //TODO: link with reset dates instead
                    }
                }
            }
        }

        ListView {
            id: resetDates
            width: parent.width - titlePanelWidth - normalSpacing * 0.5
            //TODO: this is not maintainable code ^tm, need to get something done with titlePanelWidth
            //rework layout?
            height: 20
            spacing: normalSpacing
            orientation: Qt.Horizontal
            layoutDirection: Qt.RightToLeft
            model: tasks.getResetsQueryModel()
            interactive: false
            contentX: sharedX

            delegate: Rectangle {
                width: taskRowHeight
                height: 20
                color: "grey"

                Text {
                    anchors.centerIn: parent
                    text: model.date.substring(5, 10)
                }
            }
            Connections {
                target: tasks
                onUpdateTasksModel: {
                    list.model = tasks.getTasksQueryModel()
                    resetDates.model = tasks.getResetsQueryModel()
                }
            }
        }
    }
}
