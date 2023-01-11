.pragma library

/**
  *给点重新随机设置初始位置
  *@param statePosList 原始的数据列表，不能是空的 x y 都是0-1
  *@return 返回随机设置后的数据
*/
function randomPosList(statePostList) {

}

/**
  *加载state的qml文件并且绘制渲染到UI
  *@param statePostList 加载的文件的数据列表
  *@param allItem 绘制的根对象，加载生成的MachineGraphElement对象依附到这个allItem上
*/
function loadRender(allItem, statePostList){
    var fileName = "MachineGraphElement.qml"
    for(var i=0 ;i<statePostList.length; i++){
        var obj = Qt.createComponent(fileName).createObject(allItem, {"controlInfo":statePostList[i]})
        obj.updateInfo(statePostList[i], allItem.width, allItem.height)
        obj.stateName = statePostList[i]["stateName"]
        obj.sigStateIndex.connect(allItem.parent.slotStateIndex)
        obj.sigStatePosChange.connect(allItem.parent.slotStatePosChange)
   }
}

/**
  已经存在了element 更新位置
*/
function updateRender(allItem, statePostList){
    for(var i=0 ;i<statePostList.length; i++){
        allItem.children[i].updateInfo(statePostList[i], allItem.width, allItem.height)
    }
}

/**
  *画线
  @param ctx 绘图的控制块
  @param statePosList 绘图的点集合
  @param transitionsList 线
  @param RectWidth
  @param RectHeight  画板的宽度和高度
*/
function drawLine(ctx, statePosList, transitionsList, RectWidth, RectHeight) {
    // 画之前清空画布
    ctx.clearRect(0, 0, RectWidth, RectHeight);
    //绘制每一条线
    for(var i=0; i<transitionsList.length; i++){
        if(transitionsList[i]["source"] !== "*"){  //排除最后一个
        var startpos =0;
        var endpos =0;
        //找到起始点信息
        for(var j=0; j<statePosList.length; j++){
            if(transitionsList[i]["source"] === statePosList[j]["stateName"]){
                startpos =j
            }
        }
        //找到结束点信息
        for(var n=0; n<statePosList.length; n++){
            if(transitionsList[i]["dest"] === statePosList[n]["stateName"]){
                endpos = n
            }
        }
        //绘制
//        console.debug("起始pos:"+statePosList[startpos]["stateName"]+"结束："+statePosList[endpos]["stateName"]+i)
        var start =[statePosList[startpos]["x"]*RectWidth, statePosList[startpos]["y"]*RectHeight]
        var end =[statePosList[endpos]["x"]*RectWidth, statePosList[endpos]["y"]*RectHeight]
        ctx.beginPath();          // 开始一条路径
        ctx.moveTo(start[0], start[1]);         // 移动到指定位置
        ctx.lineTo(end[0], end[1]);
//        ctx.strokeText(transitionsList[i]["trigger"], (end[0]+start[0])/2, (end[1]+start[1])/2);
        ctx.stroke();
    }
    }
}


/**
  *计算每一个节点所受的斥力
  *@param nodeList 所有的状态列表
  *@return返回一次斥力列表 顺序不变
*/
function getRepulsiveForce(nodeList){
    var forceList =[]
    for(let i of nodeList){
        var resultantForce = [0, 0]
        for(let j of nodeList){
            if(i["stateName"] !== j["stateName"]){
                //源减去其他的
                resultantForce[0] += (i["x"] - j["x"])>0? 1/Math.pow((i["x"] - j["x"]),2): -1/Math.pow((i["x"] - j["x"]),2)
                resultantForce[1] += (i["y"] - j["y"])>0? 1/Math.pow((i["y"] - j["y"]),2): -1/Math.pow((i["y"] - j["y"]),2)
            }
        }
        forceList.push(resultantForce)
    }
    return forceList
}

