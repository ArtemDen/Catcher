import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

//-----------------------------------------------------------------//
//                            Класс цели                           //
//-----------------------------------------------------------------//

Item {

    id: objCircle

    // Порядковый номер в массиве
    property int iNumber: 0

    // Начальная и конечная координата Y
    property double dStartY: 0
    property double dAimY: 0

    // Переменные движения
    property alias move: animMove
    property alias time: animMove.duration

    // Массивы анимаций и градиентов
    property var arrEasingTypes: ["Linear", "OutInQuad", "InSine", "OutQuad", "InCubic", "InOutQuad", "OutInQuad", "InCubic", "InCirc", "OutInBack"];
    property var arrGradients: ["GrassShampoo", "AngelCare", "SaltMountain", "MorningSalad", "SandStrike", "ForestInei", "GentleCare", "MagicLake", "CheerfulCaramel", "MarbleWall"]

    // Переменные работы с массивами
    property int iEasingLength: 1
    property int iRandGradNumber: Math.round(Math.random() * (arrGradients.length - 1))
    property int iRandEasNumber: Math.round(Math.random() * (iEasingLength - 1))

    signal sigLose()

    // Форма цели
    Rectangle {
        id: circle
        width: parent.width
        height: parent.height
        gradient: arrGradients[iRandGradNumber]
        radius: width * 1.5

        // Эффект тени
        layer.enabled: true
        layer.effect: DropShadow {
            anchors.fill: circle
            horizontalOffset: circle.radius / 19.0
            verticalOffset: circle.radius / 17.0
            radius: 8
            color: "gray"
            source: circle
            transparentBorder: true
        }
        
        // Анимация падения
        NumberAnimation {
            id: animMove
            target: objCircle
            properties: "y"
            from: dStartY
            to: dAimY
            easing.type: arrEasingTypes[iRandEasNumber]
            duration: 3600 + 700 * Math.random();

            // Удаление объекта ввиду попадния или достижения конечной точки
            onStopped: {
                if(objCircle.visible) {
                   sigLose();
                }
                objCircle.destroy();
            }
        }
    }
}
