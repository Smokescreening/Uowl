import QtQuick 2.12
import QtQuick.Controls 2.12
import Qt5Compat.GraphicalEffects

Item {
    id:root
    anchors.fill: parent
    property var listG: {""}
    property var groupModel: ListModel{}
    property var taskModel: ListModel{}
    property int groupIndex: 0
    property int taskIndex: 0

    Rectangle{
        width: parent.width
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        radius: 8
        color: "transparent"
        border.color: "#ffffff"
        border.width: 1
        clip: true

    }
    //group list
    Rectangle{
        id:groupList
        width: 120
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        radius: 8
        color: "transparent"
        border.color: "#ffffff"
        border.width: 1
        clip: true
        Text {
            id: taskGoroup
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: "group"
            color: "#ffffff"
            font.bold: true
            font.pixelSize: 24
        }
        ListView{
            id:groupView
            anchors.top: taskGoroup.bottom
            width: parent.width
            anchors.bottom: parent.bottom
            model: groupModel
            delegate:Component{

                Text {
                    leftPadding: 4
                    width: groupList.width
                    height: 24
                    clip: true
                    verticalAlignment:  Qt.AlignVCenter
                    horizontalAlignment: Qt.AlignLeft
                    text: name
                    color: "#ffffff"
                    font.bold: false
                    font.pixelSize: 16
                    Rectangle{
                        anchors.fill: parent
                        color: (groupIndex===index)?"#4f663399":"transparent"
                    }
                    MouseArea{
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            groupIndex = index
                        }
                    }
                }
            }
        }
    }
    // task list
    Rectangle{
        id:taskList
        width: 180
        anchors.left: groupList.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        radius: 8
        color: "transparent"
        border.color: "#ffffff"
        border.width: 1
        clip: true
        Text {
            id: taskNameList
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: "task"
            color: "#ffffff"
            font.bold: true
            font.pixelSize: 24
        }
        ListView{
            id:taskView
            anchors.top: taskNameList.bottom
            width: parent.width
            anchors.bottom: parent.bottom
            model: taskModel
            delegate:Component{
                Text {
                    leftPadding: 4
                    width: taskView.width
                    height: 24
                    clip: true
                    verticalAlignment:  Qt.AlignVCenter
                    horizontalAlignment: Qt.AlignLeft
                    text: name
                    color: (taskIndex===index)?"#663399":"#ffffff"
                    font.bold: false
                    font.pixelSize: 16
//                    Rectangle{
//                        anchors.fill: parent
//                        color: (taskIndex===index)?"#4f663399":"transparent"
//                    }
                    MouseArea{
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            taskIndex = index
                        }
                    }
                }
            }
        }
    }
    // task description
    Item{
        id:descriptionItem
        anchors.left: taskList.right
        anchors.right: parent.right
        height: parent.height
        Text {
            leftPadding: 8
            id: taskName
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: "地狱鬼王"
            color: "#ffffff"
            font.bold: true
            font.pixelSize: 24
        }
        Text {
            id: description
            anchors.top: taskName.bottom
            anchors.topMargin: 8
            width: parent.width
            text: "这个是一个任务模板，点击open即可打开修改。关于任务的description请在taskConfigUI.json文件下、“description” 修改"
            color: "#ffffff"
            font.pixelSize: 14
            wrapMode: Text.WrapAnywhere
        }
    }
    // 按钮 open
    RoundButton{
        width: 50
        height: width
        radius: 25
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 4
        anchors.right: parent.right
        anchors.rightMargin: 4
        background: Rectangle{
            id:backgroundRectangle1
            anchors.fill: parent
            radius: 25
            color: "#FFB5D83C"
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
            text: "open"
            color: "#ffffff"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        MouseArea{
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            var rootSche = JSON.parse( configFile.readTaskScheduler())
            rootSche["list"] = JSON.parse(configFile.getGroupTaskList())["list"]
            rootSche["groupName"] = rootSche["list"][groupIndex]["name"]
            rootSche["taskName"] = rootSche["list"][groupIndex]["list"][taskIndex]["name"]
            configFile.writeTaskScheduler(JSON.stringify(rootSche))
            rootWindow.changeMenu(4)
        }
        }
    }
    Component.onCompleted: {
        listG = JSON.parse(configFile.getGroupTaskList())
        for(var i=0; i<listG["list"].length; i++){
            var g = {}
            g["name"] = listG["list"][i]["name"]
            groupModel.append(g)
        }
        for(var j=0; j<listG["list"][0]["list"].length; j++){
            var t = {}
            t["name"] = listG["list"][0]["list"][j]["name"]
            taskModel.append(t)
        }

    }
    onGroupIndexChanged: {
        taskModel.clear()
        for(var j=0; j<listG["list"][groupIndex]["list"].length; j++){
            var t = {}
            t["name"] = listG["list"][groupIndex]["list"][j]["name"]
            taskModel.append(t)
        }
    }
    onTaskIndexChanged: {
        var config = JSON.parse(configFile.readTaskConfigUI(listG["list"][groupIndex]["name"],
                                              listG["list"][groupIndex]["list"][taskIndex]["name"]))
        taskName.text = config["baseConfig"]["detail"][0]["eleVal"]
        description.text = config["description"]
    }

}
