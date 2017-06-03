import QtQuick 2.0

Row {
    width: parent.width
    height: taskRowHeight
    spacing: normalSpacing

    DailyCheckList {
        width: parent.width - titlePanelWidth - normalSpacing * 0.5
        height: parent.height
    }

    Text {
        width: titlePanelWidth - normalSpacing * 0.5
        height: parent.height
        text: model.title
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
    }
}
