# This Python file uses the following encoding: utf-8
import os
from pathlib import Path
import sys

from PySide6.QtGui import QGuiApplication, QIcon
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import Qt

from Src.ConfigFile import ConfigFile


if __name__ == "__main__":
    # 适配高分辨率
    QGuiApplication.setHighDpiScaleFactorRoundingPolicy(Qt.HighDpiScaleFactorRoundingPolicy.Round)
    # 声明
    app = QGuiApplication(sys.argv)
    # 设置Logo
    QGuiApplication.setWindowIcon(QIcon(os.fspath(Path(__file__).resolve().parent / "GuiImage/logo/logo-64.ico")))
    # 设置软件名字
    QGuiApplication.setApplicationName("Uowl")


    # 初始化模块
    configFile = ConfigFile()

    engine = QQmlApplicationEngine()
    engine.rootContext().setContextProperty("configFile",configFile)
    engine.load(os.fspath(Path(__file__).resolve().parent / "GuiQML/main.qml"))
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
