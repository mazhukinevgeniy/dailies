import QtQuick 2.0

MouseArea {
    id: tile
    width: tileWidth
    height: width

    Rectangle {
        id: background
        anchors.fill: parent
    }

    states: [
        State {
            name: "to be done"

            PropertyChanges {
                target: tile
                onClicked: {
                    tile.state = "done"
                }
                onPressAndHold: {
                    tile.state = "failed"
                }
            }
            PropertyChanges {
                target: background
                color: "#DDDDDD"
            }
        },
        State {
            name: "done"

            PropertyChanges {
                target: tile
                onPressAndHold: {
                    tile.state = "to be done"
                }
            }
            PropertyChanges {
                target: background
                color: "green"
            }
        },
        State {
            name: "failed"

            PropertyChanges {
                target: tile
                onPressAndHold: {
                    tile.state = "to be done"
                }
            }
            PropertyChanges {
                target: background
                color: "#444444"
            }
        }
    ]

    Component.onCompleted: {
        tile.state = "to be done"
    }
}
