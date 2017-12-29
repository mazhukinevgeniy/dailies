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
        spacing: normalSpacing
        layoutDirection: Qt.RightToLeft

        property var taskId: model.taskId

        Text {
            id: rowDescription
            width: titlePanelWidth - normalSpacing * 0.5
            height: parent.height
            text: model.description
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
        }

        DailyCheckList {
            id: checks
            width: parent.width - titlePanelWidth - normalSpacing * 0.5
            height: parent.height
            interactive: false
        }
    }

    header: Row {
        width: parent.width
        height: taskRowHeight
        spacing: normalSpacing
        layoutDirection: Qt.RightToLeft

        TextArea {
            id: newTask
            width: titlePanelWidth - normalSpacing * 0.5
            height: parent.height
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            placeholderText: "Add new task..."
            state: "untouched"

            states: [
                State {
                    name: "untouched"

                    PropertyChanges {
                        target: newTask
                        restoreEntryValues: false
                        text: ""
                        focus: false
                        onActiveFocusChanged: {
                            if (newTask.activeFocus) {
                                newTask.state = "inputting"
                            }
                        }
                    }
                },
                State {
                    name: "inputting"

                    PropertyChanges {
                        target: newTask
                        restoreEntryValues: false
                        onActiveFocusChanged: {
                            if (!newTask.activeFocus && newTask.text === "") {
                                newTask.state = "untouched"
                            }
                        }
                    }
                }
            ]

            Keys.onReturnPressed: {
                if (state === "inputting") {
                    tasks.addTask(text)
                    state = "untouched"
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
