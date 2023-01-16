import QtQuick 2.12
import QtQuick.Controls 2.12

Menu{
    id: root
    signal sigTriggered(string sub, string act)
    background: Rectangle{
        implicitWidth: 160
        radius: 8
        border.color: "green"
        color: "#475164"
    }
    title: "3456"

    // 添加一个新的子菜单 info 可以是这样的: {"name":"sub1", "list":["name": "action1", "name": "action2"]}
    function addSubMenu(info){
        var obj = Qt.createQmlObject('import QtQuick 2.12; import QtQuick.Controls 2.12;
                                      Menu{
                                            background: Rectangle{
                                                implicitWidth: 100
                                                radius: 8
                                                border.color: "green"
                                                color: "#475164"
                                            }
                                            function slotTriggered(actionName){
                                                root.sigTriggered(title, actionName)
                                            }
                                           }', root)
        obj.title = info["name"]
        obj.currentIndex = 0
        for(var i=0; i<info["list"].length; i++){
            var act = Qt.createQmlObject('import QtQuick 2.12; import QtQuick.Controls 2.12;
                                          Action{
                                               signal sigTriggered(string actionName)
                                               onTriggered: sigTriggered(text)
                                          }', obj)
            act.text = info["list"][i]["name"]
            act.sigTriggered.connect(obj.slotTriggered)
            obj.addAction(act)
        }
        root.addMenu(obj)
    }

    function addOne(sub, act){
        if(root.count>0){
        var findFlag = false
        for(var i=0;  i<root.count; i++){
            var subMenu = root.menuAt(i)
            if(subMenu.title === sub){  //如果原来有sub 就添加就好了
                findFlag =true
                var action = Qt.createQmlObject('import QtQuick 2.12; import QtQuick.Controls 2.12;
                                              Action{
                                                   signal sigTriggered(string actionName)
                                                   onTriggered: sigTriggered(text)
                                              }', subMenu)
                action.text = act
                action.sigTriggered.connect(subMenu.slotTriggered)
                subMenu.addAction(action)
                break
            }
        }
        if(findFlag === false){  //如果找遍了没有找到这个sub 那就创建
            var temp ={}
            temp["name"] = sub
            temp["list"] = [{"name" : act}]
            root.addSubMenu(temp)
        }
        }
        else{  //如果什么也没有
            var temp ={}
            temp["name"] = sub
            temp["list"] = [{"name" : act}]
            root.addSubMenu(temp)
        }
    }

    //清空所有
    function deleteAll(){
        if(root.count>0){
        for(var i=0;  i<root.count; i++){
            root.takeMenu(i)
        }
        root.takeMenu(0)   //哇塞 这个坑 每次运行后这个root,count都会变换所以要删掉最后一个才可以的
    }
    }
}
