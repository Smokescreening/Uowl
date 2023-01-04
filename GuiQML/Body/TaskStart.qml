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
        color: "#4dffffff"
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
                text: qsTr("任务xxx")
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
                text: qsTr("状态xxx")
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
                text:"40:22"
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
                logContent:"16:33.444: fjefjeiefjieiefjfeji"
            }
            ListElement{
                logContent:"15:33.444: 分解飞机飞积分奖励啊姐儿俩金额"
            }
            ListElement{
                logContent:"12:33.444: 啊而分解iojf阿里积分ieja路径飞机"
            }
            ListElement{
                logContent:"16:33.444: fjefjeiefjieiefjfeji"
            }
            ListElement{
                logContent:"15:33.444: 分解飞机飞积分奖励啊姐解飞解飞机飞积分奖励啊姐解飞机飞积分奖励啊姐儿俩机飞积分奖励啊姐儿俩金儿俩金额"
            }
            ListElement{
                logContent:"12:33.444: 啊而分解iojf阿里积分ieja路径飞机"
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
                    color: "#663399"
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
                    bridge.sigPresentTasks("continue")
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
        log4.sigUIShowLog.connect(slotUIShowLog)
        bridge.sigUIUpdateProgressBar.connect(slotUIUpdateProgressBar)
        bridge.sigUIUpdateRemainTime.connect(slotUIUpdateRemainTime)
        bridge.sigUIUpdatePresentTask.connect(slotUIUpdatePresentTask)
        bridge.sigUIUpdatePresentState.connect(slotUIUpdatePresentState)
    }

    function slotUIShowLog(grade, info){
        var log = {}
        log.logContent = info
        logListModel.append(log)
        if(logListModel.count > 30){
            logListModel.remove(0)
        }
    }
    function slotUIUpdateProgressBar(value){
        controlProgress.value = value
    }
    function slotUIUpdateRemainTime(text){
        remainTime.text = text
    }
    function slotUIUpdatePresentTask(taskName){
        presentTask.text = taskName
    }
    function slotUIUpdatePresentState(stateName){
        presentState.text = stateName
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
