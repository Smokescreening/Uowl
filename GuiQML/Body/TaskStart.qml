import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import Qt5Compat.GraphicalEffects
import QtQml.Models 2.15

Item {
    id:taskStart
    anchors.fill: parent
    property int runState: 0  //0是任务不运行  1是正在运行中 2是暂停中

    Rectangle{
        id:startRectangle
        width: parent.width
        anchors.top: parent.top
        anchors.bottom: taskControl.top
        anchors.bottomMargin: 8
        radius: 8
//        color: "#4dffffff"
        color: "transparent"
//        opacity: 0.5
        border.color: "#ffffff"
        border.width: 1
        clip: true
        //任务状态
        Row{
            id:runState
            anchors.top: parent.top
            anchors.topMargin: 8
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 4
            Text {
                text: qsTr("当前任务:")
                color: "#ffffff"
                font.bold: true
                font.pixelSize: 18
            }
            Text {
                id:presentTask
                text: qsTr("xxx")
                color: "#ffffff"
                font.bold: true
                font.pixelSize: 18
            }
            Text {
                text: qsTr("当前状态:")
                color: "#ffffff"
                font.bold: true
                font.pixelSize: 18
            }
            Text {
                id:presentState
                text: qsTr("xxx")
                color: "#ffffff"
                font.bold: true
                font.pixelSize: 18
            }
        }
        //进度条
        Item{
            id:runProgressBar
            width: parent.width
            height: 18
            anchors.top: runState.bottom
            anchors.topMargin: 4
            ProgressBar{
                id:controlProgress
                anchors.left: parent.left
                anchors.leftMargin: 16
                anchors.right: remainTime.left
                anchors.rightMargin: 8
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                value: 0
                background: Rectangle{
                    implicitHeight: controlProgress.height
                    implicitWidth: controlProgress.width
                    color: "#80ffffff"
                    radius: 8
                }
                contentItem: Item{
                    id:runProgressBarItem
                    Rectangle{
                    width: controlProgress.visualPosition * controlProgress.width
                    height: controlProgress.height
                    color: "#663399"
                    radius: 8
                    }
                }
            }
            Label{
                id:remainTime
                width: 60
                anchors.right: parent.right
                anchors.rightMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                text:"00:00"
                color: "#ffffff"
            }
//            Image {
//                anchors.bottom: parent.bottom
//                //anchors.left: parent.left+ (runProgressBar-remainTime.width) * 0.2
//                height: parent.height
//                width: parent.height
//                source: "../../GuiImage/window/dishitian_run_progress.png"
//            }
        }
        // 日志输出-模型
        ListModel{
            id:logListModel
            ListElement{
                logContent:"嘻嘻！！！"
            }
        }
        // 日记输出-委托
        Component{
            id:logListDelegate
            Item {
                width: logListView.width
                height: 24
                clip: true
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: logContent
                    color: "#ffffff"
                    font.bold: false
                    font.pixelSize: 14
                }
            }
        }
        // 日记输出-视图
        Item{
            id:logListView
             anchors.left: parent.left
             anchors.leftMargin: 16
             anchors.right: parent.right
             anchors.rightMargin: 16
             anchors.top:runProgressBar.bottom
             anchors.topMargin: 8
             anchors.bottom: parent.bottom
             anchors.bottomMargin: 8
             ListView{
                 anchors.fill: parent
                 model:logListModel
                 delegate:logListDelegate
                 add: Transition {
                     ParallelAnimation{
                      NumberAnimation { properties: "y"; from: logListView.height; duration: 300 }
                      NumberAnimation {
                                  property: "opacity"
                                  from: 0.4
                                  to: 1.0
                                  duration: 300
                              }
                     }
                 }
             }
        }
    }
    //这个外阴影由于前面矩形为不是全部填充的所以里面会变成黑色就不适应这个阴影
//    DropShadow
//    {
//        anchors.fill: startRectangle
//        radius: 8.0
//        samples: 16
//        color: "#dd000000"
//        source: startRectangle
//     }
    Row{
        id:taskControl
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        spacing: 18
        Button{
            width: 70
            height: 28
            background: Rectangle{
                id:backgroundRectangle1
                anchors.fill: parent
                radius: 16
                color:  (taskStart.runState === 0)? "#FFB5D83C":"#33B5D83C"
                border.color: "#80ffffff"
                border.width: 1
            }
            DropShadow
            {
                anchors.fill: backgroundRectangle1
                radius: 8
                samples: 16
                color: "#B5D83C"
                source: backgroundRectangle1
             }
            contentItem:Text {
                text: {if(taskStart.runState === 0){
                        return qsTr("启动")
                    }
                    else if(taskStart.runState === 1){
                        return qsTr("暂停")
                    }
                    else if(taskStart.runState === 2){
                        return qsTr("继续")
                    }
                }
                color: "#ffffff"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            MouseArea{
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if(taskStart.runState === 0){
                    taskStart.runState = 1  //运行
                    bridge.sigPresentTasks("start")
                }
                else if(taskStart.runState === 1){
                    taskStart.runState = 2 //暂停
                    bridge.sigPresentTasks("pause")
                }
                else if(taskStart.runState === 2){
                    taskStart.runState = 1 //继续
                    bridge.sigPresentTasks("resume")
                }
            }
            }
        }
        //停止按钮
        Button{
            width: 70
            height: 28
            background: Rectangle{
                id:backgroundRectangle2
                anchors.fill: parent
                radius: 16
                color:  (taskStart.runState === 0)? "#33B5D83C":"#FFB5D83C"
                border.color: "#80ffffff"
                border.width: 1
            }
            DropShadow
            {
                anchors.fill: backgroundRectangle2
                radius: 8
                samples: 16
                color: "#B5D83C"
                source: backgroundRectangle2
             }
            contentItem:Text {
                text: qsTr("停止")
                color: "#ffffff"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            MouseArea{
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if(taskStart.runState === 1){
                    taskStart.runState = 0
                    bridge.sigPresentTasks("stop")
                }
                else if(taskStart.runState === 2){
                    taskStart.runState = 0  //运行
                    bridge.sigPresentTasks("stop")
                }
            }
            }
        }
    }
    Component.onCompleted: {
    }



    //更新内容
    function settUIShowLog(grade, info){
        var log = {}
        log.logContent = info
        logListModel.append(log)
        if(logListModel.count > 30){
            logListModel.remove(0)
        }
    }
    //进度条
    function setUIUpdateProgressBar(value){
        controlProgress.value = value
    }
    //剩余时间
    function setUIUpdateRemainTime(text){
        remainTime.text = text
    }
    //当前任务
    function setUIUpdatePresentTask(taskName){
        presentTask.text = taskName
    }
    //当前状态
    function setUIUpdatePresentState(stateName){
        presentState.text = stateName
    }
    // 槽函数
    function setUIRunState(value){
        taskStart.runState = value
    }

    onRunStateChanged: {
        if(taskStart.runState === 0){
            menuPane.menuOpen()
        }
        else{
            menuPane.menuClose()
        }
    }
}
