import QtQuick 2.12
import QtQuick.Controls 2.12

Switch {
    id: root
//    width: 34
//    height: 22
    property color checkedColor: "#663399"

    indicator: Rectangle {
        width: 36
        height: 20
        radius: height / 2
        color: root.checked ? checkedColor : "white"
        border.width: 2
        border.color: root.checked ? checkedColor : "#E5E5E5"

        Rectangle {
            x: root.checked ? parent.width - width - 2 : 1
            width: root.checked ? parent.height - 4 : parent.height - 2
            height: width
            radius: width / 2
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            border.color: "#D5D5D5"

            Behavior on x {
                NumberAnimation { duration: 200 }
            }
        }
    }
}
