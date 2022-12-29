import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtQml 2.12
import Qt5Compat.GraphicalEffects

import "./Pane"


Window {
    id:rootWindow
    width: 1440+8
    height: 900+8 // +8是因为外阴影一边用了4
    minimumWidth: 300
    minimumHeight: 300
    visible: true
    color: '#00000000'
    flags:   Qt.FramelessWindowHint | Qt.WindowSystemMenuHint | Qt.WindowMinimizeButtonHint| Qt.Window
    //主界面
    Rectangle{
        id:windowMain
        anchors.fill: parent
        // 当窗口全屏时，设置边距为 0，则不显示阴影，窗口化时设置边距为 6 就可以看到阴影了
        anchors.margins: rootWindow.visibility === Window.Maximized ? 0 : 4
        //color: "#663399"
        //菜单
        MenuPane{
            id:menuPane
            anchors{
                top: parent.top
            }
        }

        //标题栏
        Item {
            height: 30
            anchors{
                left: menuPane.right
                right: parent.right
                top: parent.top
            }

            //拖动栏
            Item {
                anchors.fill: parent
                TapHandler {
                    onTapped: if (tapCount === 2) toggleMaximized()
                    gesturePolicy: TapHandler.DragThreshold
                }
                DragHandler {
                    grabPermissions: TapHandler.CanTakeOverFromAnything
                    onActiveChanged: if (active) { rootWindow.startSystemMove(); }
                }
            }
            Row{
                anchors{
                    right: parent.right
                    rightMargin: 8
                    verticalCenter: parent.verticalCenter
                }
                spacing: 16
                Button{  //帮助hlep github
                    width: 24
                    height: 24
                    flat:true
                    highlighted: true
                    background: Rectangle{
                        anchors.fill: parent
                        radius: 4
                        color: "transparent"
                    }
                    icon.source: "../GuiImage/window/help.png"
                    icon.color: "transparent"
                    icon.width: parent.width
                    icon.height: parent.height
                    onClicked: { Qt.openUrlExternally("http://baidu.com") }
                }
                Button{  //最小到任务栏
                    width: 24
                    height: 24
                    background: Rectangle{
                        anchors.fill: parent
                        color: "transparent"
                    }
                    icon.source: "../GuiImage/window/window-minimize.png"
                    icon.color: "transparent"
                    icon.width: parent.width
                    icon.height: parent.height
                    onClicked: { rootWindow.showMinimized() }
                }
                Button{  //最大化最小化
                    width: 24
                    height: 24
                    background: Rectangle{
                        anchors.fill: parent
                        color: "transparent"
                    }
                    icon.source: (rootWindow.visibility === Window.Maximized ) ?"../GuiImage/window/window-restore.png" : "../GuiImage/window/window-maximize.png"
                    icon.color: "transparent"
                    icon.width: parent.width
                    icon.height: parent.height
                    onClicked: {
                        if(rootWindow.visibility === Window.Maximized ) {
                            rootWindow.showNormal();
                        }
                        else{
                            rootWindow.showMaximized()
                        }
                        }
                }
                Button{  //关闭软件
                    width: 24
                    height: 24
                    background: Rectangle{
                        anchors.fill: parent
                        color: "transparent"
                    }
                    icon.source: "../GuiImage/window/window-close.png"
                    icon.color: "transparent"
                    icon.width: parent.width
                    icon.height: parent.height
                    onClicked: { rootWindow.close() }
                }

            }
        }
    }
    //外阴影
    DropShadow{
        anchors.fill: windowMain
        horizontalOffset: 1
        verticalOffset: 1
        radius: 8
        samples: 16
        source: windowMain
        color: "#1abc9c"
        Behavior on radius { PropertyAnimation { duration: 100 } }
    }
    //改变鼠标形状
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: {
            if (rootWindow.visibility !== Window.Maximized){
            const p = Qt.point(mouseX, mouseY);
            const b = 4; // Increase the corner size slightly
            if (p.x < b && p.y < b) return Qt.SizeFDiagCursor;
            if (p.x >= width - b && p.y >= height - b) return Qt.SizeFDiagCursor;
            if (p.x >= width - b && p.y < b) return Qt.SizeBDiagCursor;
            if (p.x < b && p.y >= height - b) return Qt.SizeBDiagCursor;
            if (p.x < b || p.x >= width - b) return Qt.SizeHorCursor;
            if (p.y < b || p.y >= height - b) return Qt.SizeVerCursor;
            }
        }
        acceptedButtons: Qt.NoButton // don't handle actual events
    }
    //边界跟随拖动
    DragHandler {
        id: resizeHandler
        grabPermissions: TapHandler.TakeOverForbidden
        target: null
        onActiveChanged: if (rootWindow.visibility !== Window.Maximized) {
                             if (active) {
                             const p = resizeHandler.centroid.position;
                             const b =  20; // Increase the corner size slightly
                             let e = 0;
                             if (p.x <= b) { e |= Qt.LeftEdge }
                             if (p.x >= width - b) { e |= Qt.RightEdge }
                             if (p.y <= b) { e |= Qt.TopEdge }
                             if (p.y >= height - b) { e |= Qt.BottomEdge }
                             if(e != 0) {rootWindow.startSystemResize(e);}
                             }
                         }
    }
    // 最大最小
    function toggleMaximized() {
        if (rootWindow.visibility === Window.Maximized) {
            rootWindow.showNormal();
        } else {
            rootWindow.showMaximized();
        }
    }
}
