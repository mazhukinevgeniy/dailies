import QtQuick 2.0

Item {
    id: dialog
    anchors.fill: parent
    visible: false

    property bool interactive: true
    property real contentWidth: 0
    property real contentHeight: 0
    property Component contentDelegate: undefined

    signal clickedOutside()

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 0.5

        MouseArea {
            anchors.fill: parent
            onClicked: {
                dialog.visible = false
                clickedOutside()
            }
        }
    }

    Rectangle {
        id: contentRectangle
        radius: 30
        color: "white"

        states: [
            State {
                when: contentWidth > 0 && contentHeight > 0
                PropertyChanges {
                    target: contentRectangle
                    anchors.centerIn: dialog
                    width: contentWidth + radius * 2
                    height: contentHeight + radius * 2
                }
                PropertyChanges {
                    target: loader
                    anchors.centerIn: contentRectangle
                }
            },
            State {
                when: contentWidth <= 0 || contentHeight <= 0
                PropertyChanges {
                    target: contentRectangle
                    anchors.fill: dialog
                    anchors.margins: 100
                }
                PropertyChanges {
                    target: loader
                    anchors.fill: contentRectangle
                }
            }
        ]

        MouseArea {
            anchors.fill: parent
            onClicked: {
                dialog.visible = dialog.interactive
            }
        }

        Loader {
            id: loader
            sourceComponent: contentDelegate
        }
    }
}
