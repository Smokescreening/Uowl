# This Python file uses the following encoding: utf-8
# @author runhey
# github https://github.com/runhey

import cv2
import re
from PySide6.QtCore import QThread

from numpy import frombuffer, uint8, array
from pathlib import Path
from subprocess import Popen, PIPE
from win32con import SRCCOPY
from win32com.client import Dispatch
from win32gui import GetWindowText, FindWindow, FindWindowEx, IsWindow, GetWindowRect, GetWindowDC, DeleteObject, SetForegroundWindow
from win32process import GetWindowThreadProcessId
from win32ui import CreateDCFromHandle, CreateBitmap
from PIL import ImageGrab
from pyautogui import position, click, moveTo

class Device():
    def __init__(self, baseSetting :dict, android :dict, munu :dict, leidian :dict) -> None:
        super(Device, self).__init__()
        self.baseSetting :dict = baseSetting
        self.android :dict = android
        self.mumu :dict = munu
        self.leidian :dict = leidian

    def checkDevic(self) -> None:
        """
        检查 对设备的连接状态
        :return:
        """
        match self.baseSetting["客户端设备"]:
            case "安卓设备" :
                pass
            case "mumu模拟器" :
                pass
            case "雷电模拟器" :
                pass

    def connectDevice(self) -> None:
        """
        连接设备
        :return:
        """
        pass




class Adb():
    """
    用来执行根abd操作有关的类，不实例化，内部类
    """
    def __init__(self) -> None:
        pass
    @classmethod
    def dealCmd(cls, cmd :str, deviceId :str =None):
        """
        向设备输入一条指令, 返回管道内的东西
        :param cmd:
        :param deviceId:
        :return: 动态返回
        """
        path = Path(__file__).resolve().parent / 'adb.exe'
        if deviceId is None:
            command: str = str(path) + ' ' + cmd
        else:
            command: str = f'{str(path)} -s {deviceId} {cmd}'
        return Popen(command, shell=True, stdout=PIPE).stdout.read()

    @classmethod
    def checkStatus(cls) -> str:
        """
        返回第一个设备的id
        # 检测设备是否在线,如果可以返回一个有设备id，offline and unknown的列表
        如果没有则不返回 为None
        :return:
        """
        result = Adb.dealCmd('devices').decode("utf-8")
        deviceList: list = []
        if result.startswith('List of devices attached'):
            result = result.strip().splitlines()  # 查看连接设备
            deviceSize = len(result)  # 查看连接数量
            if deviceSize > 1:
                for i in range(1, deviceSize):
                    deviceDetail = result[1].split('\t')
                    if deviceDetail[1] == 'device':
                        deviceList.append(deviceDetail[0])
                    elif deviceDetail[1] == 'offline':
                        deviceList.append('offline')
                    elif deviceDetail[1] == 'unknown':
                        deviceList.append('unknown')
            # return deviceList
            for device in deviceList:
                if device != 'offline' and device != 'unknown':
                    return device

    @classmethod
    def getScreenSize(cls, deviceId :str) -> list:
        """
        获取设备的屏幕尺寸是第一个参数是height  第二个是width
        :param deviceId:
        :return:
        """
        result = str(Adb.dealCmd(' shell wm size', deviceId))
        size = re.findall(r'\d+x\d+', result)
        return size[0].split("x")

    @classmethod
    def click(cls, deviceId :str, pos :list)-> None:
        """
        点击 Pos第一个是x 第二个是y
        :param deviceId:
        :param pos:
        :return:
        """
        command = rf' shell input tap {pos[0]} {pos[1]}'
        Adb.dealCmd(command, deviceId)

    @classmethod
    def getScreen(cls, deviceId :str):
        """
        返回一个灰色的 图片对象
        :param deviceId:
        :return:
        """
        command = rf' shell screencap -p'
        commend = Adb.dealCmd(command, deviceId)
        scrBytes = commend.replace(b'\r\n', b'\n')  # 传输
        scrImg = cv2.imdecode(frombuffer(scrBytes, uint8), cv2.IMREAD_COLOR)
        scrImg = cv2.cvtColor(scrImg, cv2.COLOR_BGRA2GRAY)
        return scrImg

# print( Adb.checkStatus())
# print( Adb.getScreenSize('CUYDU20102004949'))
# Adb.DoClick('CUYDU20102004949', [500, 500])
# img = Adb.getScreen('CUYDU20102004949')
# cv2.imshow("scr_img", img)  # 显示
# cv2.waitKey(10000)
# cv2.destroyAllWindows()

