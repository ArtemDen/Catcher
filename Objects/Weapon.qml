import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

//-----------------------------------------------------------------//
//                           Класс орудия                          //
//-----------------------------------------------------------------//

Item {

    id: objWeapon

    width: 50
    height: 50
    
    // Порядковый номер
    property int iNumber: 0

    // Конечные координаты
    property double dTargetX: 0.
    property double dTargetY: 0.

    // Параметры движения
    property double velocity: 0.5
    property double time: Math.sqrt(Math.pow(x - dTargetX, 2) + Math.pow(y - dTargetY, 2)) / velocity

    // Параметры анимации
    property alias moveX: animMoveX
    property alias moveY: animMoveY

    // Изображение орудия
    Image {
        id: imgWeapon
        anchors.fill: parent
        source: "../img/weapon.png"

        // Эффект тени
        layer.enabled: true
        layer.effect: DropShadow {
            anchors.fill: imgWeapon
            horizontalOffset: 0
            verticalOffset: 0
            radius: 5
            spread: 0
            color: "gray"
            source: imgWeapon
            }
    }
    
    // Анимация поворта
    RotationAnimation on rotation {
        id: animRotation
        target: objWeapon
        from: 0
        to: 180
        direction: RotationAnimation.Counterclockwise
        duration: 750
        loops: Animation.Infinite
    }
    
    // Анимация перемещения по X
    NumberAnimation {
        id: animMoveX
        target: objWeapon
        properties: "x"
        duration: time
        to: objWeapon.dTargetX

        onStopped: {
            objWeapon.visible = false;
            objWeapon.destroy();
        }
    }
    
    // Анимация перемещения по Y
    NumberAnimation {
        id: animMoveY
        target: objWeapon
        easing.type: Easing.OutCubic
        properties: "y"
        duration: time * 2
        to: objWeapon.dTargetY
    }
}
