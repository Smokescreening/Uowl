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
    reu["detail"].push( newEleDetail("imgName", "fileDialog",[{"paramete":"0"},{"paramete":"0"}]))
    reu["detail"].push( newEleDetail("x0", "slider",[{"paramete":"0"},{"paramete":"1"}]))
    reu["detail"].push( newEleDetail("y0", "slider",[{"paramete":"0"},{"paramete":"1"}]))
    reu["detail"].push( newEleDetail("width", "slider",[{"paramete":"0"},{"paramete":"1"}]))
    reu["detail"].push( newEleDetail("height", "slider",[{"paramete":"0"},{"paramete":"1"}]))
    return reu
}
//
function newIntVarEvent(name){
    var reu = {}
    reu["name"] = name
    reu["detail"] = []
    reu["detail"].push( newEleDetail("imgName", "fileDialog",[{"paramete":"0"},{"paramete":"0"}]))
    return reu
}
//
function newClickAtion(name){
    var reu = {}
    reu["name"] = name
    reu["detail"] = []
    reu["detail"].push( newEleDetail("limits", "slider", [{"paramete":"20"},{"paramete":"80"}]))
    reu["detail"].push( newEleDetail("moveX", "slider", [{"paramete":"0"},{"paramete":"1"}]))
    reu["detail"].push( newEleDetail("moveY", "slider", [{"paramete":"0"},{"paramete":"1"}]))
    return reu
}
// new transitions:
function newTransitionsAction(name){
    var reu = {}
    reu["name"] = name
    reu["detail"] = []
    reu["detail"].push( newEleDetail("trigger", "textInput", [{"paramete":"20"},{"paramete":"80"}]))
    reu["detail"].push( newEleDetail("source", "comboBox", [{"paramete":"0"},{"paramete":"1"}]))
    reu["detail"].push( newEleDetail("dest", "comboBox", [{"paramete":"0"},{"paramete":"1"}]))
    return reu
}
// new
function newEnvent2Action(name){
    var reu = {}
    reu["name"] = name
    reu["detail"] = []
    reu["detail"].push( newEleDetail("eventType", "comboBox", [{"paramete":"imgEvent"},{"paramete":"intVarEvent"}]))
    reu["detail"].push( newEleDetail("eventName", "comboBox", [{"paramete":"0"},{"paramete":"1"}]))
    reu["detail"].push( newEleDetail("actionType", "comboBox", [{"paramete":"clickAction"},{"paramete":"intChangeAction"}]))
    reu["detail"].push( newEleDetail("actionName", "comboBox", [{"paramete":"0"},{"paramete":"1"}]))
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

function saveDetail(root, stateName, mainName, subName, detail){
    if(mainName==="0" && subName==="baseConfig"){
        root["baseConfig"].detail = detail
    }
    for(let state of root["stateList"]){
        if(state["name"] === stateName){               //找state
        for(let main of state["mainList"]){
            if(main["name"] === mainName){             //找main
            for(let sub of main["subList"]){
                if(sub["name"] === subName){
                    sub["detail"] = detail              //返回数组
                }
            }
            }
        }
        }
    }
}

//获取所有的状态列表 带参数paramete
function getStateList(root){
    var reu = []
    for(let state of root["stateList"]){
        var eleParamete ={}
        eleParamete["paramete"] = state["name"]
        reu.push( eleParamete )
    }
    return reu
}
//获取所有的event 带参数paramete
function getEventNameList(root, stateName){
    var reu = []
    for(let state of root["stateList"]){ //找到statename
        if(state["name"] === stateName){
        for(let main of state["mainList"]){
            if(main["name"] === "imgEvent" || main["name"] === "和intVarEvent"){//找到imgEvent 和intVarEvent
            for(let sub of main["subList"]){
                var paramete = {}
                paramete["paramete"] = sub["name"]
                reu.push(paramete)
            }
            }
        }
        }
    }
    return reu
}
//获取所有的action 带参数paramete
function getActionNameList(root, stateName){
    var reu = []
    for(let state of root["stateList"]){ //找到statename
        if(state["name"] === stateName){
        for(let main of state["mainList"]){
            if(main["name"] === "clickAction" || main["name"] === "intChangeAction"){//clickAction intChangeAction
            for(let sub of main["subList"]){
                var paramete = {}
                paramete["paramete"] = sub["name"]
                reu.push(paramete)
            }
            }
        }
        }
    }
    return reu
}

//
function getStatePosList(root){
    var statePosList = []
    for(let state of root["stateList"]){ //找到statename
        var statePos = {}
        statePos["stateName"] = state["name"]
        statePos["x"] = state["x"]
        statePos["y"] = state["y"]
        statePosList.push(statePos)
    }
    console.debug(JSON.stringify(statePosList))
    return statePosList
}

//
function getTransitionsList(root){
    var transitionsList =[]
    for(let state of root["stateList"]){ //找到statename
    for(let main of state["mainList"]){//找到transitions
        if(main["name"] === "transitionsAction"){
        for(let sub of main["subList"]){ //遍历所有的sub然后加入
            var transitinos ={}
            for(let ele of sub["detail"]){
            if(ele["eleName"] === "trigger"){
                transitinos["trigger"] = ele["eleVal"]
            }else if(ele["eleName"]==="source"){
                transitinos["source"] = ele["eleVal"]
            }else if(ele["eleName"]==="dest"){
                transitinos["dest"] = ele["eleVal"]
            }
            }
            transitionsList.push(transitinos)
        }
        }
    }
    }
    console.debug(JSON.stringify(transitionsList))
    return transitionsList
}
