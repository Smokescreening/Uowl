import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item{
    property string stateName: "goto"
    Label{
        id: stName
        anchors.top: parent.top
        width:parent.width
        text: stateName
        color: "#ffffff"
        font.bold: true
        font.pixelSize: 24
    }
    RowLayout{
        id: rowLayout
        width: parent.width
        anchors.top: stName.bottom
        anchors.topMargin: 8
        implicitHeight: 30
        spacing: 0
        Image{
            Layout.preferredHeight: 22
            Layout.preferredWidth: 22
            Layout.alignment: Qt.AlignVCenter//|Qt.AlignLeft
            source: "../../GuiImage/pullmenu/gear.png"
        }
        Label{
            Layout.alignment: Qt.AlignVCenter|Qt.AlignLeft
            text: "BaseConfig"
            color: "#ffffff"
            font.bold: true
            font.pixelSize: 18
        }
        Image{
            Layout.preferredHeight: 20
            Layout.preferredWidth: 20
            Layout.alignment: Qt.AlignVCenter|Qt.AlignRight
            source: "../../GuiImage/pullmenu/chevron_down.png"

        }
    }
    PullMenu{
        id:pullMenu
        width: parent.width
        anchors.top: rowLayout.bottom
        anchors.topMargin: 8
        anchors.bottom: parent.bottom

    }
    Component.onCompleted: {
        showMenu(stateName)
    }
    onStateNameChanged: {
        showMenu(stateName)
    }
    //显示右边的菜单
    function showMenu(stateName){
        for(let state of parent.root["stateList"]){
            if(state["name"] === stateName){
            pullMenu.clearModel()
            for(let main of state["mainList"]){
                var mainModel = {}
                mainModel["name"] = main["name"]
                mainModel["icon"] = main["icon"]
                mainModel["desc"] = main["desc"]
                mainModel["subList"] = []
                for(let sub of main["subList"]){
                    var temp = {"name":sub["name"]}
                    mainModel["subList"].push(temp)
                }

                //扔进去显示
                pullMenu.addModel(mainModel)
            }
            }
        }
    }
}
