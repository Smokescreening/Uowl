import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.11

import "../Body/TaskBuild.js" as TB

/*

关于使用该组件：

 需要在外界指定长宽
 外界对内通信：使用内部方法
 内部向外通信：定义好信号，创建的时候连接好或者在外部onSigal()形式
 具体使用的时候记得把一些mourse删掉



*/

Item {
    id:root
    implicitWidth: 300
    implicitHeight: 800

    property int menuIndex: 0
    property int subIndex: 0
    signal sigChangeMenuEdit(string mainName, string subName) //用下面的接口
    signal sigSelectSub(string mainName, string subName)


    Component.onCompleted: {
//        addMainModelDate("imgEvent", "../../GuiImage/pullmenu/photo.png",
//                         "test", [{"name":"img1"},{"name":"img2"}], mainModel)
//        addMainModelDate("clickAction", "../../GuiImage/pullmenu/photo.png",
//                         "test", [{"name":"click1"},{"name":"click2"}], mainModel)
    }

    ListView{
        id:mainView
        anchors.fill: parent
        spacing: 20
        model: ListModel{
            id: mainModel
        }
        delegate: mainDelegate
    }
    Component{
        id:mainDelegate
        Item{ //Component必须里面是只有一个组件的
        implicitHeight: rowLayout.height + subView.height
        MouseArea{
            id:mdMouse
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            anchors.fill: rowLayout
            onClicked: function(mouse){
                if (mouse.button === Qt.RightButton){
                     ctMenu.popup()
                }else{
                     menuIndex = index
                }
            }
        }
        Menu{
            id: ctMenu
            background: Rectangle{
                implicitWidth: 140
                radius: 8
                border.color: "green"
                color: "transparent"
            }
            Action {
                text: "new"
                onTriggered:{
                    newNaemDialog.open()
            }}
        }
        UDialog{
            id:newNaemDialog
            title: "Name"
            TextInput{
                id:dialogText
                color: "#663399"
                font.bold: true
                text: "newname"
                selectByMouse: true //默认鼠标选取文本设置为false
                selectedTextColor: "yellow" //选中文本的颜色
                selectionColor: "white"
            }
            function buttonClicked(label){
                if(label==="确定"){
                    TB.addSub(root.parent.parent.root, root.parent.stateName, name, dialogText.text)
                    addSubModelDate(name, dialogText.text, mainModel)
                    newNaemDialog.close()
                }else if(label === "取消")
                {newNaemDialog.close()}
            }
            Component.onCompleted: {
               newNaemDialog.footerButtonClicked.connect(buttonClicked)
            }
        }
        RowLayout{
            id: rowLayout
            width: root.width
            anchors.top: parent.top
            implicitHeight: 30
            spacing: 0
            Image{
                Layout.preferredHeight: 22
                Layout.preferredWidth: 22
                Layout.alignment: Qt.AlignVCenter//|Qt.AlignLeft
                source: icon
            }
            Label{
                Layout.alignment: Qt.AlignVCenter|Qt.AlignLeft
                text: name
                color: "#ffffff"
                font.bold: true
                font.pixelSize: 18
            }
            Image{
                Layout.preferredHeight: 20
                Layout.preferredWidth: 20
                Layout.alignment: Qt.AlignVCenter|Qt.AlignRight
                source: (index === menuIndex)
                        ?"../../GuiImage/pullmenu/chevron_down.png"
                        :"../../GuiImage/pullmenu/chevron_left.png"
            }
        }
        //第二级视图
        ListView{
            id:subView
            visible: (index === menuIndex)? true:false
            anchors.top: rowLayout.bottom
            anchors.topMargin: 8
            width: root.width
            implicitHeight: (index === menuIndex)?subList.count*20:0
            spacing: 4
            Component.onCompleted: {

            }

            model: subList
            delegate: Component{
                id: highlig
                Item{
                    width: root.width
                    implicitHeight: 20
                    Label{
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 34
                        text: name
                        color: (subIndex === index)?"#663399":"#ffffff"
                        font.bold: true
                        font.pixelSize: 16
                    }
                    MouseArea{
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: function(mouse){
                            if (mouse.button === Qt.RightButton){
                                 ctMenu.popup()
                            }else{
                                subIndex = index
                                var mainN = mainModel.get(menuIndex).name
                                var subN = name
                                sigChangeMenuEdit(mainN, subN)
                                sigSelectSub(mainN, subN)
                                root.parent.parent.changeContents(mainN, subN)
                                console.debug(mainN, subN)
                            }
                        }
                        Menu{
                            id: ctMenu
                            background: Rectangle{
                                implicitWidth: 140
                                radius: 8
                                border.color: "green"
                                color: "transparent"
                            }
                            Action {
                                text: "删除该项"
                                onTriggered:{
                                    TB.delSub(root.parent.parent.root, root.parent.stateName, mainModel.get(menuIndex).name ,name)
                                    mainModel.get(menuIndex).subList.remove(index)
                            }}
                        }
                    }
                }
            }
        }
        }
    }
    //第一项是模型引用
    function __findIndex(model, name){
        for(var i=0; i<model.count; i++){
            if(model.get(i).name === name){
                return i
            }
        }
        return -1
    }

    //添加一项模型数据 包含subModel 最后一个输入是要操作的模型数据最后一个输入是要操作的模型数据
    function addMainModelDate(name, icon, description, submodel, mainModel){
        var index = __findIndex(mainModel, name)
        if(index === -1){ //如果没有这大项数据就添加
            mainModel.append({"name": name,
                              "icon": icon,
                              "desc": description,
                              "subList": submodel })
        }else{  //之前有这一大项模型，更改子项模型
            mainModel.get(index).subList =subList
        }
    }
    //添加以小项模型数据 最后一个输入是要操作的模型数据
    function addSubModelDate(mainName, subName, mainModel){
        var index = __findIndex(mainModel, mainName)
        if(index === -1){
            addMainModelDate(mainName, "", "no find description",
                             [{"name":subName}], mainModel)
        }else{
            mainModel.get(index).subList.append({"name":subName})
        }
    }
    //删除一小项数据  最后一项是模型数据
    function __delSubModelDate(mainName, subName, subIndex, mainModel){
        var index = __findIndex(mainModel, mainName)
        if(index === -1){
        }else{
            mainModel.get(index).subModel.remove(subIndex)
        }
    }
    //添加数据模型 对外接口
    function addModel(model){
        mainModel.append(model)
    }
    //删除 全部 对外接口
    function clearModel(){
        mainModel.clear()
    }

}
