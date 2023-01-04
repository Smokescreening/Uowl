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

    def writeSettingFromDevice(self, baseSetting :dict =None, android :dict =None, mumu :dict =None, leidian :dict =None) -> None:
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
                    print(root["baseSetting"][i]["name"], name)
                    if root["baseSetting"][i]["name"] == name:
                        root["baseSetting"][i]["controlValue"] = value
        if android is not None:
            for i in range(len(root["android"])):
                for name, value in baseSetting.items():
                    print(root["android"][i]["name"], name)
                    if root["android"][i]["name"] == name:
                        root["android"][i]["controlValue"] = value
        if mumu is not None:
            for i in range(len(root["mumu"])):
                for name, value in baseSetting.items():
                    print(root["mumu"][i]["name"], name)
                    if root["mumu"][i]["name"] == name:
                        root["mumu"][i]["controlValue"] = value
        if leidian is not None:
            for i in range(len(root["leidian"])):
                for name, value in baseSetting.items():
                    print(root["leidian"][i]["name"], name)
                    if root["leidian"][i]["name"] == name:
                        root["leidian"][i]["controlValue"] = value
        ConfigFile().writeSettingString( json.dumps(root))




# baseSetting = {"v1":"eeee", "v11":"vv333333332"}
# root = {
#     "baseSetting":[
#         {"name":"v1", "controlValue":"v2"},
#         {"name":"v11", "controlValue":"v22"}
#      ]
# }
# for i in range(len(root["baseSetting"])):
#     for name, value in baseSetting.items():
#         print(root["baseSetting"][i]["name"], name)
#         if root["baseSetting"][i]["name"] == name:
#             root["baseSetting"][i]["controlValue"] = value
# print(root)