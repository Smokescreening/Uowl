import QtQuick 2.12
import QtQuick.Controls 2.12

import "../Body"
Item {
    Loader{
        id:bodyLoader
        anchors.fill: parent
        Component.onCompleted: {
            bodyLoader.source="../Body/TaskStart.qml"
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
}
