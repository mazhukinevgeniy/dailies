import QtQuick 2.0

BaseDialog {
    interactive: false

    contentDelegate: Item {
        Image {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 15
            width: sourceSize.width * 0.55
            height: sourceSize.height * 0.55
            source: "assets/setter.jpeg"
        }

        Column {
            anchors.fill: parent
            anchors.margins: 30
            spacing: normalSpacing

            Repeater {
                model: [
                    "Icons are designed by Madebyoliver from Flaticon",
                    "Flaticon is discovered by Elimohl, a good friend and a brave heron",
                    "Herons are created by great many days of evolution",
                    "Click anywhere to hide this info"
                ]
                Text { text: modelData }
            }
        }
    }
}
