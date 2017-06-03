import QtQuick 2.0

Flickable {
    Column {
        width: parent.width
        height: repeater.count * (taskRowHeight + normalSpacing)
        y: normalSpacing * 0.5
        spacing: normalSpacing

        Repeater {
            id: repeater
            width: parent.width

            model: ListModel {
                ListElement {
                    title: "Default task A"
                    age: 3
                }
                ListElement {
                    title: "Default task B"
                    age: 15
                }
            }

            delegate: TaskListRowDelegate {}
        }
    }
}
