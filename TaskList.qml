import QtQuick 2.0
import QtQuick.Controls 2.1

ListView {
    id: list
    spacing: normalSpacing

    displaced: Transition {
        NumberAnimation { properties: "x,y"; duration: 500 }
    }//TODO: make it work with sql models

    model: tasks.getTasksQueryModel()

    property real sharedX: 0
    property date lastReset: new Date()

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

                Image {
                    id: image
                    width: height * sourceSize.width / sourceSize.height
                    height: parent.height * 0.3
                    anchors.right: parent.right
                    anchors.top: parent.top
                    source: "assets/doable.png"
                    visible: //model.extraDoable
                             tasks.checkTag(model.taskId, "doable")
                }

                onClicked: {
                    //TODO: open edit dialog
                    //TODO: this is really really bad, move to dedicated model asap
                    if (!image.visible) {
                        tasks.addTag(model.taskId, "doable")
                        image.visible = tasks.checkTag(model.taskId, "doable")
                    } else {
                        tasks.disableTask(model.taskId)
                    }
                }
            }
        }

        DailyCheckList {
            id: checks
            width: parent.width - titlePanelWidth - parent.spacing
            height: parent.height
            interactive: false

            Binding {
                target: list
                property: "sharedX"
                value: contentX
                when: flickingHorizontally
            }
            Binding {
                target: checks
                property: "contentX"
                value: sharedX
                when: !flickingHorizontally
            }
            //TODO: make it work or remove
            //atm synchronous flicking isn't even needed
        }
    }

    header: Column {
        width: parent.width
        height: taskRowHeight + resetDates.height

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

        Row {
            width: parent.width
            height: resetDates.height
            spacing: normalSpacing
            ListView {
                id: resetDates
                width: parent.width - titlePanelWidth - normalSpacing * 0.5
                //TODO: this is not maintainable code ^tm, need to get something done with titlePanelWidth
                //rework layout?
                height: 20
                spacing: normalSpacing
                orientation: Qt.Horizontal
                layoutDirection: Qt.RightToLeft
                model: tasks.getResetsQueryModel()
                interactive: false
                contentX: sharedX

                delegate: Rectangle {
                    width: taskRowHeight
                    height: 20
                    color: "grey"

                    function toJsDate(modelDate) {
                        //yyyy-MM-dd HH:mm:ss
                        return new Date(modelDate.substring(0, 4),
                                        modelDate.substring(5, 7),
                                        modelDate.substring(8, 10),
                                        modelDate.substring(11, 13),
                                        modelDate.substring(14, 16),
                                        modelDate.substring(17, 19))
                    }

                    Text {
                        anchors.centerIn: parent
                        text: model.date.substring(5, 10)
                    }
                    Binding {
                        when: index == 0
                        target: list
                        property: "lastReset"
                        value: toJsDate(model.date)
                    }
                }
                Connections {
                    target: tasks
                    onUpdateTasksModel: {
                        list.model = tasks.getTasksQueryModel()
                        resetDates.model = tasks.getResetsQueryModel()
                    }
                }
            }

            Text {
                width: titlePanelWidth
                height: resetDates.height
                verticalAlignment: Text.AlignVCenter

                Timer {
                    interval: 1000
                    repeat: true
                    running: lastReset
                    triggeredOnStart: true

                    onTriggered: {
                        var timeDifference = new Date().getTime() - lastReset.getTime()
                        parent.text = !lastReset ? "" :
                                timeDifference < 1000 * 60 * 60 * 24 ?
                                    new Date(timeDifference).toISOString().slice(11, -1).substring(0, 8) :
                                    qsTr("over 24 hours")
                        //TODO: support differences bigger than 24h
                    }
                }
            }
        }
    }
}
