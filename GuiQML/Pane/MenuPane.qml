import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
    id:menuPane
    width: 48
    clip: true
    property int menuPaneFlag: 1   //菜单选中第几个 0表示设置 其他依次按顺序

    Rectangle {
        id: rectangle
        anchors.fill: parent
        color: "#80ffffff"
        border.color: "#ccffffff"
        border.width: 3
        radius: 8
        clip: true

    }
    ColumnLayout{
        width: parent.width
        anchors{
            top: parent.top
            topMargin: 12
        }
        spacing: 18
        Button{
            Layout.preferredWidth: 36
            Layout.preferredHeight: 36
            Layout.alignment: Qt.AlignHCenter
            background: Rectangle{
                anchors.fill: parent
                radius: 4
                color: (menuPane.menuPaneFlag == 1) ? "#99663399":"transparent"
            }
            icon.source: (menuPane.menuPaneFlag == 1) ?"../../GuiImage/window/Menu_Magic_Purple.png":"../../GuiImage/window/Menu_Magic_Yellow.png"
            icon.color: "transparent"
            icon.width: parent.width
            icon.height: parent.height
            MouseArea{
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: { menuPane.menuPaneFlag = 1 }
            }
        }
        Button{
            Layout.preferredWidth: 36
            Layout.preferredHeight: 36
            Layout.alignment: Qt.AlignHCenter
            background: Rectangle{
                anchors.fill: parent
                radius: 4
                color: (menuPane.menuPaneFlag == 2) ? "#99663399":"transparent"
            }
            icon.source: (menuPane.menuPaneFlag == 2) ?"../../GuiImage/window/Menu_Compasses_Purple.png":"../../GuiImage/window/Menu_Compasses_Yellow.png"
            icon.color: "transparent"
            icon.width: parent.width
            icon.height: parent.height
            MouseArea{
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: { menuPane.menuPaneFlag = 2 }
            }
        }
        Button{
            Layout.preferredWidth: 36
            Layout.preferredHeight: 36
            Layout.alignment: Qt.AlignHCenter
            background: Rectangle{
                anchors.fill: parent
                radius: 4
                color: (menuPane.menuPaneFlag == 3) ? "#99663399":"transparent"
            }
            icon.source: (menuPane.menuPaneFlag == 3) ?"../../GuiImage/window/Menu_Collage_Purple.png":"../../GuiImage/window/Menu_Collage_Yellow.png"
            icon.color: "transparent"
            icon.width: parent.width
            icon.height: parent.height
            MouseArea{
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: { menuPane.menuPaneFlag = 3 }
            }

        }
        Button{
            Layout.preferredWidth: 36
            Layout.preferredHeight: 36
            Layout.alignment: Qt.AlignHCenter
            background: Rectangle{
                anchors.fill: parent
                radius: 4
                color: (menuPane.menuPaneFlag == 4) ? "#99663399":"transparent"
            }
            icon.source: (menuPane.menuPaneFlag == 4) ?"../../GuiImage/window/Menu_Hammer_Purple.png":"../../GuiImage/window/Menu_Hammer_Yellow.png"
            icon.color: "transparent"
            icon.width: parent.width
            icon.height: parent.height
            MouseArea{
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: { menuPane.menuPaneFlag = 4 }
            }
        }
    }

    //设置
    Button{
        width: 36
        height: 36
        anchors{
            bottom: parent.bottom
            bottomMargin: 12
            horizontalCenter: parent.horizontalCenter
        }
        background: Rectangle{
            anchors.fill: parent
            radius: 4
            color: (menuPane.menuPaneFlag == 0) ? "#99663399":"transparent"
        }
        icon.source: (menuPane.menuPaneFlag == 0) ?"../../GuiImage/window/Menu_Setting_Purple.png":"../../GuiImage/window/Menu_Setting_Yellow.png"
        icon.color: "transparent"
        icon.width: parent.width
        icon.height: parent.height
        MouseArea{
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: { menuPane.menuPaneFlag = 0 }
        }
    }

    Behavior on width {
        NumberAnimation{
            duration: 400
        }
    }
    function menuOpen(){
        menuPane.visible = true
    }
    function menuClose(){
        menuPane.visible = false
    }
    function getVisable(){
        return menuPane.visible
    }

}
