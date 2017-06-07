import QtQuick 2.0

ListView {
    id: list
    spacing: normalSpacing

    model: tasks.getTasksQueryModel()

    delegate: Row {
        id: taskListDelegate
        width: parent.width
        height: taskRowHeight
        spacing: normalSpacing
        layoutDirection: Qt.RightToLeft

        property var taskId: model.taskId

        Text {
            id: rowDescription
            width: titlePanelWidth - normalSpacing * 0.5
            height: parent.height
            text: model.description
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
        }

        DailyCheckList {
            id: checks
            width: parent.width - titlePanelWidth - normalSpacing * 0.5
            height: parent.height
        }
    }

    Connections {
        target: tasks

        onUpdateTasksModel: {
            list.model = tasks.getTasksQueryModel()
        }
    }
}
