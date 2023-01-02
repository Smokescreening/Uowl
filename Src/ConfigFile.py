# This Python file uses the following encoding: utf-8

import os
from pathlib import Path
from PySide6.QtCore import QObject, Slot, Property

class ConfigFile(QObject):
    def __init__(self):
        super().__init__()

    @Slot(str, str)
    def writeString(self, fileName:str, string:str)->None:
        with open(os.fspath(Path(__file__).resolve().parent.parent / "Config/fileName.json"), 'w', encoding='utf-8') as f:
            f.write(string)
        f.close()
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
    def writeSettingString(self, string:str) ->None:
        """
        写回配置文件 默认文件名
        :param string:
        :return:
        """
        with open(os.fspath(Path(__file__).resolve().parent.parent / "Config/setting.json"), 'w', encoding='utf-8') as f:
            f.write(string)
        f.close()