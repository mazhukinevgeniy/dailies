import QtQuick 2.0
import QtQuick.Controls 2.1

ListView {
    id: list
    spacing: normalSpacing

    displaced: Transition {
        NumberAnimation { properties: "x,y"; duration: 500 }
    }//TODO: make it work with sql models

    model: tasks.getTasksQueryModel()

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
        }
    }

    header: Row {
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
                }
            }
        }
    }

    Connections {
        target: tasks

        onUpdateTasksModel: {
            list.model = tasks.getTasksQueryModel()
        }
    }
}
