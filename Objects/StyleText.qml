import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../Objects"

//-----------------------------------------------------------------//
//                      Класс текста со стилем                     //
//-----------------------------------------------------------------//

Item {

    id: text
    
    property string borderColor: "gray"
    property string textString: "CATCHER"
    property real fontSize: 15

    // Шрифт
    FontLoader {
        id: fontCustom
        source: "../fonts/comic.ttf"
    }
    
    // Внешняя часть текста
    Text {
        id: textOutline
        anchors.centerIn: parent
        
        text: parent.textString
        font.pointSize: parent.fontSize
        font.bold: true
        font.family: fontCustom.name
        color: parent.borderColor

        horizontalAlignment: Text.AlignHCenter

        // Эффект серого свечения
        layer.enabled: true
        layer.effect: Glow {
            anchors.fill: textOutline
            radius: 5
            color: "gray"
            source: textOutline
            transparentBorder: true
            }

        style: Text.Raised
        styleColor: "black"
    }
    
    // Часть текста с градиентом
    Text {
        id: textGradient
        anchors.centerIn: parent

        horizontalAlignment: Text.AlignHCenter
        
        text: parent.textString
        font.pointSize: parent.fontSize
        font.bold: true
        font.family: fontCustom.name
        color: parent.borderColor

        // Градиент
        LinearGradient {
            anchors.fill: textGradient
            gradient: Gradient {
                GradientStop { position: 0; color: "#ebbba7" }
                GradientStop { position: 1; color: "#cfc7f8" }
            }
            source: textGradient
        }
    }
}
