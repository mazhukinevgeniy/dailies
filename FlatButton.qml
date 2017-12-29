import QtQuick 2.0

MouseArea {
    property alias text: textItem.text

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0.8, 0.8, 0.8, 1)
    }

    Text {
        id: textItem
        anchors.fill: parent
        text: "flat button"

        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }
}
