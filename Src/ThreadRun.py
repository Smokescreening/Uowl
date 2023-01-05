# This Python file uses the following encoding: utf-8
# @author runhey
# github https://github.com/runhey
from time import sleep

from PySide6.QtCore import QThread, QObject, Signal, Slot

from Src.Log4 import Log4
from Src.Bridge import Bridge


class ThreadRun(QThread):
    def __init__(self, bridge, log4) -> None:
        super(ThreadRun, self).__init__()
        bridge.sigPresentTasks.connect(self.slotPresentTasks)

    def run(self) -> None:
        """
        第二个线程后端线程
        """
        while (1):
            QThread.sleep(5)
            Log4().sigUIShowLog.emit("info", "ff33333333333333333ddddddddddddff")
            Bridge().sigUIUpdateProgressBar.emit(0.6)
            Bridge().sigUIUpdateRemainTime.emit("20:33")
            Bridge().sigUIUpdatePresentTask.emit("tes i love u")
            Bridge().sigUIUpdatePresentState.emit("state1")

    @Slot(str)
    def slotPresentTasks(self, cmd: str) -> None:
        """
        由ui端控制的 任务按钮 有
        :param cmd:
        :return:
        """
        print(cmd)
