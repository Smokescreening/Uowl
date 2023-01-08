# This Python file uses the following encoding: utf-8
# @author runhey
# github https://github.com/runhey

from PySide6.QtCore import QObject, Slot, Signal

from Src.Log4 import singleton

@singleton
class Bridge(QObject):
    #  前台信号 -> 后台槽
    sigPresentTasks = Signal(str)  # UI控制后台线程任务信号
    sigThreadExit = Signal()  # 线程退出

    #  后台信号 -> 前台槽
    sigUIUpdateProgressBar = Signal(float)  # 后台控制前台进度条
    sigUIUpdateRemainTime = Signal(str)  # 后台控制前台剩余时间
    sigUIUpdatePresentTask = Signal(str)  # 后台控制前台当前任务
    sigUIUpdatePresentState = Signal(str)  # 后台控制前台当前状态

    # 后台信号 -> 后台槽

    def __init__(self) -> None:
        super().__init__()

