import QtQuick 2.0
import QtQuick.Controls 2.1

Rectangle {
    color: "white"

    Row {
        anchors.fill: parent
        anchors.margins: normalSpacing
        spacing: normalSpacing

        Button {
            text: qsTr("Call it a day")
            height: parent.height

            onClicked: {
                tasks.endDay()
            }
        }

        Button {
            id: resetDatabaseButton
            text: qsTr("Reset DB")
            height: parent.height

            state: "normal"

            onClicked: {
                state = "awaiting confirmation"
            }

            states: [
                State {
                    name: "normal"
                },
                State {
                    name: "awaiting confirmation"

                    PropertyChanges {
                        target: confirmationDialog
                        visible: true
                        text: qsTr("Reset DB? This would remove all tasks")
                        onConfirm: {
                            tasks.resetDatabase()
                            resetDatabaseButton.state = "normal"
                        }
                        onDecline: {
                            resetDatabaseButton.state = "normal"
                        }
                    }
                }
            ]
        }
    }

    Row {
        anchors.fill: parent
        anchors.margins: normalSpacing
        spacing: normalSpacing
        layoutDirection: Qt.RightToLeft

        Button {
            text: qsTr("Acknowledgements")
            height: parent.height

            onClicked: {
                acknowledgements.visible = true
            }
        }
    }
}
