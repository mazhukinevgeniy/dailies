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
        id: text
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        color: "black"
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
                target: tile
                onClicked: {
                    tasks.upgrade(model.checkId)
                }
            }
            PropertyChanges {
                target: image
                source: "assets/003-success.png"
            }
            PropertyChanges {
                target: text
                text: model.rank > 1 ? model.rank : ""
                font.bold: model.rank > 2
                font.pointSize: model.rank > 4 ? 8 + model.rank * 0.4 : 10
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
