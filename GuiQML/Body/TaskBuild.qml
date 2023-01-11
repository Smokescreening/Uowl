import QtQuick 2.12
import QtQuick.Controls 2.12

import "../Component"

Item { 
    Component.onCompleted: {
        taskBuild.rootjson = JSON.parse(configFile.readTaskConfigUI("DailyGroup", "DiGui"))
        machineGraph.transitionsList = rootjson["transitionsList"]
        machineGraph.statePosList = rootjson["statePosList"]

    }
    property var rootjson: {""}
    id: taskBuild
    BuildMenu{
        id: tBuildMenu
        height: parent.height
        width: 200
        anchors.right: parent.right
    }
    Item{
        height: parent.height
        anchors.left: parent.left
        anchors.right: tBuildMenu.left
        MachineGraph{
            id: machineGraph
            width: parent.width
            anchors.top: parent.top
            anchors.bottom: splitLine.top
        }
        Rectangle{
            id: splitLine
            width: parent.width
            height: 8
            y: 500
            radius: 3
            color: "#FFCC00"
            MouseArea{
                id: splitLineMouseArea
                anchors.fill: parent
                property int lastY: 0
                hoverEnabled: true
                cursorShape: (containsMouse
                              ?Qt.SizeVerCursor
                              :Qt.ArrowCursor);
                onPressedChanged: {
                    //按下鼠标记录坐标
                    if(containsPress){
                        lastY = mouseY
                    }

                }
                onPositionChanged: {
                    if(pressed){
                        if( parent.y<=taskBuild.height-160 &&  parent.y>=160 ){
                        parent.y += mouseY - lastY
                        }
                        if(parent.y<160){
                            parent.y=160
                        }
                        if(parent.y >= taskBuild.height-160){
                            splitLine.y = taskBuild.height-160
                        }
                    }
                }
            }
        }
        BuildContents{
            id: tContexts
            width: parent.width
            anchors.top: splitLine.bottom
            anchors.bottom: parent.bottom
        }

    }


}
