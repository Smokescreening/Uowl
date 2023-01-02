var rootSettingJS ={}

//从界面ui中得到修改后的json对象
function getListViewJson(){
    var listViewJson = [] //js数组
    for(var i=0; i<sListView.count; i++)
    {
        var json = sListView.itemAtIndex(i).getSettingJson() //得到每一个委托对象 并且获取json对象
        listViewJson.push(json)
    }
    //console.debug("从UI读取出来"+JSON.stringify(listViewJson))
    return listViewJson
}


//读取文件返回baseSetting android mumu leidian四个之一的json对象
//并重新赋值rootSettingJS , num输入数字
function readSettingJson(string){
    rootSettingJS = JSON.parse(configFile.readSettingString())
    switch(string){
    case "baseSetting":{
        //console.debug("这个是读取的参数"+JSON.stringify(rootSettingJS["baseSetting"][0]))
        return rootSettingJS["baseSetting"]
    }
    case "android":{
        return rootSettingJS["android"]
    }
    case "mumu":{
        return rootSettingJS["mumu"]
    }
    case "leidian":{
        return rootSettingJS["leidian"]
    }
    default:{
        return rootSettingJS["baseSetting"]
    }
    }
}

//传入设置类别 和对应的json对象  ，修改rootSettingJS的值并且写回文件
function writeSettingJson(string, json){
    switch(string){
    case "baseSetting":{
        rootSettingJS["baseSetting"] = json
    }break
    case "android":{
        rootSettingJS["android"] = json
    }break
    case "mumu":{
        rootSettingJS["mumu"] = json
    }break
    case "leidian":{
        rootSettingJS["leidian"] =json
    }break
    default:{
    }
    }
    //console.debug("这个是保存前的参数"+JSON.stringify(rootSettingJS["baseSetting"][0]))
    configFile.writeSettingString(JSON.stringify(rootSettingJS))
}
