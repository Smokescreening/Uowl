# This Python file uses the following encoding: utf-8
# @author runhey
# github https://github.com/runhey

import os


from datetime import datetime
from pathlib import Path
from PySide6.QtCore import QObject, Slot, Signal

def singleton(cls):  # 单例模式
    _instance = {}
    def inner():
        if cls not in _instance:
            _instance[cls] = cls()
        return _instance[cls]
    return inner

@singleton
class Log4(QObject):
    sigUIShowLog = Signal(str, str)  # 这个信号连接UI的Log信息内容

    def __init__(self) -> None:
        super().__init__()
        self.f = None

    @Slot(str)
    def slotStartLog(self, taskName: str) -> None:
        """
        打开一个日记文件以便写入，需要最后的时候关闭
        :param taskName: 文件名不带后缀
        :return:
        """
        nowDateTime:str = datetime.now().strftime("%m-%d^%H")
        self.f = open(os.fspath(Path(__file__).resolve().parent.parent / "Log/" / ('%s@%s'%(nowDateTime,taskName)+".txt")), 'a', encoding='utf-8')

    @Slot()
    def slotFinishLog(self) -> None:
        self.f.close()
        self.f = None

    @Slot(str, str)
    def slotLog(self, grade: str, info:str) -> None:
        """
        向文件写入和向UI输出
        :param grade: info debug warning error log 五个级别
        :param info: log的内容
        :return:
        """
        nowDateTime: str = datetime.now().strftime("%H:%M:%S.%f")
        if grade is not None and info is not None:
            if self.f is not None:
                self.f.write('%s:%s'%(nowDateTime[:11], info) + '\r')
            self.sigUIShowLog.emit(grade, info)

    @Slot(str, str)
    def log(self, grade: str, info:str) -> None:
        """
        在一个进程内部数据是共享的，但是这个类是单例并且我是定义在GUI线程里面的
        而在这里的用法不正常，使用的情况是在后台线程一般做法是用信号槽，但是考虑到只用这个后台线程使用所以就这么透露了
        :param grade:
        :param info:
        :return:
        """
        nowDateTime: str = datetime.now().strftime("%H:%M:%S.%f")
        if grade is not None and info is not None:
            if self.f is not None:
                self.f.write('%s:%s' % (nowDateTime[:11], info) + '\r')
            self.sigUIShowLog.emit(grade, f'{nowDateTime[:11]}: {info}')
