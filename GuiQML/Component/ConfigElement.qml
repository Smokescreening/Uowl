import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQml.Models 2.12
import QtQuick.Dialogs
import Qt5Compat.GraphicalEffects 1.0

Item {
    id:root
    width: 280
    height: 100

    property string eleType: "fileDialog"  //表示这个控件元素的类型
                                 // comboBox textInput slider fileDialog
    property string eleIcn: "rocket.png"
    property string eleDescription: "description!!!"
    property string eleName: "imgName"
    property string eleVal: "19"
    property var eleParamete: ListModel{}
    Component.onCompleted: {
    }
    Rectangle{
        anchors.fill: parent
        color: "#ffffff"
        opacity: 0.3
        radius: 8
        border.width: 1
        border.color: "#ffffff"
    }
    //icn
    Image {
        id: icon
        anchors.left: parent.left
        anchors.leftMargin: 4
        anchors.top: parent.top
        anchors.topMargin: 4
        width: 70
        height: width
        source: "../../GuiImage/configelement/"+eleIcn
    }
    //description
    Label {
        id: desc
        anchors.left: icon.right
        anchors.top: parent.top
        anchors.topMargin: 4
        anchors.right: parent.right
        anchors.rightMargin: 4
        font.pixelSize: 12
        clip: true
        text: eleDescription
        color: "#ffffff"
    }
    //name
    Label{
        id:name
        anchors.left: icon.right
        anchors.top: desc.bottom
        color: "#ffffff"
        font.bold: true
        font.pixelSize: 22
        clip: true
        text: eleName
    }

    Rectangle{
        id: type
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 4
        anchors.right: parent.right
        anchors.rightMargin: 4
        anchors.left: parent.left
        anchors.leftMargin: 4
        height: 40
//        color: "red"
        color: "transparent"
        radius: 8
//        opacity: 0.2
        //下拉框
        ComboBox{
            id:comboBox
            width: parent.width
            anchors.verticalCenter: parent.verticalCenter
            model:eleParamete
            visible: root.eleType === "comboBox"?true:false
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
                border.color: "#80ffffff"
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
                  onOpened: {
                      if(root.eleName === "eventName"){
                          eleParamete.clear()
                          var temp = root.parent.parent.parent.getEventOActionList("eventName")
                          for(let i of temp){
                              eleParamete.append(i)
                          }
                      }else if(root.eleName === "actionName"){
                          eleParamete.clear()
                          var temp1 = root.parent.parent.parent.getEventOActionList("actionName")
                          for(let j of temp1){
                              eleParamete.append(j)
                          }
                      }else if(root.eleName === "source" || root.eleName === "dest"){
                          eleParamete.clear()
                          var temp2 = root.parent.parent.parent.getStateList()
                          for(let k of temp2){
                              eleParamete.append(k)
                          }
                      }
                  }

                  onClosed: {
                      root.eleVal = comboBox.displayText
                  }
            }
            onAccepted: {
                eleVal = comboBox.currentText
            }

            Component.onCompleted: {
                currentIndex = find(root.eleVal)
            }
        }
        //输入文字
        TextInput{
            id:textInput
            visible: (root.eleType === "textInput")?true:false
            width: parent.width
            height: 30
            anchors.verticalCenter: parent.verticalCenter
            color: "yellow"
            font.bold: true
            text: root.eleVal
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
                border.color: "#80ffffff"
            }
            onTextEdited: {
                root.eleVal = textInput.text
            }

            onEditingFinished: {
                focus= false
               //这个没啥用
            }
        }
        //滑动条
        USlider{
            id: uSlider
            width: parent.width-2
            anchors.centerIn: parent
            enabled: (root.eleType === "slider")?true:false
            visible: (root.eleType === "slider")?true:false
            from: (eleType==="slider")?parseFloat(root.eleParamete.get(0).paramete):0
            to: (eleType==="slider")?parseFloat(root.eleParamete.get(1).paramete):1
            value: parseFloat(root.eleVal)
            onMoved: {
                root.eleVal = value.toString()
            }
            Label{
                id: valText
                anchors.bottom: parent.top
                anchors.bottomMargin: 4
                anchors.right: parent.right
                color: "#663399"
                font.bold: true
                text: uSlider.value.toFixed(2)
                horizontalAlignment: TextInput.AlignRight
                verticalAlignment: TextInput.AlignVCenter
            }
            Component.onCompleted: {
            }
        }
        //文件选择
        Text {
            id: fileDialog
            visible: (root.eleType === "fileDialog")?true:false
            width: parent.width
            height: 30
            verticalAlignment: TextInput.AlignVCenter
            horizontalAlignment: TextInput.AlignLeft
            text: root.eleVal
            color: "yellow"
            font.bold: true
            Rectangle{
                anchors.fill: parent
                color: "transparent"
                radius: 4
                border.width: 2
                border.color: "#80ffffff"
            }
            Button{
                width: 50
                height: 25
                anchors.bottom: parent.top
                anchors.bottomMargin: 4
                anchors.right: parent.right
                background: Rectangle{
                    id:background
                    anchors.fill: parent
                    radius: 4
                    color: "transparent"
                }
                contentItem:Text {
                    text: qsTr("选择图片")
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
                    imgFileDialog.open()
                }
                }
            }
            FileDialog{
                id: imgFileDialog
                title: "Please choose a image"
//                folder: shortcuts.desktop
                nameFilters: ["png文件 (*.png)", "jpg文件 (*.jpg)"]
                onAccepted: {
                    var string = imgFileDialog.selectedFile.toString()
                    var pos = string.lastIndexOf('/')
                    var fileName = string.substr(pos+1)
                    root.eleVal = fileName
//                    console.log("You chose: " + fileName)
                    imgFileDialog.close()
                }
            }
        }
    }

    //取得控件的值
    function getEleJson(){
        //返回json对象
        var json ={}
        var eleParamete = [] //把ListMode转为json对象的中间变量
        for(var i=0; i<root.eleParamete.count; i++){// 遍历所有ListElement
            var item = root.eleParamete.get(i)
            var ele ={}
            ele.paramete = item.paramete
            eleParamete.push(ele)
        }

        json.eleName = root.eleName
        json.eleDescription = root.eleDescription
        json.eleIcn = root.eleIcn
        json.eleType = root.eleType
        json.eleVal = root.eleVal
        json.eleParamete = eleParamete

        return json
    }
}
