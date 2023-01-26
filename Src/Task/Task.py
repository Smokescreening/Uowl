# This Python file uses the following encoding: utf-8
# @author runhey
# github https://github.com/runhey

import json
import time

from PySide6.QtCore import QThread, QObject, Slot
from pathlib import Path
from transitions.extensions import GraphMachine as Machine
from numpy.random import uniform

from Src.Log4 import Log4
from Src.Bridge import Bridge
from Src.ConfigFile import ConfigFile
from Src.Task.Event import ImgEvent, IntVarEvent
from Src.Task.Action import ClickAction, IntChangeAction, TransitionsAction
from Src.Task.Before import Before
from Src.Device import Device

# @staticmethod
# def executeTask(tasckInfo :dict, taskCallback = None) -> None:
#     """
#     指向一个任务，包括任务的创建，执行
#     :param tasckInfo: 启动任务所需要的字典信息,包括任务的path,name,time
#     :param taskCallback:
#     :return:
#     """
#     print("I'm runing task start"+ tasckInfo)
#     QThread.sleep(9)
#     print("I'm runing task end" + tasckInfo)
#     taskGroup :str = tasckInfo["taskGroup"]
#     taskName :str = tasckInfo["taskName"]
#     task = Task(taskGroup, taskName)
#     task.run()
#     if taskCallback is not None :taskCallback()

