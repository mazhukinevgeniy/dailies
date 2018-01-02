import QtQuick 2.0
import QtQuick.Controls 2.1

BaseDialog {
    id: dialog
    interactive: true
    contentWidth: tileWidth * 4
    contentHeight: tileWidth * 3 + normalSpacing * 2

    property string text: ""

    signal confirm()
    signal decline()

    contentDelegate: Column {
        width: contentWidth
        height: contentHeight
        spacing: normalSpacing

        Item {
            height: tileWidth
            width: contentWidth
            Text {
                anchors.centerIn: parent
                text: dialog.text
            }
        }


        Button {
            height: tileWidth
            width: contentWidth
            text: qsTr("Yes please")

            onClicked: {
                confirm()
            }
        }

        Button {
            height: tileWidth
            width: contentWidth
            text: qsTr("Just kidding")

            onClicked: {
                decline()
            }
        }
    }

    onClickedOutside: {
        decline()
    }
}
