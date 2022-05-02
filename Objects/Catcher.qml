import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../Objects"

//-----------------------------------------------------------------//
//                        Класс пуска орудий                       //
//-----------------------------------------------------------------//

Item {

    id: objCatcher

    width: 70
    height: 70

    // Число попаданий
    property int iHitCounter: 0

    // Цвет индикатора
    property alias indicatorColor: rectCounter.color

    // Видимость текста
    property alias textVisible: textCounter.visible

    // Изображение стрельбы
    function fireMode() {
        imgMainLayout.source = "../img/fire.png";
    }

    // Изображение в простое
    function silentMode() {
        imgMainLayout.source = "../img/catcher.png"
    }

    // Темный слой изображения
    Image {
        id: imgBlackLayout
        source: "../img/catcher.png"
        x: imgMainLayout.x - imgMainLayout.width * 0.15
        width: imgMainLayout.width * 1.3
        height: imgMainLayout.height

        // Эффект темного свечения
        layer.enabled: true
        layer.effect: Glow {
            anchors.fill: imgBlackLayout
            radius: 8
            spread: 0
            color: "black"
            source: imgBlackLayout
            transparentBorder: true
            }
        }
    
    // Главный слой изображения
    Image {
        id: imgMainLayout
        anchors.fill: parent
        source: "../img/catcher.png"

        // Эффект серого свечения
        layer.enabled: true
        layer.effect: Glow {
            anchors.fill: imgMainLayout
            radius: 8
            spread: 0
            color: "gray"
            source: imgMainLayout
            transparentBorder: true
            }
    }

    // Слой с градиентом
    Image {
        id: imgGradientLayout
        anchors.fill: parent
        source: "../img/catcher.png"

        // Градиент
        LinearGradient {
            id: gradient
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0; color: "yellow" }
                GradientStop { position: 1; color: "red" }
            }
            source: parent
        }
    }

    // Счетчик попаданий
    Item {
        id: itemCounter

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.width / 4.
        opacity: 0.75

        width: objCatcher.width / 3.25
        height: objCatcher.width / 3.25

        Rectangle {
            id: rectCounter
            anchors.fill: parent
            radius: objCatcher.width / 3.25

            color: "lightgreen"
            border.color: "black"
            border.width: 1
        }

        // Градиент
        LinearGradient {
            id: gradientCounter
            anchors.fill: rectCounter
            gradient: Gradient {
                GradientStop { position: 0; color: "white" }
                GradientStop { position: 1; color: "black" }
            }
            source: rectCounter

            opacity: 0.5

            // Эффект свечения
            layer.enabled: true
            layer.effect: Glow {
                anchors.fill: gradientCounter
                radius: 8
                spread: 0
                color: "black"
                source: gradientCounter
                transparentBorder: true
                }
        }

        Text {
            id: textCounter
            text: objCatcher.iHitCounter
            visible: false

            anchors.centerIn: rectCounter
            opacity: 0.56

            color: "black"
            font.pointSize: objCatcher.width / 10.
            font.bold: true
            font.family: "Helvetica"
        }
    }
}
