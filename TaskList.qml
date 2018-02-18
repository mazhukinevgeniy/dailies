import QtQuick 2.0
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0
import app.enums 1.0

ListView {
    id: list
    spacing: normalSpacing

    //TODO: support ui with nice transitions

    model: taskModel
    cacheBuffer: Math.min(count, 200)

    property real sharedX: 0
    property date lastReset: new Date()

    function getData(r, c) {
        return list.model.data(list.model.index(r, c))
    }
    function setData(r, c, v) {
        return list.model.setData(list.model.index(r, c), v)
    }

    function submitAndSelect() {
        var indexToRestore = indexAt(contentX, contentY)
        //TODO: look for a better solution
        model.submitAll()
        model.select()
        positionViewAtIndex(indexToRestore, ListView.Beginning)
    }

    Connections {
        target: app
        onVisibleChanged: {
            if (app.visible) {
                submitAndSelect()
            }
        }
    }

    delegate: Item {
        width: list.width
        height: taskRowHeight

        property var rowIndex: model.index

        Row {
            id: taskListDelegate
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
                    text: getData(rowIndex, 1)

                    Image {
                        id: image
                        width: height * sourceSize.width / sourceSize.height
                        height: parent.height * 0.3
                        anchors.right: parent.right
                        anchors.top: parent.top
                        source: "assets/doable.png"
                        visible: getData(rowIndex, 2) === Tasks.DOABLE
                    }

                    onClicked: {
                        //TODO: add edit dialog
                        if (getData(rowIndex, 2) === Tasks.ACTIVE) {
                            setData(rowIndex, 2, Tasks.DOABLE)
                        } else {
                            setData(rowIndex, 2, Tasks.DISABLED)
                        }
                        submitAndSelect()
                    }
                }
            }

            Repeater {
                model: getData(rowIndex, 3).split("")
                delegate: MouseArea {
                    id: tile
                    width: tileWidth
                    height: width
                    enabled: index == 0

                    onClicked: {
                        var history = getData(rowIndex, 3)
                        var res = Math.min(parseInt(history[0]) + 1, 9) + history.substring(1)
                        setData(rowIndex, 3, res)
                        submitAndSelect()
                    }

                    Image {
                        id: checkImg
                        anchors.fill: parent
                    }

                    Text {
                        id: checkText
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        color: "black"
                    }

                    states: [
                        State {
                            name: "failed"
                            when: modelData == "0" && !enabled

                            PropertyChanges {
                                target: checkImg
                                source: "assets/002-error.png"
                            }
                        },
                        State {
                            name: "to be done"
                            when: modelData == "0" && enabled

                            PropertyChanges {
                                target: checkImg
                                source: "assets/001-info.png"
                            }
                        },
                        State {
                            name: "done"
                            when: modelData > 0

                            PropertyChanges {
                                target: checkImg
                                source: "assets/003-success.png"
                            }
                            PropertyChanges {
                                target: checkText
                                text: modelData > 1 ? modelData : ""
                                font.bold: modelData > 2
                                font.pointSize: modelData > 4 ? 8 + modelData * 0.4 : 10
                            }
                        }
                    ]
                }
            }
        }

        Item {
            width: tileWidth
            height: width
            anchors.left: parent.left

            LinearGradient {
                anchors.fill: parent
                start: Qt.point(0, 0)
                end: Qt.point(tileWidth, 0)
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: Qt.rgba(1, 1, 1, 1)
                    }
                    GradientStop {
                        position: 0.05
                        color: Qt.rgba(1, 1, 1, 1)
                    }
                    GradientStop {
                        position: 1.0
                        color: Qt.rgba(1, 1, 1, 0)
                    }
                }
            }
        }
    }

    header: Column {
        width: parent.width
        height: taskRowHeight

        Row {
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
        }
    }
}
