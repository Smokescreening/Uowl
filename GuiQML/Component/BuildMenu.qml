import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item{
    Label{
        id: stName
        anchors.top: parent.top
        width:parent.width
        text: "statename"
        color: "#ffffff"
        font.bold: true
        font.pixelSize: 24
    }
    RowLayout{
        id: rowLayout
        width: parent.width
        anchors.top: stName.bottom
        anchors.topMargin: 8
        implicitHeight: 30
        spacing: 0
        Image{
            Layout.preferredHeight: 22
            Layout.preferredWidth: 22
            Layout.alignment: Qt.AlignVCenter//|Qt.AlignLeft
            source: "../../GuiImage/pullmenu/gear.png"
        }
        Label{
            Layout.alignment: Qt.AlignVCenter|Qt.AlignLeft
            text: "BaseConfig"
            color: "#ffffff"
            font.bold: true
            font.pixelSize: 18
        }
        Image{
            Layout.preferredHeight: 20
            Layout.preferredWidth: 20
            Layout.alignment: Qt.AlignVCenter|Qt.AlignRight
            source: "../../GuiImage/pullmenu/chevron_down.png"

        }
    }
    PullMenu{
        width: parent.width
        anchors.top: rowLayout.bottom
        anchors.topMargin: 8
        anchors.bottom: parent.bottom

    }
}
