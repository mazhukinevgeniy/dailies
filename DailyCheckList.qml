import QtQuick 2.0

ListView {
    id: list
    model: ListModel {
        ListElement {
            date: "tomorrow"
        }
        ListElement {
            date: "today"
        }
        ListElement {
            date: "yesterday"
        }
    }

    orientation: Qt.Horizontal
    layoutDirection: Qt.RightToLeft
    spacing: normalSpacing

    delegate: DailyCheckListDelegate {}

    Connections {
        target: list.visible ? app : null

        onNewDay: {
            model.append({"date": "yet another date"})
        }//TODO: move it elsewhere and just update underlying sql for all models
    }
}
