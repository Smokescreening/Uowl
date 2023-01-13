import QtQuick 2.12
import QtQuick.Controls 2.12

import "../Body/TaskBuild.js" as TB

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
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            cursorShape: Qt.PointingHandCursor
            Menu {
                    id: contextMenu
                    background: Rectangle{
                        implicitWidth: 140
                        radius: 8
                        border.color: "green"
                        color: "transparent"
                    }
                    Action {
                        text: "del"
                        onTriggered:{
                            TB.delState(mgElement.parent.parent.parent.parent.root, stateName)
                            mgElement.destroy(10)
                            sigStateIndex("goto")

                        }}
                }
            onClicked: function(mouse){
                if(mouse.button === Qt.RightButton){
                    contextMenu.open()
                }else{
                    sigStateIndex(mgElement.stateName)
                }
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
