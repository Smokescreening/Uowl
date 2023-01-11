import QtQuick 2.12
import QtQuick.Controls 2.12

//import "./UDialog.qml"
import "./MachineGraph.js" as MG

Item {
    id:machineGraph
    clip: true
    property string stateIndex: "goto"  //当前处于第几个状态
    property var transitionsList: []
    property var statePosList: []


    signal sigAddNewState(string stateName)  //添加状态的时候发出

    MouseArea{
        id: mouseI
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        Menu {
                id: contextMenu
                background: Rectangle{
                    implicitWidth: 140
                    radius: 8
                    border.color: "green"
                    color: "transparent"
                }
                Action {
                    text: "添加新的状态"
                    onTriggered:{
                        newNaemDialog.open()
                    }}
                Action { text: "Copy" }
                Action { text: "Paste" }
            }
        onClicked: function(mouse){
            if (mouse.button === Qt.RightButton){
                    contextMenu.popup(mouse.x,mouse.y)
            }
            else{
                     contextMenu.close()
                }
        }
    }


    //画线的容器
    Canvas{
        id:allLine
        anchors.fill: parent
        property var ctx : null
        onPaint: {
            allLine.ctx = getContext("2d");
            allLine.ctx.fillStyle ="#green";           // 设置画笔属性
            allLine.ctx.strokeStyle = "#ffffff";
            allLine.ctx.lineWidth = 1
            ctx.fillStyle = "#ffffff"
            allLine.ctx.font = "12px '仿宋'"
            MG.drawLine(allLine.ctx, machineGraph.statePosList, machineGraph.transitionsList, parent.width, parent.height)
        }

        Component.onCompleted: {
        }

    }

    //一个装所有节点的容器
    Item {
        id: allItem
        anchors.fill: parent
        Component.onCompleted: {
            MG.loadRender(allItem, machineGraph.statePosList)
        }
        onWidthChanged: {
            MG.updateRender(allItem, machineGraph.statePosList)
        }
        onHeightChanged: {
            MG.updateRender(allItem, machineGraph.statePosList)
        }
    }


    Text {
        id: taskName
        text: qsTr("地域鬼王")
        color: "#ffffff"
        font.bold: true
        font.pixelSize: 24
    }
    UDialog{
        id:newNaemDialog
        title: "stateName"
        TextInput{
            id:dialogText
            color: "#663399"
            font.bold: true
            text: "state new"
            selectByMouse: true //默认鼠标选取文本设置为false
            selectedTextColor: "yellow" //选中文本的颜色
            selectionColor: "white"
        }
        function buttonClicked(label){
            if(label==="确定"){
            MG.addNewState(allItem, dialogText.text, 0.5, 0.5 )
            newNaemDialog.close()
            }else if(label === "取消")
            {newNaemDialog.close()}
        }
        Component.onCompleted: {
           newNaemDialog.footerButtonClicked.connect(buttonClicked)
        }
    }


    Component.onCompleted: {

    }


    //从ele传信息过来
    function slotStateIndex(stateName){
        console.debug(stateName)
        for(var i=0; i<allItem.children.length; i++ ){
            var ele = allItem.children[i]
            if(ele.stateName === machineGraph.stateIndex){
                ele.select(false)
            }
            if(ele.stateName === stateName){
                ele.select(true)
            }

        }
        machineGraph.stateIndex=stateName

    }
    //从ele传过来的坐标改变
    function slotStatePosChange(stateName, x, y){
        console.debug(x, y)
        for(var i=0; i<statePosList.length; i++ ){
            var ele = allItem.children[i]
            if(ele.stateName === stateName){
               machineGraph.statePosList[i]["x"] = x/machineGraph.width
               machineGraph.statePosList[i]["y"] = y/machineGraph.height
            }
        }
    }
}
