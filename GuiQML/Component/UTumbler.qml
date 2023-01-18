import QtQuick 2.12
import QtQuick.Controls 2.12
import Qt5Compat.GraphicalEffects

Tumbler {
    id: root
    width: 100

    property color currentItemColor: "#663399"

    visibleItemCount: 5

    delegate: Text {
        text: modelData
        color: root.currentItemColor

//        font.family: "Arial"
//        font.weight: Font.Thin
        font.pixelSize: 40

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        opacity: 1.0 - Math.abs(Tumbler.displacement) / root.visibleItemCount
        scale: opacity
    }

    background: Rectangle {
        width: root.width;
        height: root.height

        layer.enabled: root.hovered
        layer.effect: DropShadow {
            transparentBorder: true
            color: root.currentItemColor
            samples: 5 /*20*/
        }
    }
}
