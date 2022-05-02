import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
import Qt5Compat.GraphicalEffects

//-----------------------------------------------------------------//
//                     Класс прозрачной кнопки                     //
//-----------------------------------------------------------------//

Rectangle {

    id: button

    property alias text: textButton.text
    property alias fontSize: textButton.font.pointSize

    width: 300
    height: 50
    radius: 50
    color: "transparent"

    signal clicked()

    // Звук нажатия
    MediaPlayer {
        id: soundPush
        source: "qrc:/sound/Push.wav"
        audioOutput: AudioOutput {}
    }

    // Эффект тени
    layer.enabled: true
    layer.effect: DropShadow {
        anchors.fill: button
        horizontalOffset: mouse.containsPress ? button.height / 40.0 : button.height / 18.0
        verticalOffset: mouse.containsPress ? button.height / 38.0 : button.height / 16.0
        radius: 8
        color: "gray"
        source: button
        transparentBorder: true
    }

    // Шрифт
    FontLoader {
        id: fontCustom
        source: "../fonts/comic.ttf"
    }

    // Текст кнопки
    Text {
        id: textButton
        anchors.centerIn: parent
        font.family: fontCustom.name
        font.pointSize: parent.width / 10.0
        font.bold: true
        text: qsTr("text")
        color: "black"
        opacity: 0.7
    }
    
    // Реакция на нажатие
    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: {
            button.clicked();
        }
    }

    onClicked: {
        soundPush.play();
    }
}
