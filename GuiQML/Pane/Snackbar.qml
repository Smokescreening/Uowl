import QtQuick 2.5
import QtQuick.Controls 2.12

Rectangle{
    id: snackbar

    property color buttonColor: "#2196f3"
    property string text
    property bool opened
    property int duration: 2000

    anchors{
        left: parent.left
        leftMargin: 72
        bottom: parent.bottom
        bottomMargin: opened? 12 : 0

        Behavior on bottomMargin {
            NumberAnimation { duration: 400; easing.type: Easing.OutQuad }
        }
    }
    radius: 3
    color: "#cc323232"
    height: 48
    width: snackbarLabel.width+50
    opacity: opened ? 1 : 0

    Timer {
        id: timer

        interval: snackbar.duration

        onTriggered: {
            if (!running) {
                snackbar.opened = false;
            }
        }
    }

    Label{
        id: snackbarLabel
        anchors.centerIn: parent
        text: snackbar.text
        color: "white"
    }

    function open(text) {
        snackbar.text = text
        opened = true;
        timer.restart();
    }


}