class Task(Machine):
    def __init__(self, taskGroup :str, taskName :str, device :Device) -> None:
        self.runState = "running"  # 用来描述这个任务的运行情况  running 表示正在运行运行  onPause  exit表示状态直接切换到最后一个状态以供退出 quit强制退出之间关闭任务
        self.transState = False  # 有一个bug是切换状态的时候for迭代器并不会退出而是继续按照切换状态后的list对象继续迭代下去
        self.imgCurrentCount = 0  # 计数
        self.imgCurrentName = "0"  # 名字
        self.matchThreshold = None  #  单纯给imgEvent输入
        self.compressRate = None  # 图片的压缩率单纯给imgEvent输入
        self.intervalTime = None  # 任务执行的间隔时间
        self.runTime = None  # 这个是规定任务最多的时间
        self.timeOutFlag = False  # 用于执行一次超时标志位，到了会自动变True
        self.startTime = time.time()  # 记录起始时间 用于后面判断
        self.taskGroup = taskGroup
        self.taskName = taskName
        self.device = device
        self.mathWay = None
        match device.baseSetting["deviceType"]:
            case "安卓设备":
                self.mathWay = device.android["imgMathWay"]
                self.before = Before(device, [device.android["androidWidth"], device.android["androidHeight"]])
            case "mumu模拟器":
                self.mathWay = device.mumu["imgMathWay"]
                self.before = Before(device, [device.mumu["mumuWidth"], device.mumu["mumuHeight"]])
            case "雷电模拟器":
                self.mathWay = device.leidian["imgMathWay"]
                self.before = Before(device, [device.leidian["leidianWidth"], device.leidian["leidianHeight"]])
        self.statesList = []   # 用来输入到machine的初始化，以及查找状态的序号
        self.transitionsList = []  # 这个是状态transitions列表 单纯用来输入到machine的初始化
        self.statesInfoList = []  # 这个保存着这个任务所有状态所有的信息，在切换状态的时候拿出来
        self.readConfig()
        super(Task, self).__init__(model=self, states=self.statesList, initial=self.statesList[0],
                                   transitions=self.transitionsList, use_pygraphviz=True,
                                   show_auto_transitions=False, after_state_change='afterStateChange',
                                   title=self.taskName)
        # 下面这些是用来保存每个状态的事件动作, 注意里面的东西的Action和Event对象
        self.imgEventList = []
        self.intVarEventList = []
        self.clickActionList = []
        self.intChangeActionList = []
        self.transitionsActionList = []
        # 任务初始化后就可以载入信息了
        self.loadEventAction()

    def readConfig(self) -> None:
        """
        读配置文件,将读取的配置文件内容进行初始化：包括状态机的states,transitions,ininial
        :return:
        """
        config : dict = json.loads( ConfigFile().readTaskConfig(self.taskGroup, self.taskName))
        self.runTime = float(config["runTime"])
        self.intervalTime = float(config["intervalTime"])
        self.compressRate = float(config["compressRate"])
        self.matchThreshold = float(config["matchThreshold"])
        Log4().log("info", f'任务载入->taskGroup:{self.taskGroup}, taskName:{self.taskName}{config["nameZh"]}')
        Log4().log("info", f'任务载入->任务版本:{config["version"]}, 任务运行时间:{config["runTime"]}, 任务周期间隔:{config["intervalTime"]}, 图片压缩率{config["compressRate"]}, 图片识别阈值:{config["matchThreshold"]},  图片匹配方式:{self.mathWay}')
        for state in config["stateList"]:
            self.statesList.append(state["stateName"])
        self.transitionsList = list(config["transitionsList"])
        self.statesInfoList = config["stateList"]

    def saveStateMachineImg(self) -> None:
        """
        保存到对于的图状态
        :return:
        """
        filename = self.taskPath / self.taskName + '.png'
        self.get_graph().draw(filename, prog='dot',format='png')

    def afterStateChange(self) -> None:
        """
        当状态改变后从新载入该状态的event和action，并且从新绑定两者
        :return:
        """
        self.taskChangeState("onPause")
        self.loadEventAction()
        self.taskChangeState("running")
        self.transState = True

    def loadEventAction(self) -> None:
        """
        载入 信息
        :return:
        """
        index = self.statesList.index( self.state )
        Bridge().sigUIUpdatePresentState.emit(self.state)  # 向ui发送当前状态
        self.imgEventList.clear()
        self.intVarEventList.clear()
        self.clickActionList.clear()
        self.intChangeActionList.clear()
        self.transitionsActionList.clear()
        Log4().log("info", f"状态载入->进入状态{self.state}")
        # 载入图片event
        if self.statesInfoList[index]["imgEvent"]:  # 如果不为空的
            for imgEvent in self.statesInfoList[index]["imgEvent"]:
                self.imgEventList.append( ImgEvent(self.taskGroup, self.taskName, self.mathWay,
                                                   self.compressRate, self.matchThreshold,
                                                   imgEvent))
        # 载入点击action  这里用偷懒获取屏幕尺寸
        size = []
        match ConfigFile().getSettingDict("baseSetting")["deviceType"]:
            case "安卓设备":
                 android = ConfigFile().getSettingDict("android")
                 size = [android["androidWidth"], android["androidHeight"]]
            case "mumu模拟器":
                 mumu = ConfigFile().getSettingDict("mumu")
                 size = [mumu["mumuWidth"], mumu["mumuHeight"]]
            case "雷电模拟器":
                leidian = ConfigFile().getSettingDict("leidian")
                size = [leidian["leidianWidth"], leidian["leidianHeight"]]
        if self.statesInfoList[index]["clickAction"]:
            for clickAction in self.statesInfoList[index]["clickAction"]:
                self.clickActionList.append( ClickAction(size, clickAction, self.device) )

        # 载入该状态的 transitions action 这个action会执行切换状态
        if self.statesInfoList[index]["transitionsAction"]:
            for transitionsAction in self.statesInfoList[index]["transitionsAction"]:
                self.transitionsActionList.append( TransitionsAction(self, transitionsAction))

        # 最后绑定 事件和动作
        if self.statesInfoList[index]["envent2actionld"]:
            for envent2actionld in self.statesInfoList[index]["envent2actionld"]:  # 一个一个绑定event action
                enventObj, actionObj = None, None   # 先定义两个引用，下面查找这两个引用，最后连接
                match envent2actionld["eventType"]:
                    case "imgEvent":
                        for i in range(len(self.imgEventList)):
                            if self.imgEventList[i].eventName == envent2actionld["eventName"]:
                                enventObj = self.imgEventList[i]
                    case "intVarEvent":
                        pass
                match envent2actionld["actionType"]:
                    case "clickAction":
                        for i in range(len(self.clickActionList)):
                            if self.clickActionList[i].actionName == envent2actionld["actionName"]:
                                actionObj = self.clickActionList[i]
                    case "intChangeAction":
                        pass
                    case "transitionsAction":
                        for i in range(len(self.transitionsActionList)):
                            if self.transitionsActionList[i].actionName == envent2actionld["actionName"]:
                                actionObj = self.transitionsActionList[i]
                if not enventObj:
                    Log4().log("info", "找不到eventObj imgEvent")
                if not actionObj:
                    Log4().log("info", "找不到actionObj ")
                enventObj.sigEvent.connect(actionObj.deal)

        # 最后如果这个状态是最后的goback态那么
        # 就绑定一个退出任务的槽
        if self.state == "goback":
            for i in range(len(self.imgEventList)):
                if self.imgEventList[i].eventName == "tansuo":
                    Log4().log("info",'状态载入->绑定goback 和 slotTaskQuit')
                    self.imgEventList[i].sigEvent.connect(self.slotTaskQuit)


    def taskChangeState(self, info :str):
        """
         这个函数是提供给外部 来改变运行的状态的
        :param info:
        :return:
        """
        match info:
            case "running":
                self.runState = "running"
            case "onPause":
                self.runState = "onPause"
            case "exit":
                # 强制进入最后的goback态 ,然后最后quit
                self.trigger("goback")
                # self.runState = "exit"
            case "quit":
                if self.runState == "onPause":
                    self.runState = "exit"
                else:
                    self.runState = "quit"

    @Slot(dict)
    def slotTaskQuit(self, info :dict) -> None:
        """

        :param self:
        :param info:
        :return:
        """
        self.taskChangeState("quit")
        Log4().log("info", "任务接受，退出")
        Bridge().sigUISetRunState.emit(0)

    def run(self):
        while True:
            match self.runState:
                case "running":
                    startTime = time.time()
                    srcSreen = self.device.getScreen()
                    # 先处理协作等等
                    self.before.deal(srcSreen)
                    # 图片事件处理
                    for imgEvent in self.imgEventList:
                        if self.transState == True:
                            self.transState = False
                            break
                        if imgEvent.deal(srcSreen):
                            self.exceptionCount(imgEvent.eventName)

                    costTime = float(time.time() - startTime)
                    randTime = uniform(-0.5, 0.5)  # 随机上下波动
                    sleepTime = self.intervalTime - costTime + randTime
                    Log4().log("info", f'执行一轮判断花费时间:{round(costTime, 2)}, {round(sleepTime, 2)}后继续判断')
                    totalTime = int(time.time() - self.startTime)  # 还是秒为单位
                    totalMinute, totalSdcond = int(totalTime/60), totalTime%60  #
                    Bridge().sigUIUpdateRemainTime.emit( f'{totalMinute}:{totalSdcond}')  # 向UI发送还剩多少时间
                    Bridge().sigUIUpdateProgressBar.emit(round(totalTime/60/self.runTime, 2))  # 向UI发送进度条的值
                    if not self.timeOutFlag :  # 还没有超时判断一下
                        if self.state != "goback":
                            if float(totalTime/60) >= self.runTime:
                                self.timeOutFlag = True
                                self.taskChangeState("exit")  # 时间到了 要退出任务
                    if sleepTime > 0:
                        QThread.sleep(sleepTime)
                case "onPause":
                    QThread.sleep(1)
                case "exit":
                    Log4().log("info", '任务退出exit')
                    return None
                case "quit":
                    return None

    def exceptionCount(self, imgEventName :str) -> None:
        """
        用来解决连续多次识别到一个图片，这说明运行出错了，跳转到goback态退出
        :param imgEventName:
        :return:
        """
        if self.imgCurrentName == imgEventName:
            self.imgCurrentCount += 1
            if self.imgCurrentCount >= 20:  # 超过20次退出
                self.taskChangeState("exit")
        else:
            self.imgCurrentName = imgEventName
            self.imgCurrentCount = 0
# device = Device(ConfigFile.getSettingDict("baseSetting"),
#                              ConfigFile.getSettingDict("android"),
#                              ConfigFile.getSettingDict("mumu"),
#                              ConfigFile.getSettingDict("leidian"))
# device.connect()
# device.updateSettingToFile()
# task = Task('DailyGroup', 'DiGui', device)
# task.run()
# iii = ImgEvent()

