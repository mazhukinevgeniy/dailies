import QtQuick 2.0

MouseArea {
    id: tile
    width: tileWidth
    height: width

    Rectangle {
        id: background
        anchors.fill: parent
    }

    Column {
        spacing: normalSpacing

        Text {
            text: "Check id: " + model.checkId //TODO: remove, it is ugly and is a distraction
        }
        Text {
            text: "State: " + tile.state
        }
    }


    states: [
        State {
            name: "to be done"
            when: model.status === check_tbd

            PropertyChanges {
                target: tile
                onClicked: {
                    tasks.markDone(model.checkId)
                }
            }
            PropertyChanges {
                target: background
                color: "#DDDDDD"
            }
        },
        State {
            name: "done"
            when: model.status === check_done

            PropertyChanges {
                target: background
                color: "#88FF88"
            }
        },
        State {
            name: "failed"
            when: model.status === check_failed

            PropertyChanges {
                target: background
                color: "#444444"
            }
        }
    ]
}
