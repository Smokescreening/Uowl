import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQml.Models 2.15

import "../Component"
import "./SettingBoby.js" as SB


Item {
    id:settingBoby
    anchors.fill: parent
    property int sMenuFlag: 0   //0表示基本设置 1表示安卓设备设置 2表示mumu模拟器设置 3表示雷电模拟器设置
    property var settingListModel: ListModel{}

    //框框
    Rectangle{
        id:settingRectangle
        width: parent.width
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        radius: 8
        color: "#4dffffff"
        border.color: "#ffffff"
        border.width: 1
        clip: true
        //设置菜单
        Rectangle{
            id:sMenu
            width: 120
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            radius: 8
            color: "#4dffffff"
            border.color: "#ffffff"
            border.width: 1
            clip: true
            Column{
                id:sMenuColumn
                width: parent.width-2
                anchors{
                    top: parent.top
                    topMargin: 1
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                }
                spacing: 4
                Button{
                    width: sMenuColumn.width
                    height: 36
                    //Layout.preferredWidth: sMenu.width
                    //Layout.preferredHeight: 36
                    //Layout.alignment: Qt.AlignHCenter
                    background: Rectangle{
                        anchors.fill: parent
                        radius: 8
                        color: (settingBoby.sMenuFlag == 0) ? "#99663399":"transparent"
                    }
                    contentItem:Text {
                        text: "基础设置"
                        color: "#ffffff"
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                    }
                    MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: { setSettingMenuFlag(0)
                    }
                    }
                }
                Button{
                    width: sMenuColumn.width
                    height: 36
                    background: Rectangle{
                        anchors.fill: parent
                        radius: 8
                        color: (settingBoby.sMenuFlag == 1) ? "#99663399":"transparent"
                    }
                    contentItem:Text {
                        text: "安卓设备"
                        color: "#ffffff"
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                    }
                    MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {  setSettingMenuFlag(1) }
                    }
                }
                Button{
                    width: sMenuColumn.width
                    height: 36
                    background: Rectangle{
                        anchors.fill: parent
                        radius: 8
                        color: (settingBoby.sMenuFlag == 2) ? "#99663399":"transparent"
                    }
                    contentItem:Text {
                        text: "mumu模拟器"
                        color: "#ffffff"
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                    }
                    MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {  setSettingMenuFlag(2) }
                    }
                }
                Button{
                    width: sMenuColumn.width
                    height: 36
                    background: Rectangle{
                        anchors.fill: parent
                        radius: 8
                        color: (settingBoby.sMenuFlag == 3) ? "#99663399":"transparent"
                    }
                    contentItem:Text {
                        text: "雷电模拟器"
                        color: "#ffffff"
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                    }
                    MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {  setSettingMenuFlag(3)  }
                    }
                }
            }
        }
        //设置内容 委托
        Component{
            id:settingListDelegate
            SettingElement{
                id:settingElementDelegate
                width: settingListView.width
                category: model.category
                name: model.name
                description: model.description
                controlClass: model.controlClass
                controlParamete: model.controlParamete
                controlValue: model.controlValue
                //我算是明白了 这个就是个版本bug 浪费半天时间
//                Rectangle{
//                    anchors.fill: parent
//                    color: (settingElementDelegate.currentIIndex === settingElementDelegate.List.currentIndex ) ? "#33ffffff" : "transparent"
//                    MouseArea{
//                        anchors.fill: parent
//                        hoverEnabled:true
//                        onClicked: {
//                            console.debug("赋值前的"+index, settingElementDelegate.currentIIndex)
//                            settingElementDelegate.currentIIndex = currentIndex
//                            console.debug("赋值后的"+index, settingElementDelegate.currentIIndex)
//                        }
//                    }
//                }
            }
        }
        //设置内容-视图
        Item{
            id:settingListView
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.left: sMenu.right
            anchors.leftMargin: 24
            anchors.right: parent.right
            anchors.rightMargin: 24
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            ListView{
                id:sListView
                anchors.fill: parent
                model:settingListModel
                delegate:settingListDelegate
            }
        }

    }
    Component.onCompleted: {
        //SB.readSettingJson("baseSetting")
        settingListModel.append(SB.readSettingJson("baseSetting"))
    }
    Component.onDestruction: {
        //组件关闭是时候把 四个配置项保存
        if(settingBoby.sMenuFlag === 0){ //保存
            SB.writeSettingJson("baseSetting", SB.getListViewJson())
        }else if(settingBoby.sMenuFlag === 1){
            SB.writeSettingJson("android", SB.getListViewJson())
        }else if(settingBoby.sMenuFlag === 2){
            SB.writeSettingJson("mumu", SB.getListViewJson())
        }else if(settingBoby.sMenuFlag === 3){
            SB.writeSettingJson("leidian", SB.getListViewJson())
        }

    }
    //改变状态 保存 载入 json
    function setSettingMenuFlag(num){
        if(settingBoby.sMenuFlag === 0){ //先保存 基础设置
            SB.writeSettingJson("baseSetting", SB.getListViewJson())
        }else if(settingBoby.sMenuFlag === 1){
            SB.writeSettingJson("android", SB.getListViewJson())
        }else if(settingBoby.sMenuFlag === 2){
            SB.writeSettingJson("mumu", SB.getListViewJson())
        }else if(settingBoby.sMenuFlag === 3){
            SB.writeSettingJson("leidian", SB.getListViewJson())
        }
        settingBoby.sMenuFlag =num //切换设置菜单
        settingListModel.clear()   //清空数据
        if(settingBoby.sMenuFlag === 0){       //重新读取添加到模型
            settingListModel.append(SB.readSettingJson("baseSetting"))
        }else if(settingBoby.sMenuFlag === 1){
            settingListModel.append(SB.readSettingJson("android"))
        }else if(settingBoby.sMenuFlag === 2){
            settingListModel.append(SB.readSettingJson("mumu"))
        }else if(settingBoby.sMenuFlag === 3){
            settingListModel.append(SB.readSettingJson("leidian"))
        }


    }

    //目前没啥用
    function jsonToListModel(json){
        for(var i=0 ; i<json.length; i++){
            //console.debug(json[i].name)
        }
    }
}
