import QtQuick 2.11
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.4
import QtQuick.Layouts 1.11

Page {
    id:root
    width: 500
    height: 800


    ListView{
        id:listView
        anchors.fill: parent
        spacing: 20
        model: ListModel{
            id:listModel
        }
        delegate: list_delegate
    }

    Component.onCompleted: {
        addModelData("class A","2018.2.1","aaa","13kb")
        addModelData("class B","2018.2.4","ddd","43kb")
        addModelData("class A","2018.2.2","bbb","23kb")
        addModelData("class A","2018.2.3","ccc","33kb")
        addModelData("class B","2018.2.5","eee","53kb")
        addModelData("class C","2018.2.6","fff","675kb")
        addModelData("class C","2018.2.7","ggg","45kb")
    }

    //大菜单的委托
    Component{
        id:list_delegate

        Column{
            id:objColumn

            Component.onCompleted: {
                for(var i = 1; i < objColumn.children.length - 1; ++i) {
                    objColumn.children[i].visible = false
                }
            }

            MouseArea{
                width:listView.width
                height: objItem.implicitHeight
                enabled: objColumn.children.length > 2
                onClicked: {
                    console.log("onClicked..")
                    var flag = false;
                    for(var i = 1; i < parent.children.length - 1; ++i) {
                        flag = parent.children[i].visible;
                        parent.children[i].visible = !parent.children[i].visible
                    }
                    console.log("onClicked..flag = ",flag)
                    if(!flag){
                        iconAin.from = 0
                        iconAin.to = 90
                        iconAin.start()
                    }
                    else{
                        iconAin.from = 90
                        iconAin.to = 0
                        iconAin.start()
                    }
                }
                Row{
                    id:objItem
                    spacing: 10
                    leftPadding: 20

                    Image {
                        id: icon
                        width: 10
                        height: 20
                        source: "icon_retract.png"
                        anchors.verticalCenter: parent.verticalCenter
                        RotationAnimation{
                            id:iconAin
                            target: icon
                            duration: 100
                        }
                    }
                    Label{
                        id:meeting_name
                        text: meetingName
                        font.pixelSize: fontSizeMedium
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Label{
                        text: date
                        font.pixelSize: fontSizeMedium
                        color:"grey"
                        anchors.verticalCenter: parent.verticalCenter

                    }
                }
            }
            Repeater {
               model: subNode
               //子菜单的委托
               delegate: Rectangle{
                   width: listView.width
                   height: 50
                   Rectangle {
                       id: fileicon
                       color:index%2?"red":"yellow"
                        anchors.fill: parent
                   }


               }
            }
        }
    }


    function addModelData(meetingName,date,fileName,size){
        var index = findIndex(meetingName)
        //如果没有这个大菜单
        if(index === -1){
            listModel.append({"meetingName":meetingName,"date":date,"level":0,
                                 "subNode":[{"fileName":fileName,"size":size,"level":1,"subNode":[]}]})
        }
        //如果原先有这个
        else{
            listModel.get(index).subNode.append({"fileName":fileName,"size":size,"level":1,"subNode":[]})
        }

    }

    function findIndex(name){
        for(var i = 0 ; i < listModel.count ; ++i){
            if(listModel.get(i).meetingName === name){
                return i
            }
        }
        return -1
    }
}






