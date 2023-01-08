# This Python file uses the following encoding: utf-8
# @author runhey
# github https://github.com/runhey
# 行为： 点击 滑动 切换状态 改变变量
import numpy

from PySide6.QtCore import Slot, QObject
from numpy.random  import  rand, randint, choice

from Src.Log4 import Log4
from Src.Device import Device


class ClickAction(QObject):
    def __init__(self, screenSize :list, actionInfo :dict, device :Device) -> None:
        super(ClickAction, self).__init__()
        self.screenSize :list = screenSize  # 设备的尺寸，这个是为了点击位置经过算法后给一个限度
        self.device = device
        self.actionName = actionInfo["actionName"]
        self.limits = int(actionInfo["limits"])  # 一个正态分布不需超出这个范围
        self.moveX = float(actionInfo["moveX"])  # 对输入的坐标点移动的百分比
        self.moveY = float(actionInfo["moveY"])  # 这个解决某些情况下识别到了图片但是其实并不是要点击图片的问题
        Log4().log("info", f'action载入->actionName:{self.actionName},  点击范围限制:{self.limits},  移动偏移:x{self.moveX},y{self.moveY}')

    @Slot(dict)
    def deal(self, info :dict) -> None:
        # if info["limits"] :
        #     self.limits = int(info["limits"])
        # if info["moveX"] :
        #     self.moveX = float(info["moveX"])
        # if info["moveY"] :
        #     self.moveY = float(info["moveY"])
        # 生成二维高斯分布并抽取一个
        while(True):
            randList = rand(30, 2)  # 30个
            biasRate = randList[ randint(30)]
            moveX : int = int(self.moveX) + int(biasRate[0]*self.limits)
            moveY : int = int(self.moveY) + int(biasRate[1]*self.limits)
            endX : int = int(info["position"][0])+moveX
            endY : int = int(info["position"][1])+moveY
            screenWidth : int = int(self.screenSize[0])
            screenHeight : int = int(self.screenSize[1])
            if (endX < screenWidth) and (endY < screenHeight):
                self.device.click([endX, endY])
                Log4().log("info", f'clickAction: 点击坐标: {endX} {endY}')
                break


class IntChangeAction(QObject):
    """
    没有想好先放着
    """
    def __init__(self):
        super(IntChangeAction, self).__init__()


class TransitionsAction(QObject):
    """

    """
    def __init__(self, taskObj, actionInfo :dict):
        """
        第一个是task对象的引用 第二个是相关信息
        :param taskObj:
        :param actionInfo:
        """
        super(TransitionsAction, self).__init__()
        self.taskObj = taskObj
        self.actionName = actionInfo["actionName"]
        self.trigger = str(actionInfo["trigger"])
        self.source = actionInfo["source"]
        self.dest = actionInfo["dest"]
        Log4().log("info", f'transitions载入->从{self.source}到{self.dest},  触发器是:{self.trigger}')

    @Slot(dict)
    def deal(self, info: dict) -> None:
        """
        虽然传进来dict类型的参数，但是用不到，只要这个槽函数被触发了那就执行状态切换
        :return:
        """
        self.taskObj.trigger(self.trigger)



