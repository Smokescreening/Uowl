import QtQuick 2.0
import QtQml.Models 2.12
import "../Body/TaskBuild.js" as TB

Grid{
    id: tContexts
    property string showMainName: ""
    property string showSubName: ""
    anchors.topMargin: 8
    columns: 5
//    rows: 4
    flow: Grid.TopToBottom
    spacing: 12
    Repeater{
        id:repeee
        model: ListModel{
            id:girdModel
        }
        delegate: ConfigElement{
            eleName:model.eleName
            eleDescription:model.eleDescription
            eleIcn: model.eleIcn
            eleType: model.eleType
            eleVal: model.eleVal
            eleParamete: model.eleParamete
        }
    }

    function showContents(stateName, mainName, subName){
        showMainName = mainName
        showSubName = subName
        girdModel.clear()
        var DetailList = []
        if(stateName==="0" && mainName==="0" && subName==="baseConfig"){
           DetailList =   TB.getDetail(tContexts.parent.parent.root, "0", "0", "baseConfig")
        }else{
           DetailList =  TB.getDetail(tContexts.parent.parent.root, stateName, mainName, subName)
        }

        for(let detail of DetailList){
            girdModel.append(detail)

        }
    }
    Component.onCompleted: {
        showContents("0","0","baseConfig")
    }
    function saveContents(stateName, mainName, subName){
        var detail = []
        for(var i=0; i< repeee.count; i++){
            var item = repeee.itemAt(i)
            detail.push( item.getEleJson())
        }
        TB.saveDetail(tContexts.parent.parent.root, stateName, mainName, subName, detail)
    }

}
