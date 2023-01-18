import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    implicitWidth: 400
    implicitHeight: 300
    Row{
        id:tabel
        anchors.top: parent.top
        anchors.topMargin: 12
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 80
        Text {
            height: 30
            font.pixelSize: 18
            color: "blue"
            text: "星期"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        Text {
            height: 30
            font.pixelSize: 18
            color: "blue"
            text: "小时"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        Text {
            height: 30
            font.pixelSize: 18
            color: "blue"
            text: "分钟"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
    Row{
        anchors.top: tabel.bottom
        anchors.topMargin: 8
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 10
        UTumbler{
            id: week
            model: ["周一", "周二", "周三", "周四", "周五", "周六", "周日",]
        }
        UTumbler{
            id: hour
            model: 24
        }
        UTumbler{
            id: minute
            model: 60
        }
    }
    function getWeek(){
        var index = week.currentIndex
        return week.model[index]
    }
    function getHour(){
        return  hour.currentIndex
    }
    function getMinute(){
        return minute.currentIndex
    }
    function setTime(w, h, m){ //显示的时候设置一下
        switch(w){
        case "周一":
            week.positionViewAtIndex(0, Tumbler.Center)
            break
        case "周二":
            week.positionViewAtIndex(1, Tumbler.Center)
            break
        case "周三":
            week.positionViewAtIndex(2, Tumbler.Center)
            break
        case "周四":
            week.positionViewAtIndex(3, Tumbler.Center)
            break
        case "周五":
            week.positionViewAtIndex(4, Tumbler.Center)
            break
        case "周六":
            week.positionViewAtIndex(5, Tumbler.Center)
            break
        case "周日":
            week.positionViewAtIndex(6, Tumbler.Center)
            break
        }
        hour.positionViewAtIndex(Number(h), Tumbler.Center)
        minute.positionViewAtIndex(Number(m), Tumbler.Center)
    }
}
