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
            id: hour
            model: 24
        }
        UTumbler{
            id: minute
            model: 60
        }
    }
    function getHour(){
        return  hour.currentIndex
    }
    function getMinute(){
        return minute.currentIndex
    }
    function setTime(h, m){ //显示的时候设置一下
        hour.positionViewAtIndex(Number(h), Tumbler.Center)
        minute.positionViewAtIndex(Number(m), Tumbler.Center)
    }
}
