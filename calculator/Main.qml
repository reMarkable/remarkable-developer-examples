import QtQuick
import QtQuick.Layouts

Window {
    id: calculator

    width: Screen.width
    height: Screen.height
    title: "Calculator"
    visible: true

    property string display: "0"
    property string memory
    property string operation
    property bool newNumber: true

    function handleButtonPress(model) {
        if (model.isSpecial) {
            switch (model.text) {
            case "C":
                display = "0";
                memory = "";
                operation = "";
                newNumber = true;
                break;

            case "+/-":
                display = (parseFloat(display) * -1).toString();
                break;

            case "%":
                display = (parseFloat(display) / 100).toString();
                break;

            case "=":
                if (!operation) { return }

                const num1 = parseFloat(memory);
                const num2 = parseFloat(display);
                let result = 0;

                switch (operation) {
                case "+": result = num1 + num2; break;
                case "-": result = num1 - num2; break;
                case "×": result = num1 * num2; break;
                case "/":
                    if (num2 !== 0) {
                        result = num1 / num2;
                    } else {
                        result = 0;
                    }
                    break;
                }
                display = isFinite(result) ? result.toString() : "Error";
                operation = "";
                memory = "";
                newNumber = true;
                break;
            }
        } else if (model.isOp) {
            operation = model.op;
            memory = display;
            newNumber = true;
        } else if (model.text === ".") {
            if (!display.includes(".")) {
                display += ".";
            }
        } else {
            if (newNumber) {
                display = model.text;
                newNumber = false;
            } else {
                if (display === "0" && model.text !== ".") {
                    display = model.text;
                } else {
                    display += model.text;
                }
            }
        }
    }

    property ListModel buttonModel: ListModel {
        ListElement { text: "C"; isSpecial: true ; inverted: true }
        ListElement { text: "+/-"; isSpecial: true }
        ListElement { text: "%"; isSpecial: true }
        ListElement { text: "÷"; isOp: true; op: "/" }
        ListElement { text: "7" }
        ListElement { text: "8" }
        ListElement { text: "9" }
        ListElement { text: "×"; isOp: true; op: "×" }
        ListElement { text: "4" }
        ListElement { text: "5" }
        ListElement { text: "6" }
        ListElement { text: "-"; isOp: true; op: "-" }
        ListElement { text: "1" }
        ListElement { text: "2" }
        ListElement { text: "3" }
        ListElement { text: "+"; isOp: true; op: "+" }
        ListElement { text: "0"; isWide: true }
        ListElement { text: "." }
        ListElement { text: "="; isSpecial: true; inverted: true }
    }

    component Button: Rectangle {
        id: button

        signal clicked

        property string text
        property bool inverted
        property bool isWide
        property color foregroundColor: inverted ? "red" : "white"
        property color backgroundColor: inverted ? "white" : "black"

        color: touch.pressed ? backgroundColor : foregroundColor
        border.color: backgroundColor
        border.width: 4

        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.columnSpan: isWide ? 2 : 1

        Text {
            anchors.centerIn: parent
            text: button.text
            font.pixelSize: 60
            antialiasing: false
            color: touch.pressed ? foregroundColor : backgroundColor
        }

        MouseArea {
            id: touch
            anchors.fill: parent
            onClicked: button.clicked()
        }
    }

    Rectangle {
        id: dropShadow
        color: "gray"
        width: background.width
        height: background.height
        radius: background.radius
        anchors.centerIn: background
        anchors.horizontalCenterOffset: 10
        anchors.verticalCenterOffset: 10
    }

    Rectangle {
        id: background
        color: "black"
        anchors.fill: layout
        border.color: "black"
        radius: 20
    }

    ColumnLayout {
        id: layout

        width: parent.width - 300
        height: width
        anchors.centerIn: parent

        Rectangle {
            id: displayField

            color: "white"
            radius: 10

            Layout.preferredHeight: 220
            Layout.fillWidth: true
            Layout.margins: 30
            Layout.bottomMargin: 0

            Text {
                anchors.fill: parent
                anchors.margins: 50
                text: display
                font.pixelSize: 100
                horizontalAlignment: Qt.AlignRight
                antialiasing: false
                Layout.margins: 20
                clip: true
            }
        }

        GridLayout {
            id: buttonGrid

            columns: 4
            rowSpacing: 6
            columnSpacing: 6

            Layout.margins: 30
            Layout.fillWidth: true
            Layout.fillHeight: true

            Repeater {
                model: buttonModel
                delegate: Button {
                    text: model.text
                    inverted: model.inverted || false
                    isWide: model.isWide || false
                    onClicked: handleButtonPress(model)
                    border.color: "white"
                }
            }
        }
    }
}
