import QtQuick 2.0
import QtQuick.Controls 2.1

BaseDialog {
    id: dialog

    contentDelegate: Item {
        TextArea {
            id: newTask
            width: quick.bound(parent.width * 0.5, 200, 400)
            height: 100
            anchors.top: parent.top
            anchors.topMargin: 30 //TODO: declare standard margin somewhere
            anchors.horizontalCenter: parent.horizontalCenter
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            placeholderText: "Short task description"
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
                    dialog.visible = false
                }
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 30 //TODO: declare standard margin somewhere
            height: taskRowHeight
            spacing: normalSpacing

            FlatButton {
                width: (newTask.width - normalSpacing) * 0.5
                height: parent.height
                text: "Cancel"

                onClicked: {
                    dialog.visible = false
                }
            }

            FlatButton {
                width: (newTask.width - normalSpacing) * 0.5
                height: parent.height
                text: "Create"

                onClicked: {
                    if (newTask.state === "inputting") {
                        tasks.addTask(newTask.text)
                        dialog.visible = false
                    }
                }
            }
        }


        Connections {
            target: dialog

            onVisibleChanged: {
                if (dialog.visible) {
                    newTask.focus = true
                    //TODO: fix that (set focus to text field when dialog opens)
                } else {
                    newTask.state = "untouched"
                }
            }
        }
    }
}
