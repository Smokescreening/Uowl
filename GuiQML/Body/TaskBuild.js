.pragma library

//
function newEleDetail(eleName, eleType, eleParamete) {
    const icnList = ["bag.png", "bar-graph.png", "calendar.png", "cancel.png", "folder.png", "options.png",
                     "pie-chart.png", "rocket.png", "secured.png", "settings.png", "wallet.png", "warning.png",
                     "weather.png"]
    var reu = {}
    reu["eleName"] = eleName
    reu["eleDescription"] = "0"
    reu["eleIcn"] = icnList[Math.round(Math.random() * 12)]
    reu["eleType"] = eleType
    reu["eleVal"] = "0"
    reu["eleParamete"] = eleParamete
    return reu
}

//  生成一个新的imgEvent
function newImgEvent(name){
    var reu = {}
    reu["name"] = name
    reu["detail"] = []
    reu["detail"].push( newEleDetail("imgName", "fileDialog",["0","0"]))
    reu["detail"].push( newEleDetail("x0", "slider",["0","1"]))
    reu["detail"].push( newEleDetail("y0", "slider",["0","1"]))
    reu["detail"].push( newEleDetail("width", "slider",["0","1"]))
    reu["detail"].push( newEleDetail("height", "slider",["0","1"]))
    return reu
}
//
function newIntVarEvent(name){
    var reu = {}
    reu["name"] = name
    reu["detail"] = []
    reu["detail"].push( newEleDetail("imgName", "fileDialog",["0","0"]))
    return reu
}
//
function newClickAtion(name){
    var reu = {}
    reu["name"] = name
    reu["detail"] = []
    reu["detail"].push( newEleDetail("limits", "slider", ["20","80"]))
    reu["detail"].push( newEleDetail("moveX", "slider", ["0","1"]))
    reu["detail"].push( newEleDetail("moveY", "slider", ["0","1"]))
    return reu
}
// new transitions:
function newTransitionsAction(name){
    var reu = {}
    reu["name"] = name
    reu["detail"] = []
    reu["detail"].push( newEleDetail("trigger", "textInput", ["20","80"]))
    reu["detail"].push( newEleDetail("source", "comboBox", ["0","1"]))
    reu["detail"].push( newEleDetail("dest", "comboBox", ["0","1"]))
    return reu
}
// new
function newEnvent2Action(name){
    var reu = {}
    reu["name"] = name
    reu["detail"] = []
    reu["detail"].push( newEleDetail("eventType", "comboBox", ["20","80"]))
    reu["detail"].push( newEleDetail("eventName", "comboBox", ["0","1"]))
    reu["detail"].push( newEleDetail("actionType", "comboBox", ["0","1"]))
    reu["detail"].push( newEleDetail("actionName", "comboBox", ["0","1"]))
    return reu
}
//  创建一个新的 sub
function newSub(mainName, subName){
    switch(mainName){
    case "imgEvent":
        return newImgEvent(subName);
        break;
    case "intVarEvent":{
        return newIntVarEvent(subName);
    }break;
    case "clickAction":{
        return newClickAtion(subName);
    }break;
    case "transitionsAction":{
        return newTransitionsAction(subName);
    }break;
    case "envent2Action":{
        return newEnvent2Action(subName);
    }break;
    default:return null
    }
}


//new main
function newMain(name, icon){
    var reu = {}
    reu["name"] = name
    reu["icon"] = "../../GuiImage/pullmenu/"+icon
    reu["desc"] = "0"
    reu["subList"] = []
    return reu
}

//生成一个个新的state
function newState(name, x, y){
    var reu={}
    reu["name"] = name
    reu["x"] = x
    reu["y"] = y
    reu["mainList"] = []
    reu["mainList"].push( newMain("imgEvent", "photo.png") )
    reu["mainList"].push( newMain("intVarEvent", "textformat_123.png") )
    reu["mainList"].push( newMain("clickAction", "location_fill_rotated.png") )
    reu["mainList"].push( newMain("intChangeAction", "minus_slash_plus.png") )
    reu["mainList"].push( newMain("transitionsAction", "repeat.png") )
    reu["mainList"].push( newMain("envent2Action", "arrow-left-right-fill.png") )
    return reu
}
//这个要和上面函数一起用的
function addState(root, newState){
    root["stateList"].push(newState)
}
function delState(root, stateName){
    for(var i=0; i<root["stateList"].length; i++){
        if(root["stateList"][i]["name"] === stateName){
            root["stateList"].splice(i, 1)
        }
    }
}
function addSub(root, stateName, mainName, subName){
    for(let state of root["stateList"]){
        if(state["name"] === stateName){
        for(let main of state["mainList"]){
            if(main["name"] === mainName){
                var sub = newSub(mainName, subName)
                main["subList"].push(sub)
            }
        }
        }
    }
}
function delSub(root, stateName, mainName, subName){
    for(let state of root["stateList"]){
        if(state["name"] === stateName){               //找state
        for(let main of state["mainList"]){
            if(main["name"] === mainName){             //找main
            for(var i=0; i<main["subList"].length; i++){
                if(main["subList"][i]["name"]===subName){ //找sub
                    main["subList"].splice(i, 1)
                }
            }
            }
        }
        }
    }
}

function getDetail(root, stateName, mainName, subName){
    if(stateName==="0" && mainName==="0" && subName==="baseConfig"){
        return root["baseConfig"]["detail"]
    }

    for(let state of root["stateList"]){
        if(state["name"] === stateName){               //找state
        for(let main of state["mainList"]){
            if(main["name"] === mainName){             //找main
            for(let sub of main["subList"]){
                if(sub["name"] === subName){
                    return sub["detail"]               //返回数组
                }
            }
            }
        }
        }
    }
}
