# This Python file uses the following encoding: utf-8
# @author runhey
# github https://github.com/runhey
# 行为： 点击 滑动 切换状态 改变变量
import numpy

from PySide6.QtCore import Slot, QObject
from numpy.random  import  rand, randint, choice
from math import sin, cos, radians

from Src.Log4 import Log4
from Src.Device import Device
from Src.ConfigFile import ConfigFile


class ClickAction(QObject):
    def __init__(self, screenSize :list, actionInfo :dict, device :Device) -> None:
        super(ClickAction, self).__init__()
        self.screenSize :list = screenSize  # 设备的尺寸，这个是为了点击位置经过算法后给一个限度
        self.device = device
        self.actionName = actionInfo["actionName"]
        self.limits = int(float(actionInfo["limits"]))  # 一个正态分布不需超出这个范围
        self.moveX = float(actionInfo["moveX"])  # 对输入的坐标点移动的百分比
        self.moveY = float(actionInfo["moveY"])  # 这个解决某些情况下识别到了图片但是其实并不是要点击图片的问题
        Log4().log("info", f'action载入->actionName:{self.actionName},  点击范围限制:{self.limits},  移动偏移:x{self.moveX},y{self.moveY}')

    @Slot(dict)
    def deal(self, info :dict) -> None:
        # 生成二维高斯分布并抽取一个
        while(True):
            randList = rand(30, 2)  # 30个
            biasRate = randList[ randint(30)]
            moveX : int = int(self.moveX*int(self.screenSize[0])) + int(biasRate[0]*self.limits)
            moveY : int = int(self.moveY*int(self.screenSize[1])) + int(biasRate[1]*self.limits)
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


class SwipeAction(QObject):
    def __init__(self, screenSize :list, actionInfo :dict, device :Device) -> None:
        """

        :param screenSize:  屏幕大小
        :param actionInfo:  信息
        :param device:  持有设备引用
        """
        super(SwipeAction, self).__init__()
        self.screenSize: list = screenSize  # 设备的尺寸，这个是为了点击位置经过算法后给一个限度
        self.device = device
        self.actionName = actionInfo["actionName"]
        self.angle : int = actionInfo["angle"]   # 0-360  0表示向右90表示向上180表示向左360表示向下
        self.distance : float = actionInfo["distance"]  # 0-1
        self.random :int = actionInfo["random"]  # 5-50

    @Slot(dict)
    def deal(self, info: dict) -> list:
        """
        滑动坐标模型是这样工作的：首先取得滑动的中心点，取得一个偏转角参数（代表方向），如此得到点斜式的直线
        再获得滑动距离百分比这个参数乘以设备屏幕的大小得到x和y方向滑动的绝对距离，进而得到滑动的起始和结束的坐标
        ，最后对两个坐标以一个限定的范围进行二维的随机分布，在没有超出屏幕的前提下进行最终设备的轨迹滑动
        :param info: 传过来的滑动信息, centerPos:滑动的坐标中心点如[500, 400]， distance: 滑动距离百分比
        :return: 返回最终的滑动起始点和结束点
        """
        vector :list = [cos(radians(self.angle))*self.screenSize[0]*self.distance, sin(radians(self.angle))*self.screenSize[1]*self.distance]
        tempStart = [info["centerPos"][0] - vector[0]/2, info["centerPos"][1] - vector[1]/2]
        tempEnd = [info["centerPos"][0] + vector[0]/2, info["centerPos"][1] + vector[1]/2]
        while(True):
            startPos = [int(tempStart[0] + randint(-self.random, self.random)), int(tempStart[1] + randint(-self.random, self.random))]
            endPos = [int(tempEnd[0] + randint(-self.random, self.random)), int(tempEnd[1] + randint(-self.random, self.random))]
            if startPos[0]>0 and startPos[0]<self.screenSize[0] and startPos[1]>0 and startPos[1]<self.screenSize[1] and \
               endPos[0] > 0 and endPos[0] < self.screenSize[0] and endPos[1] > 0 and endPos[1] < self.screenSize[1]:
                self.device.swipe(startPos, endPos)
                return [startPos, endPos]

def testSwipe() -> None:
    device = Device(ConfigFile.getSettingDict("baseSetting"),
                             ConfigFile.getSettingDict("android"),
                             ConfigFile.getSettingDict("mumu"),
                             ConfigFile.getSettingDict("leidian"))
    device.connect()
    device.updateSettingToFile()
    swipe = SwipeAction([1280, 720], {"actionName": "test", "angle": 0, "distance": 0.3, "random": 10}, device)
    print(swipe.deal({"centerPos": [640, 500]}))

# testSwipe()