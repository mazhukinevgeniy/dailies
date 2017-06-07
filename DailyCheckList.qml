import QtQuick 2.0

ListView {
    id: list
    model: tasks.getChecksQueryModel(taskListDelegate.taskId)

    orientation: Qt.Horizontal
    layoutDirection: Qt.RightToLeft
    spacing: normalSpacing

    delegate: DailyCheckListDelegate {}

    Connections {
        target: visible ? tasks : null

        onUpdateChecksModel: {
            list.model = tasks.getChecksQueryModel(taskListDelegate.taskId)
        }
    }
}