/**
  *计算每一个节点有连接的引力
  *@param nodeList 所有的状态列表
  *@param linkList 所有的连接
*/
function getAttractiveForce(nodeList, linkList){
    var forceList = []
    //每一个节点都遍历
    for(let i of nodeList){
        var resultantFore = [0, 0]
        //找到所有跟这个关联的节点并且获取引力
        for(let j of linkList){

            if(j["source"] === i["stateName"]){
            //如果匹配的是source
            var dest = j["dest"] //关联的目标节点
            //找到目标节点
            for( let n of nodeList){
            if(dest === n["stateName"]){
                 //其他的减去源
//                console.debug("source"+Math.pow((n["x"]-i["x"]),2))
                 resultantFore[0] += (n["x"]-i["x"])>0 ? 1/Math.pow((n["x"]-i["x"]),2) : -1/Math.pow((n["x"]-i["x"]),2)
                 resultantFore[1] += (n["y"]-i["y"])>0 ? 1/Math.pow((n["y"]-i["y"]),2) : -1/Math.pow((n["y"]-i["y"]),2)
            }}}

            //如果匹配的是dest 并且不是最后一个source为*
            if(j["dest"] === i["stateName"] && j["source"]!=="*"){
            var source = j["source"] //关联的目标节点
            //找到目标节点
            for( let m of nodeList){
            if(source === m["stateName"]){
            //其他的减去源
//                console.debug("dest"+1/Math.pow((m["x"]-i["x"]),2))
                resultantFore[0] += (m["x"]-i["x"])>0 ? 1/Math.pow((m["x"]-i["x"]),2) : -1/Math.pow((m["x"]-i["x"]),2)
                resultantFore[1] += (m["y"]-i["y"])>0 ? 1/Math.pow((m["y"]-i["y"]),2) : -1/Math.pow((m["y"]-i["y"]),2)
             }}}

        }//第二个for循环

        forceList.push(resultantFore)
    }
    return forceList
}



/**
  * 执行计算 斥力*系数 + 引力*系数 得到偏移量（最大最小限幅）
  * 对原有的位置新加
*/
function updatePos(nodeList, linkList, step){
    const rk = 0.001  //斥力的系数
    const ak = 0.04    //引力的系数
    const maxOffset = 0.3 //最大距离
    const minOffset = 0.01 //最小
    for(let i=0; i<step; i++){
    //计算斥力
        var repForce = getRepulsiveForce(nodeList)
        console.debug("斥力"+JSON.stringify(repForce))
    //计算引力
        var attForce = getAttractiveForce(nodeList, linkList)
        console.debug("引力"+JSON.stringify(attForce))

        var resForce = []
        for(let j=0; j<nodeList.length; j++){
    //两者合力
        var temp = [0,0]
        temp[0] = repForce[j][0]*rk + attForce[j][0]*ak
        temp[1] = repForce[j][1]*rk + attForce[j][1]*ak
        resForce.push(temp)
        console.debug("temp"+JSON.stringify(resForce[j]))
    //限幅
        if(resForce[j][0]>0){
            resForce[j][0] = resForce[j][0]>maxOffset?maxOffset:resForce[j][0]
            resForce[j][0] = resForce[j][0]<minOffset?minOffset:resForce[j][0]
        }
        else{
            resForce[j][0] = resForce[j][0]<-maxOffset?-maxOffset:resForce[j][0]
            resForce[j][0] = resForce[j][0]>-minOffset?-minOffset:resForce[j][0]
        }
        if(resForce[j][1]>0){
            resForce[j][1] = resForce[j][1]>maxOffset?maxOffset:resForce[j][1]
            resForce[j][1] = resForce[j][1]<minOffset?minOffset:resForce[j][1]
        }
        else{
            resForce[j][1] = resForce[j][1]<-maxOffset?-maxOffset:resForce[j][1]
            resForce[j][1] = resForce[j][1]>-minOffset?-minOffset:resForce[j][1]
        }

        //加一起
        nodeList[j]["x"] = parseFloat(nodeList[j]["x"]) + resForce[j][0]
        nodeList[j]["y"] = parseFloat(nodeList[j]["y"]) + resForce[j][1]
        if(nodeList[j]["x"]>1){nodeList[j]["x"]=1}
        if(nodeList[j]["x"]<0){nodeList[j]["x"]=0}
        if(nodeList[j]["y"]>1){nodeList[j]["y"]=1}
        if(nodeList[j]["y"]<0){nodeList[j]["y"]=0}
        }
        console.debug("限幅后的"+JSON.stringify(resForce))


    }
    console.debug(JSON.stringify(nodeList))
    return nodeList
}



/**
  * 添加一个信息state
  * 干三件事情：给machineGraph的statePosList添加state信息
  *           给allItem添加ele对象
  *           发送信号给TaskBuild
*/
function addNewState(allItem, stateName, x, y){
    var temp ={"stateName":stateName, "x":x.toString(), "y":y.toString()}
    allItem.parent.statePosList.push(temp)

    var fileName = "MachineGraphElement.qml"
    var obj = Qt.createComponent(fileName).createObject(allItem, {"controlInfo":temp})
    obj.updateInfo(temp, allItem.width, allItem.height)
    obj.stateName = stateName
    obj.sigStateIndex.connect(allItem.parent.slotStateIndex)
    obj.sigStatePosChange.connect(allItem.parent.slotStatePosChange)


    allItem.parent.sigAddNewState(stateName)
}
