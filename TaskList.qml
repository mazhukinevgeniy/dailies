import QtQuick 2.0

Flickable {
    flickableDirection: Flickable.VerticalFlick

    Column {
        id: mainColumn
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
                }
                ListElement {
                    title: "Default task B"
                }
                ListElement {
                    title: ""
                }
            }

            delegate: TaskListRowDelegate {}
        }
    }
}
