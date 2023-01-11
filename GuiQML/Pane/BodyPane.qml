import QtQuick 2.12
import QtQuick.Controls 2.12

import "../Body"
Item {
    Loader{
        id:bodyLoader
        anchors.fill: parent
        Component.onCompleted: {
            bodyLoader.source="../Body/TaskBuild.qml"
            log4.sigUIShowLog.connect(slotUIShowLog)
            bridge.sigUIUpdateProgressBar.connect(slotUIUpdateProgressBar)
            bridge.sigUIUpdateRemainTime.connect(slotUIUpdateRemainTime)
            bridge.sigUIUpdatePresentTask.connect(slotUIUpdatePresentTask)
            bridge.sigUIUpdatePresentState.connect(slotUIUpdatePresentState)
        }
    }

    function changeBodySource(num){
        if(num === 0){
            bodyLoader.source="../Body/SettingBoby.qml"
        }else if(num === 1){
            bodyLoader.source="../Body/TaskStart.qml"
        }else if(num === 2){
            bodyLoader.source="../Body/TaskQueue.qml"
        }else if(num === 3){
            bodyLoader.source="../Body/TaskList.qml"
        }else if(num === 4){
            bodyLoader.source="../Body/TaskBuild.qml"
        }
    }

    function slotUIShowLog(grade, info){
        if(menuPane.menuPaneFlag === 1 ){
            bodyLoader.item.settUIShowLog(grade, info)
        }
        else{
            snackbar.open(info)
        }
    }
    function slotUIUpdateProgressBar(value){
        if(menuPane.menuPaneFlag === 1){
            bodyLoader.item.setUIUpdateProgressBar(value)
        }
    }
    function slotUIUpdateRemainTime(text){
        if(menuPane.menuPaneFlag === 1){
            bodyLoader.item.setUIUpdateRemainTime(text)
        }
    }
    function slotUIUpdatePresentTask(taskName){
        if(menuPane.menuPaneFlag === 1){
            bodyLoader.item.setUIUpdatePresentTask(taskName)
        }
    }
    function slotUIUpdatePresentState(stateName){
        if(menuPane.menuPaneFlag === 1){
            bodyLoader.item.setUIUpdatePresentState(stateName)
        }
    }
}
