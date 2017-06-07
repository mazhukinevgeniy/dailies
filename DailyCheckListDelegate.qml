import QtQuick 2.0

MouseArea {
    id: tile
    width: tileWidth
    height: width

    Image {
        id: image
        anchors.fill: parent
    }

    Text {
        text: "Check id: " + model.checkId //TODO: remove, it is ugly and is a distraction
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
                target: image
                source: "assets/001-info.png"
            }
        },
        State {
            name: "done"
            when: model.status === check_done

            PropertyChanges {
                target: image
                source: "assets/003-success.png"
            }
        },
        State {
            name: "failed"
            when: model.status === check_failed

            PropertyChanges {
                target: image
                source: "assets/002-error.png"
            }
        }
    ]
}
