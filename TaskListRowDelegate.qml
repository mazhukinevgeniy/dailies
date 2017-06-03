import QtQuick 2.0

Row {
    width: parent.width
    height: taskRowHeight
    spacing: normalSpacing
    layoutDirection: Qt.RightToLeft

    Text {
        id: rowDescription
        width: titlePanelWidth - normalSpacing * 0.5
        height: parent.height
        text: model.title
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
    }

    DailyCheckList {
        id: checks
        width: parent.width - titlePanelWidth - normalSpacing * 0.5
        height: parent.height

        visible: model.title !== ""
    }

    states: [
        State {
            name: "imaginary"
            when: model.title === ""

            PropertyChanges {
                target: checks
                visible: false
            }
            PropertyChanges {
                target: rowDescription
                text: qsTr("Start typing...")
            }
        }
    ]
}
