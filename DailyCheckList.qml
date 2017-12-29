import QtQuick 2.0
import QtGraphicalEffects 1.0

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

    Item {
        width: tileWidth
        height: width

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
