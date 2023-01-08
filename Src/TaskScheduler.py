# This Python file uses the following encoding: utf-8
# @author runhey
# github https://github.com/runhey
from time import sleep



from PySide6.QtCore import QThread, QObject, Signal, Slot
from apscheduler.schedulers.blocking import BlockingScheduler

from Src.Log4 import Log4, singleton
from Src.ConfigFile import ConfigFile
from Src.Bridge import Bridge
from Src.Device import Device
from Src.Task.Task import Task



def queneExecute() -> None:
    """
    BlockingScheduler是在一个进程下面的所以说是非阻塞的可能会有同时有多个个任务执行,而我们的需求是唯一的任务执行并且FIFO
    所以说要定义一个队列，需要一个轮询来执行任务
    我们是这么设计的：apscheduler单纯作为一个定时器作用来触发weekly和daily任务，触发之后把任务添加到queue;
                  当然forthwidth任务也在点击按钮的时候添加到queue,好了现在得到了任务队列
                  然后我们要设计在apscheduler中5s轮询一次判断队列是否有任务，如果有则执行（噢对了加上一个互斥锁）
    :return:
    """
    taskSche = TaskScheduler()  # 单例模式只是拿到一个引用
    if len(taskSche.queue) != 0 and taskSche.lock is True:
        taskSche.lock = False  # 记得后面释放
        taskInfo = taskSche.queue[0]
        del taskSche.queue[0]
        Bridge().sigUIUpdatePresentTask.emit(taskInfo["taskName"])  # 向ui发送当前的任务
        taskSche.task = Task(taskInfo["taskGroup"], taskInfo["taskName"], taskSche.device)
        taskSche.task.run()
        taskSche.lock = True  # 释放锁


@singleton
class TaskScheduler(QThread):
    def __init__(self) -> None:
        super().__init__()
        self.device = Device(ConfigFile.getSettingDict("baseSetting"),
                             ConfigFile.getSettingDict("android"),
                             ConfigFile.getSettingDict("mumu"),
                             ConfigFile.getSettingDict("leidian"))

        self.task : Task= None
        self.queue :list = []  # 队列每一项都是任务的信息 包括指向具体的任务，以及当前设备的信息
        self.lock :bool = True   #任务互斥锁， true表示还没有上锁可以执行任务，false表示正在执行任务不能拿走
        self.scheduler = BlockingScheduler()
        self.scheduler.coalescing= True  # 哑弹任务关闭
        self.scheduler.add_job(queneExecute, id="queneExecute",
                               trigger="interval", seconds=5, max_instances=5, coalesce=False, jitter=0)
        Bridge().sigPresentTasks.connect(self.slotPresentTasks)
        Bridge().sigThreadExit.connect(self.slotThreadExit)
        Bridge().sigUIUpdateProgressBar.emit(0.4)

    def run(self) -> None:
        """
        第二个线程后端线程
        """
        QThread.sleep(1)  # 等个三秒钟设备qml初始化
        self.device.connect()
        self.device.updateSettingToFile()

        self.addWeeklyTask()
        self.addDailyTask()
        self.scheduler.start()

    @Slot(str)
    def slotPresentTasks(self, cmd: str) -> None:
        """
        由ui端控制的 任务按钮 有
        :param cmd:
        :return:
        """
        print(cmd)
        if cmd == "start":  # 开始
            self.addForthwithTask()
        elif cmd == "pause":  # 暂停
            self.task.taskChangeState("onPause")
            self.scheduler.pause()
            self.scheduler.pause_job("queneExecute")
        elif cmd == "resume": # 继续
            self.task.taskChangeState("running")
            self.scheduler.resume()
            self.scheduler.resume_job("queneExecute")
        elif cmd == "stop":  # 停止
            self.task.taskChangeState("quit")

    @Slot()
    def slotThreadExit(self) -> None:
        self.scheduler.remove_all_jobs()
        self.task.taskChangeState("quit")
        self.scheduler.shutdown(wait=False)
        self.terminate()  # 不安全退出

    def addWeeklyTask(self) -> None:
        pass
    def addDailyTask(self) -> None:
        pass
    def addForthwithTask(self) -> None:
        """
        向队列添加任务
        :return:
        """
        taskInfo :dict ={"taskGroup":"DailyGroup", "taskName":"DiGui"}
        self.queue.append(taskInfo)

    @staticmethod
    def test1(self) -> None:
        print("ddddd")

