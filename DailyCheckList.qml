import QtQuick 2.0

ListView {
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
}
