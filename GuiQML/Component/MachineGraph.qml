import QtQuick 2.12
import QtQuick.Controls 2.12

//import "./UDialog.qml"
import "./MachineGraph.js" as MG
import "../Body/TaskBuild.js" as TB

Item {
    id:machineGraph
    clip: true
    property string stateIndex: "goto"  //当前处于第几个状态
    property var transitionsList: []

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
                    text: "new state"
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
            var posList = TB.getStatePosList(machineGraph.parent.parent.root)
            var transList = TB.getTransitionsList(machineGraph.parent.parent.root)
            MG.drawLine(allLine.ctx, posList, transList, parent.width, parent.height)
        }

        Component.onCompleted: {
        }

    }

    //一个装所有节点的容器
    Item {
        id: allItem
        anchors.fill: parent
        Component.onCompleted: {
            var statePostList = []
            for(let statet of machineGraph.parent.parent.root["stateList"]){
                var pos ={"stateName":statet["name"], "x":statet["x"], "y":statet["y"]}
                statePostList.push(pos)
            }
            MG.loadRender(allItem, statePostList)
        }
        onWidthChanged: {
            var statePostList = []
            for(let stateq of machineGraph.parent.parent.root["stateList"]){
                var pos ={"stateName":stateq["name"], "x":stateq["x"], "y":stateq["y"]}
                statePostList.push(pos)


            }
            MG.updateRender(allItem, statePostList)
        }
        onHeightChanged: {
            var statePostList = []
            for(let statey of machineGraph.parent.parent.root["stateList"]){
                var pos ={"stateName":statey["name"], "x":statey["x"], "y":statey["y"]}
                statePostList.push(pos)
            }
            MG.updateRender(allItem, statePostList)
        }
    }


    Text {
        id: taskName
        text: machineGraph.parent.parent.root["baseConfig"]["detail"][0]["eleVal"]
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
                var js = TB.newState(dialogText.text, 0.5, 0.5)
                TB.addState(machineGraph.parent.parent.root, js)

                var fileName = "MachineGraphElement.qml"
                var temp ={"stateName":dialogText.text, "x":"0.5", "y":"0.5"}
                var obj = Qt.createComponent(fileName).createObject(allItem, {"controlInfo":temp})
                obj.updateInfo(temp, allItem.width, allItem.height)
                obj.stateName = dialogText.text
                obj.sigStateIndex.connect(allItem.parent.slotStateIndex)
                obj.sigStatePosChange.connect(allItem.parent.slotStatePosChange)

                allItem.parent.sigAddNewState(dialogText.text)
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
        console.debug("点击状态为"+stateName)
        for(var i=0; i<allItem.children.length; i++ ){
            var ele = allItem.children[i]
            //取消之前的点的颜色
            if(ele.stateName === machineGraph.stateIndex){
                ele.select(false)
            }
            //设置新点的颜色
            if(ele.stateName === stateName){
                ele.select(true)
            }

        }
        machineGraph.stateIndex=stateName

    }
    //从ele传过来的坐标改变
    function slotStatePosChange(stateName, x, y){
        console.debug(x, y)
        for(var i=0; i<machineGraph.parent.parent.root["stateList"].length; i++ ){
            var ele = machineGraph.parent.parent.root["stateList"][i]
            if(ele.name === stateName){
               machineGraph.parent.parent.root["stateList"][i]["x"] = x/machineGraph.width
               machineGraph.parent.parent.root["stateList"][i]["y"] = y/machineGraph.height
            }
        }
    }
}
