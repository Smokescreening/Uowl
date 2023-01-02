import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQml.Models 2.15
Item {
    id:settingElement
    height: 100
    property string category: ""
    property string name: ""
    property string description: ""
    property string controlClass: ""
    property var controlParamete: ListModel{}
    property string controlValue: ""

    Rectangle{
        anchors.fill: parent
        //color: "#33ffffff"
        color: settingElement_MouseArea.containsPress  ? "#33ffffff" : "transparent"
        //color: ListView.isCurrentItem ? "#33ffffff" : "transparent"
        MouseArea{
            id:settingElement_MouseArea
            anchors.fill: parent
            hoverEnabled: true
            //onClicked: {console.debug(settingElement_MouseArea.containsMouse , settingElement_MouseArea.containsPress )}
        }
    }
    Column{
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.top: parent.top
        anchors.topMargin: 8
        spacing: 4
        Row{
            width: settingElement.width
            spacing: 8
            Text {
                text: settingElement.category+">"
                color: "#99ffffff"
            }
            Text {
                text: settingElement.name
                color: "#ffffff"
                font.bold: true
            }
        }
        Text {
            width: settingElement.width
            //height: 30
            text: settingElement.description
            color: "#ffffff"
        }
        Item{
            width: settingElement.width-12
            height: 40
            //下拉框
            ComboBox{
                id:comboBox
                width: 400
                anchors.verticalCenter: parent.verticalCenter
                model:settingElement.controlParamete
                visible: (settingElement.controlClass == "comboBox")?true:false
                delegate: ItemDelegate { //呈现标准视图项 以在各种控件和控件中用作委托
                              width: comboBox.width
                              contentItem: Text {
                                  text: modelData   //即model中的数据
                                  color: "green"
                                  font: comboBox.font
                                  verticalAlignment: Text.AlignVCenter
                              }
                }
                contentItem: Text { //界面上显示出来的文字
                              text: comboBox.displayText //表示ComboBox上显示的文本
                              //font: comboBox.font    //文字大小
                              font.bold: true
                              color: comboBox.pressed ? "orange" : "#663399"   //文字颜色
                              verticalAlignment: Text.AlignVCenter  //文字位置
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
                }
                Component.onCompleted: {
                    currentIndex = find(settingElement.controlValue)
                }
            }
            //输入框
            TextInput{
                id:textInput
                visible: (settingElement.controlClass.indexOf("textInput") != -1)?true:false
                width: 400
                height: 30
                anchors.verticalCenter: parent.verticalCenter
                color: "#663399"
                font.bold: true
                text: settingElement.controlValue
                horizontalAlignment: TextInput.AlignLeft
                verticalAlignment: TextInput.AlignVCenter
                selectByMouse: true //默认鼠标选取文本设置为false
                selectedTextColor: "#663399" //选中文本的颜色
                selectionColor: "white"
                Rectangle{
                    anchors.fill: parent
                    color: "transparent"
                    radius: 4
                    border.width: 2
                    border.color: "#4d663399"
                }
            }
        }
    }
    function getSettingJson(){
        //返回json对象
        var json ={}
        var controlParameteJson = [] //把ListMode转为json对象的中间变量
        for(var i=0; i<settingElement.controlParamete.count; i++){// 遍历所有ListElement
            var item = settingElement.controlParamete.get(i)
            var ele ={}
            ele.paramete = item.paramete
            controlParameteJson.push(ele)
            //console.debug(JSON.stringify(controlParameteJson))
        }

        json.category = settingElement.category
        json.name = settingElement.name
        json.description = settingElement.description
        json.controlClass = settingElement.controlClass
        json.controlParamete = controlParameteJson
        json.controlValue = (settingElement.controlClass==="comboBox") ? comboBox.currentText:textInput.text
        return json
    }
}
