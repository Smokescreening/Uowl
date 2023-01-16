import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQml.Models 2.15
import QtQuick.Layouts 1.12
import Qt5Compat.GraphicalEffects

import "../Component"

Item {
    id:rootQueue
    anchors.fill: parent
    property var rootSche: {""}
    property string forthwithCurrentQueue: ""  //每次这个更新的时候更新页面
    property var forthwithListModel: ListModel{}
    property var weeklyListModel: ListModel{}
    property var dailyListModel: ListModel{}

    //每周
    Rectangle{
        id: weeklyBackground
        height: parent.height
        width: (rootQueue.width-24)/3
        anchors.left: parent.left
        radius: 8
        color: "#33ffffff"
        border.color: "#ffffff"
        border.width: 1
        clip: true
        Text {
            id: weeklyLable
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 12
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: "weekly"
            color: "#ffffff"
            font.bold: true
            font.pixelSize: 24
        }
        DropShadow
        {
            anchors.fill: weelyTable
            radius: 8
            samples: 16
            color: "green"
            source: weelyTable
         }
        Rectangle{
            id:weelyTable
            width: parent.width-12
            height: 40
            anchors.top: weeklyLable.bottom
            anchors.topMargin: 8
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#33ffffff"
            radius: 8
            Label{
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                text: "task"
                color: "#ffffff"
                leftPadding: 4
                font.pixelSize: 18
                clip: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            Label{
                anchors.centerIn: parent
                text: "time"
                color: "#ffffff"
                font.pixelSize: 18
                clip: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            Label{
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                text: "random"
                color: "#ffffff"
                rightPadding: 8
                font.pixelSize: 18
                clip: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

        }
        ListView{
            id:weeklyListView
            width: parent.width
            anchors.top: weelyTable.bottom
            anchors.topMargin: 12
            anchors.bottom: rowWeeklyButton.top
            anchors.bottomMargin: 8
            model: weeklyListModel
            Component.onCompleted: {
                for(let item of rootSche["weekly"]){
                    weeklyListModel.append(item)
                }
            }
            delegate: Component{
                Item{
                    width: weeklyListView.width-8
                    height: 30
                    Text {
                        id: name
                        height: 30
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        text:  taskName
                        color: "#ffffff"
                        leftPadding: 8
                        font.pixelSize: 14
                        clip: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    Item{
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        height: 30
                        width: 100
                        Text {
                            id: weekText
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: "#ffffff"
                            font.pixelSize: 14
                            clip: true
                            text: week + " " + hour +":"+minute
                        }
                        Image {
                            anchors.left: weekText.right
                            anchors.leftMargin: 8
                            width: 20
                            height: width
                            anchors.verticalCenter: parent.verticalCenter
                            source: "../../GuiImage/window/SelectTime.png"
                        }
                    }
                    USwitch{
                        width: 40
                        height: 20
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                    }

                }
            }
        }
        RowLayout{
            id:rowWeeklyButton
            width: parent.width
            height: 30
            anchors.bottom: parent.bottom
            Button{
                Layout.preferredWidth: 70
                Layout.preferredHeight: 28
                Layout.alignment: Qt.AlignHCenter
                background: Rectangle{
                    anchors.fill: parent
                    radius: 4
                    color: "transparent"
                }
                contentItem:Text {
                    text: qsTr("添加")
                    color: "#ffffff"
                    font.bold: true
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                }
                UMenu{
                        id: weeklyAddMenu
                        Component.onCompleted: {
                            for(var i=0; i<rootSche["list"].length; i++){
                                weeklyAddMenu.addSubMenu(rootSche["list"][i])
                            }
                            sigTriggered.connect(addTrigger)
                        }
                        function addTrigger(sub, act){//actionName, subName
                            addWeekly(sub, act)
                        }
                }
                MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    weeklyAddMenu.open()
                }
                }
            }
            Button{
                Layout.preferredWidth: 70
                Layout.preferredHeight: 28
                Layout.alignment: Qt.AlignHCenter
                background: Rectangle{
                    anchors.fill: parent
                    radius: 4
                    color: "transparent"
                }
                contentItem:Text {
                    text: qsTr("删除")
                    color: "#ffffff"
                    font.bold: true
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                }
                UMenu{
                        id: weeklyDeleteMenu
                        Component.onCompleted: {
                            sigTriggered.connect(delTrigger)
                        }
                        function delTrigger(sub, act){//actionName, subName
                            deleteWeekly(sub, act)
                        }
                }
                MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    weeklyDeleteMenu.deleteAll()
                    for(let item of rootSche["weekly"]){
                        weeklyDeleteMenu.addOne(item["groupName"], item["taskName"])
                    }
                    weeklyDeleteMenu.open()
                }
                }
            }
        }

    }
    //每日
    Rectangle{
        id: dailyBackground
        height: parent.height
        anchors.left: weeklyBackground.right
        anchors.leftMargin: 12
        anchors.right: forthwithBackground.left
        anchors.rightMargin: 12
        radius: 8
        color: "#4dffffff"
        border.color: "#ffffff"
        border.width: 1
        clip: true
        Text {
            id: dailyLable
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 12
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: "daily"
            color: "#ffffff"
            font.bold: true
            font.pixelSize: 24
        }
    }
    //即时
    Rectangle{
        id: forthwithBackground
        height: parent.height
        width: (rootQueue.width-24)/3
        anchors.right: parent.right
        radius: 8
        color: "#66ffffff"
        border.color: "#ffffff"
        border.width: 1
        clip: true
        Text {
            id: forthwithLable
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 12
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: "forthwith"
            color: "#ffffff"
            font.bold: true
            font.pixelSize: 24
        }
        ComboBox{
            id:comboBox
            width: parent.width-12
            height: 40
            anchors.top: forthwithLable.bottom
            anchors.topMargin: 8
            anchors.horizontalCenter: parent.horizontalCenter
            model: ListModel{
                id: comboBoxModel
            }
            delegate: ItemDelegate { //呈现标准视图项 以在各种控件和控件中用作委托
                          width: comboBox.width
                          contentItem: Text {
                              text: modelData   //即model中的数据
                              color: "green"
                              font: comboBox.font
                              verticalAlignment: Text.AlignVCenter
                              horizontalAlignment: Text.AlignRight
                          }
            }
            contentItem: Text { //界面上显示出来的文字
                          text: comboBox.displayText //表示ComboBox上显示的文本
                          //font: comboBox.font    //文字大小
                          font.bold: true
                          color: comboBox.pressed ? "orange" : "#663399"   //文字颜色
                          verticalAlignment: Text.AlignVCenter  //文字位置
                          horizontalAlignment: Text.AlignRight
                      }
            background:Rectangle{
                color:"transparent"
                radius: 4
                border.width: 2
                border.color: "#4d663399"
            }
            popup: Popup {    //弹出项
                  y: comboBox.height
                  width: comboBox.width
                  implicitHeight: contentItem.implicitHeight
                  padding: 1
                  //istView具有一个模型和一个委托。模型model定义了要显示的数据
                  contentItem: ListView {   //显示通过ListModel创建的模型中的数据
                      clip: true
                      implicitHeight: contentHeight
                      model: comboBox.popup.visible ? comboBox.delegateModel : null
                  }
                  background: Rectangle {
                      border.color: "green"
                      color: "transparent"
                      radius: 2
                  }
                  onClosed: {
                      forthwithCurrentQueue = comboBox.currentText
                  }
            }
            Component.onCompleted: {
                for(var i=0; i<rootSche["forthwith"].length; i++){
                    var temp = {}
                    temp["queue"] = rootSche["forthwith"][i]["queue"]
                    comboBoxModel.append(temp)
                }
                currentIndex = find(forthwithCurrentQueue)
            }
        }
        Item{
            id:forthwithControl
            anchors.top: comboBox.bottom
            anchors.bottom: parent.bottom
            width: parent.width
            RowLayout{
                id: rowForthwithButton
                width: parent.width
                height: 30
                anchors.bottom: parent.bottom
                ComboBox{
                    id:comboBoxSeclect
                    Layout.preferredWidth: 70
                    Layout.preferredHeight: 28
                    Layout.alignment: Qt.AlignHCenter
                    model: ListModel{
                        id:seclectModel
                        ListElement{
                            seclect:"顺序循环"
                        }
                        ListElement{
                            seclect:"随机循环"
                        }
                        ListElement{
                            seclect:"单次执行"
                        }
                    }
                    delegate: ItemDelegate { //呈现标准视图项 以在各种控件和控件中用作委托
                                  width: comboBoxSeclect.width
                                  contentItem: Text {
                                      text: seclect   //即model中的数据
                                      color: "green"
                                      font: comboBoxSeclect.font
                                      verticalAlignment: Text.AlignVCenter
                                      horizontalAlignment: Text.AlignRight
                                  }
                    }
                    contentItem: Text { //界面上显示出来的文字
                                  text: comboBoxSeclect.displayText //表示ComboBox上显示的文本
                                  //font: comboBox.font    //文字大小
                                  font.bold: true
                                  color: comboBoxSeclect.pressed ? "orange" : "#ffffff"   //文字颜色
                                  verticalAlignment: Text.AlignVCenter  //文字位置
                                  horizontalAlignment: Text.AlignRight
                              }
                    background:Rectangle{
                        color:"transparent"
                        radius: 4
                    }
                    popup: Popup {    //弹出项
                          y: comboBoxSeclect.height
                          width: comboBoxSeclect.width
                          implicitHeight: contentItem.implicitHeight
                          padding: 2
                          //istView具有一个模型和一个委托。模型model定义了要显示的数据
                          contentItem: ListView {   //显示通过ListModel创建的模型中的数据
                              clip: true
                              implicitHeight: contentHeight
                              model: comboBoxSeclect.popup.visible ? comboBoxSeclect.delegateModel : null
                          }
                          background: Rectangle {
                              border.color: "green"
                              color: "transparent"
                              radius: 2
                          }
                          onClosed: {
                              for(var i=0; i<rootSche["forthwith"].length; i++){
                              if(rootSche["forthwith"][i]["queue"] === forthwithCurrentQueue){
                                  rootSche["forthwith"][i]["runModel"] = comboBoxSeclect.currentText
                              }
                              }
                          }
                    }
                    Component.onCompleted: {
                    }
                }
                Button{
                    Layout.preferredWidth: 70
                    Layout.preferredHeight: 28
                    Layout.alignment: Qt.AlignHCenter
                    background: Rectangle{
                        anchors.fill: parent
                        radius: 4
                        color: "transparent"
                    }
                    contentItem:Text {
                        text: qsTr("add")
                        color: "#ffffff"
                        font.bold: true
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                    }
                    UMenu{
                            id: forthwithAddMenu
                            Component.onCompleted: {
                                for(var i=0; i<rootSche["list"].length; i++){
                                    forthwithAddMenu.addSubMenu(rootSche["list"][i])
                                }
                                sigTriggered.connect(addTrigger)
                            }
                            function addTrigger(sub, act){//actionName, subName
                                addForthwith(sub, act)  //套了一层娃
                            }
                    }
                    MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        forthwithAddMenu.open()
                    }
                    }
                }
                Button{
                    Layout.preferredWidth: 70
                    Layout.preferredHeight: 28
                    Layout.alignment: Qt.AlignHCenter
                    background: Rectangle{
                        anchors.fill: parent
                        radius: 4
                        color: "transparent"
                    }
                    contentItem:Text {
                        text: qsTr("delete")
                        color: "#ffffff"
                        font.bold: true
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                    }
                    UMenu{
                            id: forthwithDeleteMenu
                            Component.onCompleted: {
                                sigTriggered.connect(delTrigger)
                            }
                            function delTrigger(sub, act){//actionName, subName
                                deleteForthwith(sub, act)  //套了一层娃
                            }
                    }
                    MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        for(var i=0; i<rootSche["forthwith"].length; i++){
                        if(rootSche["forthwith"][i]["queue"] === forthwithCurrentQueue){

                            forthwithDeleteMenu.deleteAll()
                            for(var j=0; j<rootSche["forthwith"][i]["list"].length; j++){
                                forthwithDeleteMenu.addOne(rootSche["forthwith"][i]["list"][j]["group"],
                                                           rootSche["forthwith"][i]["list"][j]["task"])
                            }
                        }
                        }
                        forthwithDeleteMenu.open()
                    }
                    }
                }
            }

            //滑动条
            USlider{
                id: uSlider
                width: parent.width-8
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: rowForthwithButton.top
                anchors.bottomMargin: 8
                from: 0
                to: 240
                stepSize: 1
                value: 55
                onMoved: {
                    for(var i=0; i<rootSche["forthwith"].length; i++){
                    if(rootSche["forthwith"][i]["queue"] === forthwithCurrentQueue){
                        rootSche["forthwith"][i]["runTime"] = value.toString()
                    }
                    }
                }
                Label{
                    id: valText
                    anchors.bottom: parent.top
                    anchors.bottomMargin: 4
                    anchors.right: parent.right
                    color: "#ffffff"
                    font.bold: true
                    text: "执行时间(分钟)"
                    horizontalAlignment: TextInput.AlignRight
                    verticalAlignment: TextInput.AlignVCenter
                }
                Label{
                    anchors.bottom: parent.top
                    anchors.bottomMargin: 4
                    anchors.right: valText.left
                    anchors.rightMargin: 8
                    color: "#663399"
                    font.bold: true
                    horizontalAlignment: TextInput.AlignRight
                    verticalAlignment: TextInput.AlignVCenter
                    text: uSlider.value.toFixed(2)
                }

                Component.onCompleted: {
                }
            }
            // queue list
            ListView{
                id:forthwithListView
                anchors.top: parent.top
                anchors.topMargin: 12
                anchors.bottom: uSlider.top
                anchors.bottomMargin: 8
                spacing: 4
                model: forthwithListModel
                delegate: Component{
                    Text {
                        id: name
                        text: model.task
                        color: "#ffffff"
                        leftPadding: 8
                        font.pixelSize: 14
                        clip: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        MouseArea{
                            anchors.fill: parent
                        }
                    }
                }
                Component.onCompleted: {
                }
            }
        }
    }
    Component.onCompleted: {
        rootSche = JSON.parse( configFile.readTaskScheduler())
        forthwithCurrentQueue = rootSche["forthwithCurrentQueue"]



    }
    onForthwithCurrentQueueChanged: {
        for(var i=0; i<rootSche["forthwith"].length; i++){
        if(rootSche["forthwith"][i]["queue"] === forthwithCurrentQueue){
            forthwithListModel.clear()
            for(var j=0; j<rootSche["forthwith"][i]["list"].length; j++){
                var temp ={}
                temp["group"] = rootSche["forthwith"][i]["list"][j]["group"]
                temp["task"] = rootSche["forthwith"][i]["list"][j]["task"]
                forthwithListModel.append(temp)
                uSlider.value = rootSche["forthwith"][i]["runTime"]
                comboBoxSeclect.currentIndex = comboBoxSeclect.find(rootSche["forthwith"][i]["runModel"])
            }

            forthwithDeleteMenu.deleteAll()
            for(var j=0; j<rootSche["forthwith"][i]["list"].length; j++){
                forthwithDeleteMenu.addOne(rootSche["forthwith"][i]["list"][j]["group"],
                                           rootSche["forthwith"][i]["list"][j]["task"])
            }
        }
        }

    }
    function addForthwith(group, task){
        var temp ={}
        temp["group"] = group
        temp["task"] = task
        forthwithListModel.append(temp)
        for(var i=0; i<rootSche["forthwith"].length; i++){
        if(rootSche["forthwith"][i]["queue"] === forthwithCurrentQueue){
            rootSche["forthwith"][i]["list"].push(temp)
        }
        }
    }
    function deleteForthwith(group, task){
        for(var i=0; i<rootSche["forthwith"].length; i++){
        if(rootSche["forthwith"][i]["queue"] === forthwithCurrentQueue){
            for(var j=0; j<rootSche["forthwith"][i]["list"].length; j++){
            if(rootSche["forthwith"][i]["list"][j]["group"] === group &&
               rootSche["forthwith"][i]["list"][j]["task"] === task){
                rootSche["forthwith"][i]["list"].splice(j, 1)
                forthwithListModel.remove(j)
            }
            }
        }
        }
    }
    function addWeekly(group, task){
        var temp ={}
        temp["groupName"] = group
        temp["taskName"] = task
        temp["week"] = "周日"
        temp["hour"] = "20"
        temp["minute"] = "10"
        temp["random"] = "true"
        weeklyListModel.append(temp)
        rootSche["weekly"].push(temp)
    }
    function deleteWeekly(group, task){
        for(var i=0; i<rootSche["weekly"].length; i++){
        if(rootSche["weekly"][i]["groupName"] === group &&
           rootSche["weekly"][i]["taskName"] === task ){
            rootSche["weekly"].splice(i, 1)
            weeklyListModel.remove(i)
            break
        }
        }
    }
}
