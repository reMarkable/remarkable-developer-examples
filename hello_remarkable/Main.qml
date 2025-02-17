import QtQuick
import QtQuick.Window

Window {
    width: Screen.width
    height: Screen.height
    visible: true

    Text {
        id: hello_text
        x: 50
        y: 50
        font.pixelSize: 32
        text: "Hello Cleveland!"
    }

    MouseArea {
        anchors.fill: parent
        onPressed: {
            hello_text.visible = !hello_text.visible
        }
    }
}

