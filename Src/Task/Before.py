# This Python file uses the following encoding: utf-8
# @author runhey
# github https://github.com/runhey

from Src.Task.Event import ImgEvent
from Src.Task.Action import ClickAction

class Before:
    """
    解决协作或者连接超时断线等待新情况
    """
    def __init__(self, device, size :list) -> None:
        """

        :param device: 注入设备句柄
        :param size:  设备大小
        """
        infoAccept :dict = {"eventName": "accept", "imgName": "accept.jpg", "x0": "0.63", "y0": "0.55", "width": "0.08", "height": "0.14"}
        infoReject :dict = {"eventName": "reject", "imgName": "reject.jpg", "x0": "0.63", "y0": "0.70", "width": "0.08", "height": "0.14"}
        infoAction :dict = {"actionName": "imgClick", "limits": "20.00", "moveX": "0.00", "moveY": "0.00"}
        self.imgEventAccept = ImgEvent("DefaultGroup","Before","matchTemplate",
                                       0.81, 0.85, infoAccept)
        self.imgEventReject = ImgEvent("DefaultGroup", "Before", "matchTemplate",
                                       0.81, 0.85, infoReject)
        self.clickActionS = ClickAction(size, infoAction, device)
        self.imgEventAccept.sigEvent.connect(self.clickActionS.deal)
        self.imgEventReject.sigEvent.connect(self.clickActionS.deal)

    def deal(self, scrImg) -> None:
        self.imgEventAccept.deal(scrImg)