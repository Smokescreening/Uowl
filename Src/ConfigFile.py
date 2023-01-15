# This Python file uses the following encoding: utf-8

import os
import json
from pathlib import Path
from PySide6.QtCore import QObject, Slot

class ConfigFile(QObject):
    def __init__(self) -> None:
        super().__init__()

    @Slot(result="QString")
    def readSettingString(self) ->str:
        """
        :return: 返回setting的内容，不改变文件
        """
        with open(os.fspath(Path(__file__).resolve().parent.parent / "Config/setting.json"), 'r', encoding='utf-8') as f:
            settingString = f.read()
        f.close()
        return settingString

    @Slot(str)
    def writeSettingString(self, string:str) -> None:
        """
        写回配置文件 默认文件名
        :param string:
        :return:
        """
        with open(os.fspath(Path(__file__).resolve().parent.parent / "Config/setting.json"), 'w', encoding='utf-8') as f:
            f.write(string)
        f.close()

    @staticmethod
    def getSettingDict(baseName: str) -> dict:
        """
        读取设置文件获取对应的设置的字典
        :param baseName: 子一级设置名 如baseSetting
        :return: 设置的字典
        """
        with open(os.fspath(Path(__file__).resolve().parent.parent / "Config/setting.json"), 'r', encoding='utf-8') as f:
            settingString :str = f.read()
        f.close()
        name: list =[]
        value: list =[]
        for item in json.loads(settingString)[baseName]:
            name.append(item["name"])
            value.append(item["controlValue"])
        return dict(zip(name, value))

    def writeSettingFromDevice(self, baseSetting :dict , android :dict , mumu :dict , leidian :dict ) -> None:
        """
        拿到 name-controlValue的四个字典
        把值写回去到文件里面去
        :param baseSetting:
        :param android:
        :param mumu:
        :param leidian:
        :return:
        """
        root =json.loads( self.readSettingString())
        if baseSetting is not None:
            for i in range(len(root["baseSetting"])):
                for name, value in baseSetting.items():
                    if root["baseSetting"][i]["name"] == name:
                        root["baseSetting"][i]["controlValue"] = str(value)
        if android is not None:
            for i in range(len(root["android"])):
                for name, value in android.items():
                    if root["android"][i]["name"] == name:

                        root["android"][i]["controlValue"] = str(value)
        if mumu is not None:
            for i in range(len(root["mumu"])):
                for name, value in mumu.items():
                    if root["mumu"][i]["name"] == name:
                        root["mumu"][i]["controlValue"] = str(value)
        if leidian is not None:
            for i in range(len(root["leidian"])):
                for name, value in leidian.items():
                    if root["leidian"][i]["name"] == name:
                        root["leidian"][i]["controlValue"] = str(value)
        configSettingStr = json.dumps(root, ensure_ascii=False)
        ConfigFile().writeSettingString( configSettingStr )


    def readTaskConfig(self, taskGroup :str, taskName :str) -> str:
        """
        读取配置文件，只读不写
        :param taskGroup:
        :param taskName:
        :return:
        """
        if taskGroup is not None and taskName is not None:
            fileName = str (Path(__file__).parent.parent / 'Tasks' / taskGroup / taskName / 'taskConfig.json')
            with open(fileName, 'r', encoding='utf-8') as f:
                taskConfig = f.read()
            f.close()
            return taskConfig
        else:
            return None

    @Slot(str, str, result="QString")
    def readTaskConfigUI(self, taskGroup :str, taskName :str) -> str:
        if taskGroup and taskName :
            fileName = str(Path(__file__).parent.parent / 'Tasks' / taskGroup / taskName / 'taskConfigUI.json')
            with open(fileName, 'r', encoding='utf-8') as f:
                taskConfigUI = f.read()
            f.close()
            return taskConfigUI
        else:
            return None

    @Slot(str, str, str)
    def writeTaskConfigUI(self, taskGroup :str, taskName :str, string :str) -> None:
        if taskGroup and taskName:
            fileName = str(Path(__file__).parent.parent / 'Tasks' / taskGroup / taskName / 'taskConfigUI.json')
            with open(fileName, 'w', encoding='utf-8') as f:
                f.write(string)
            f.close()

    @Slot(result="QString")
    def getGroupTaskList(self) -> str:
        """
           {"list": [{"name": "DailyGroup", "list": [{"name": "DiGui"}, {"name": "DiGui2"}]}, {"name": "feijfeiGroup", "list": [{"name": "666"}, {"name": "DiGui"}]}, {"name": "uuuuuu88888Group", "list": [{"name": "g"}, {"name": "rrrr"}]}]}
        :return:   返回一个如上的列表 key 就是group的名字 value 就是 下一级的 task 名字
        """
        path = Path(__file__).parent.parent / 'Tasks'
        res :list = []
        for group in path.iterdir():
            g :list = {}
            if group.parts[-1] != "DefaultGroup":
                g["name"] = group.parts[-1]
                g["list"] = []
                for task in group.iterdir():
                    if( Path(task/"taskConfigUI.json").exists):
                        g["list"].append({"name":task.parts[-1]})
                res.append(g)
        return json.dumps({"list":res}, ensure_ascii=False)
# print( ConfigFile().getGroupTaskList())

    @Slot(result="QString")
    def readTaskScheduler(self) -> str:
        fileName = Path(__file__).parent.parent / "Config" /"taskScheduler.json"
        with open(fileName, 'r', encoding='utf-8') as f:
            taskScheduler = f.read()
        return taskScheduler

    @Slot(str)
    def writeTaskScheduler(self, info :str) -> None:
        fileName = Path(__file__).parent.parent / "Config" / "taskScheduler.json"
        with open(fileName, 'w', encoding='utf-8') as f:
            f.write(info)