import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQml.Models 2.15
import QtQuick.Layouts 1.12

import "../Component"

Item {
    id:rootQueue
    anchors.fill: parent
    property var rootSche: {""}
    property string forthwithCurrentQueue: ""
    property var forthwithListModel: ListModel{}

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
    }
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
                    MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
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
                    MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
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
                value: 55
                onMoved: {

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
                        text: task
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
                    forthwithListModel.append({"task":"dffe", "group":"eeeee"})
                    forthwithListModel.append({"task":"dffe", "group":"eeeee"})
                }
            }
        }
    }
    Component.onCompleted: {
        rootSche = JSON.parse( configFile.readTaskScheduler())
        forthwithCurrentQueue = rootSche["forthwithCurrentQueue"]



    }
    onForthwithCurrentQueueChanged: {
        console.debug("i know change")
    }
}
