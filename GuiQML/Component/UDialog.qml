import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
//import QtQuick.Dialogs 1.2

/*
    对话框控件
*/
Dialog{
    id:controlRoot

    //header样式
    property bool   headerVisible:true
    property int    headerHeight:42
    property color  headerBgColor:"white"
    property color  headerTextColor:"black"
    property int    headerTextSize:21
    property string headerTextFamily:"微软雅黑"
    property bool   headerSeparatorVisible:true
    property color  headerSeparatorColor: "#BDBEBF"
    property int    headerSeparatorHeight:1

    //footer样式
    property bool   footerVisible:true
    property int    footerHeight:54
    property color  footerBgColor:"white"
    property bool   footerSeparatorVisible:true
    property color  footerSeparatorColor: "#BDBEBF"
    property int    footerSeparatorHeight:1
    property int    footerButtonTextSize:18
    property bool   footerButtonBorderVisible:true
    property var    footerButtonModel:[
        {"label":"取消","labelColor":"black","bgColor":"#f0f0f0","visible":true},
        {"label":"确定","labelColor":"white","bgColor":"#2E9FEF","visible":true},
    ]

    //背景样式
    property color  maskColor:Qt.rgba(0,0,0,0.8)     //遮罩颜色
    property color  bgColor:"white"                  //背景颜色
    property color  bgBorderColor:"transparent"      //边框线颜色
    property int    bgBorderWidth:0                  //边框线宽度
    property int    bgBorderRadius:10                //边框线宽度

    //信号
    signal closing(var close)               //点击关闭按钮时触发，设置close.accepted=false可以阻止关闭
    signal footerButtonClicked(var label)   //点击footer中的按钮时触发，label为该按钮的文本

    //内部数据
    signal  __closeRequest()
    property var    __closeState:{
        "accepted":true
    }

    on__CloseRequest: {
        if(__closeState === undefined
                || __closeState.accepted === undefined
                || __closeState.accepted)
        {
             controlRoot.close()
        }
    }

    anchors.centerIn: Overlay.overlay   //相对顶层窗口居中显示
    modal: true
    closePolicy: Dialog.NoAutoClose
    clip:true
    padding: bgBorderWidth

    header:Control{
        visible: headerVisible
        implicitWidth: 200
        implicitHeight: headerHeight
        leftPadding:bgBorderWidth
        rightPadding:bgBorderWidth
        topPadding:bgBorderWidth

        contentItem: Rectangle{
            color: headerBgColor
            radius:bgBorderRadius-bgBorderWidth-1.5  //1.5是像素偏差

            Rectangle{
                anchors.bottom: parent.bottom
                width: parent.width
                height: bgBorderRadius
                color: headerBgColor
            }

            Rectangle{
                anchors.bottom: parent.bottom
                width: parent.width
                height: headerSeparatorHeight
                color: headerSeparatorColor
                visible: headerSeparatorVisible
            }

            Text{
                leftPadding: 10
                height: parent.height
                width: parent.width - closeText.width
                text:controlRoot.title
                font.pixelSize: headerTextSize
                font.family: headerTextFamily
                verticalAlignment: Text.AlignVCenter
            }

            Text{
                id:closeText
                rightPadding: 10
                height: parent.height
                text:"×"
                color: headerTextColor
                font.pixelSize: headerTextSize+5
                renderType: Text.NativeRendering
                verticalAlignment: Text.AlignVCenter
                anchors.right: parent.right

                MouseArea{
                    hoverEnabled: true
                    anchors.fill: parent
                    onEntered: {
                        closeText.color =Qt.rgba(headerTextColor.r,headerTextColor.g,headerTextColor.b,0.5)
                    }
                    onExited: {
                        closeText.color = headerTextColor
                    }
                    onClicked: {
                        __closeState.accepted = true
                        closing(__closeState)
                        __closeRequest()
                    }
                }
            }
        }
    }

    footer:Control{
        visible: footerVisible
        implicitWidth: 200
        implicitHeight: footerHeight
        topPadding: bgBorderWidth
        leftPadding:bgBorderWidth
        rightPadding:bgBorderWidth
        bottomPadding:bgBorderWidth

        contentItem: Rectangle{
            color: footerBgColor
            radius: bgBorderRadius-bgBorderWidth-1.5

            Rectangle{
                anchors.top: parent.top
                width: parent.width
                height: bgBorderRadius
                color: headerBgColor
            }

            Rectangle{
                anchors.top: parent.top
                width: parent.width
                height: footerSeparatorHeight
                color: footerSeparatorColor
                visible: footerSeparatorVisible
            }

            RowLayout{
                id:buttonLayout
                layoutDirection:Qt.RightToLeft
                width: parent.width-bgBorderRadius*2-10
                height: footerHeight*0.7
                spacing:bgBorderRadius+5
                anchors.centerIn: parent

                Repeater{
                    model:footerButtonModel
                    Button{
                        id:footerButton
                        visible: modelData.visible
                        text: modelData.label
                        leftPadding: 20
                        rightPadding: 20
                        font.pixelSize: footerButtonTextSize
                        font.family: headerTextFamily
                        palette.buttonText:modelData.labelColor
                        background: Rectangle{
                            radius: 5
                            color:footerButton.hovered? Qt.lighter(modelData.bgColor,1.2):modelData.bgColor
                            border.color: Qt.darker(modelData.bgColor,1.25)
                            border.width: footerButtonBorderVisible?1:0
                        }
                        onPressed: opacity=0.5
                        onReleased: opacity=1
                        onClicked: {
                            footerButtonClicked(footerButton.text)
                        }
                    }
                }

                Item{
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }
            }
        }
    }

    background: Rectangle{
        id:bgRect
        color:bgColor
        border.color: bgBorderColor
        border.width: bgBorderWidth
        radius: bgBorderRadius
    }

    Overlay.modal: Rectangle{
       color:maskColor
    }

    onAboutToShow: {
        bgRect.border.width = Qt.binding(function(){
            return bgBorderWidth
        })
    }

    onAboutToHide: {
        bgRect.border.width = 0
    }
}