class Handle():
    """
    用于操作模拟器 窗口的类 依旧不实例化
    """
    def __init__(self):
        pass

    @classmethod
    def getHandleNum(cls, handleTitle :str) -> int:
        """
        返回句柄号 如果没有找到就是返回零
        :param handleTitle:
        :return:
        """
        handleNum = FindWindow(None, handleTitle)
        return handleNum

    @classmethod
    def getHandTitle(cls, handleNum :int) -> str:
        """
        通过句柄号返回窗口的标题，如果传入句柄号不合法则返回None
        :param handleNum:
        :return:
        """
        return None if handleNum is None or handleNum == 0 or handleNum == '' else GetWindowText(handleNum)

    @classmethod
    def getHandPid(cls, handleNum :int) -> int:
        """
        通过句柄号获取句柄进程id，如果句柄号非法则返回0
        :param handleNum:
        :return:
        """
        return 0 if handleNum is None or handleNum == 0 or handleNum == '' else GetWindowThreadProcessId(handleNum)[1]

    @classmethod
    def checkStatus(cls, handleNum :int) -> int:
        """
        如果窗口还存在返回1否则0
        :param handleNum:
        :return:
        """
        return IsWindow(handleNum)

    @classmethod
    def getSize(cls, handleNum :int) -> list:
        """
        返回一个由宽带高度组成的列表 第一项是宽带
        :param handleNum:
        :return:
        """
        winRect = GetWindowRect(handleNum)
        width :int = winRect[2] - winRect[0]  # 右x-左x
        height :int = winRect[3] - winRect[1]  # 下y - 上y 计算高度
        return [width, height]

    @classmethod
    def getScreen(cls, handleNum :int, winSize :list, scaleRate :float):
        """
        windows api 截图
        可以后台，可被遮挡，但是不能点击最小化
        :param handleNum:
        :param winSize: 第一个参数是宽度width
        :param scaleRate:
        :return:
        """
        widthScreen = int(winSize[0] / scaleRate)
        heightScreen = int(winSize[1] / scaleRate)
        # 返回句柄窗口的设备环境，覆盖整个窗口，包括非客户区，标题栏，菜单，边框
        hwndDc = GetWindowDC(handleNum)
        # 创建设备描述表
        mfcDc = CreateDCFromHandle(hwndDc)
        # 创建内存设备描述表
        saveDc = mfcDc.CreateCompatibleDC()
        # 创建位图对象准备保存图片
        saveBitMap = CreateBitmap()
        # 为bitmap开辟存储空间
        saveBitMap.CreateCompatibleBitmap(mfcDc, widthScreen, heightScreen)
        # 将截图保存到saveBitMap中
        saveDc.SelectObject(saveBitMap)
        # 保存bitmap到内存设备描述表
        saveDc.BitBlt((0, 0), (widthScreen, heightScreen), mfcDc, (0, 0), SRCCOPY)

        # 保存图像
        signedIntsArray = saveBitMap.GetBitmapBits(True)
        imgSrceen = frombuffer(signedIntsArray, dtype='uint8')
        imgSrceen.shape = (heightScreen, widthScreen, 4)
        imgSrceen = cv2.cvtColor(imgSrceen, cv2.COLOR_BGRA2GRAY)
        imgSrceen = cv2.resize(imgSrceen, (winSize[0], winSize[1]))

        # 测试显示截图图片
        # cv2.namedWindow('imgSrceen')  # 命名窗口
        # cv2.imshow("imgSrceen", imgSrceen)  # 显示
        # cv2.waitKey(0)
        # cv2.destroyAllWindows()

        # 内存释放
        DeleteObject(saveBitMap.GetHandle())
        saveDc.DeleteDC()
        mfcDc.DeleteDC()
        return imgSrceen

    @classmethod
    def getScreenPIL(cls, handleNum :int):
        """
        PIL截图方法，不能被遮挡
        :param handleNum:
        :return:
        """
        shell = Dispatch("WScript.Shell")
        shell.SendKeys('%')
        SetForegroundWindow(handleNum)  # 窗口置顶
        QThread.sleep(0.2)  # 置顶后等0.2秒再截图
        x1, y1, x2, y2 = GetWindowRect(handleNum)  # 获取窗口坐标
        grabImage = ImageGrab.grab((x1, y1, x2, y2))  # 用PIL方法截图
        imgScreen = array(grabImage)  # 转换为cv2的矩阵格式
        imgScreen = cv2.cvtColor(imgScreen, cv2.COLOR_BGRA2GRAY)

        # cv2.namedWindow('imgSrceen')  # 命名窗口
        # cv2.imshow("imgSrceen", imgScreen)  # 显示
        # cv2.waitKey(0)
        # cv2.destroyAllWindows()

        return imgScreen

    @classmethod
    def click(cls, handleNum :int) -> None:
        pass

    @classmethod
    def clickPIL(cls, handleNum :int, pos :list) -> None:
        x1, y1, x2, y2 = GetWindowRect(handleNum)
        # 把窗口置顶，并进行点击
        shell = Dispatch("WScript.Shell")
        shell.SendKeys('%')
        SetForegroundWindow(handleNum)
        QThread.sleep(0.2)  # 置顶后等0.2秒再点击
        presentPos = position()  # 记录当前的坐标
        moveTo(x1+pos[0], x2+pos[1])
        click(x1 + pos[0], x2 + pos[1])
        moveTo(presentPos[0], presentPos[1])
        return None

# print(Handle.getHandleNum('雷电模拟器'))
# print(Handle.getHandleNum('MuMu模拟器'))
# print(Handle.getHandPid(Handle.getHandleNum("雷电模拟器")))
# print(Handle.getSize(Handle.getHandleNum("雷电模拟器")))
# Handle.getScreen(Handle.getHandleNum("雷电模拟器"), [608, 370], 1.25)
# Handle.getScreenPIL(Handle.getHandleNum("雷电模拟器"))

