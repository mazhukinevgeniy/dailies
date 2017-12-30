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
                text: "Add new task"

                onClicked: {
                    addTaskDialog.visible = true
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
