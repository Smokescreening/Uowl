import QtQuick 2.0
import "../Body/TaskBuild.js" as TB

Grid{
    id: tContexts
    Repeater{
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
        girdModel.clear()
        var DetailList = TB.getDetail(tContexts.parent.parent.root, stateName, mainName, subName)
        for(let detail of DetailList){
            girdModel.append(detail)
        }
    }
    Component.onCompleted: {
        showContents("0","0","baseConfig")
    }

}
