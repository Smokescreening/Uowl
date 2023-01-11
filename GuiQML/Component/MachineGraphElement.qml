import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    id: mgElement
    property string stateName: ""
    property var controlInfo: {null}
    signal sigStateIndex(string stateName)
    signal sigStatePosChange(string stateName, int x, int y)

    RoundButton {
        id: button
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        radius: 12
        clip: true
        background: Rectangle{
            id:bg
//            color: ma.containsMouse?"#663399":"#ffffff"
            radius: 12
        }
        MouseArea{
            id:ma
            hoverEnabled: true
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                sigStateIndex(mgElement.stateName)
            }
            onEntered: { bg.color = "#663399"}
            onExited: {
                bg.color = "#ffffff"}
            drag.target: mgElement
            onReleased: {
                sigStatePosChange(mgElement.stateName, mgElement.x, mgElement.y)
            }

        }

    }
    Text {
        id: name
        text: parent.stateName
        anchors.top: button.bottom
        color: "#ffffff"
        font.bold: true
        font.pixelSize: 12
    }


    function updateInfo(controlInfo, parentWidth, parentHeight){
        mgElement.x = controlInfo["x"]*parentWidth - mgElement.width/2
        mgElement.y = controlInfo["y"]*parentHeight - mgElement.height/2
    }

    function select(val){
        if(val === true){
            bg.color= "#663399"
        }else{
            bg.color = "#ffffff"
        }

    }
}
