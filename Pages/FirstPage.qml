import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../Objects"

//-----------------------------------------------------------------//
//                           Главное меню                          //
//-----------------------------------------------------------------//

Page {

    id: pageMainMenu

    signal sigStart();
    signal sigHighScore();
    signal sigExit();

    // Задний фон
    Rectangle {
        anchors.fill: parent
        gradient: "CloudyApple"

        // Сцена с целями
        Repeater {
            id: repeaterFigures

            // Расстояния между делегатами
            model: [0, 50, -50, 100, -100, 150, -150, 200, -200]

            // Объект падающей цели
            AimCircle {
                id: delegateItem

                width: parent.width / 8.0
                height: parent.width / 8.0
                x: Math.random() * (pageMainMenu.width - width)

                // Анимация падения
                NumberAnimation on y {
                    from: Math.random() * (-200) - 200
                    to: pageMainMenu.height + 200 + modelData
                    easing.type: Easing.InSine
                    duration: 3000
                    loops: Animation.Infinite
                }
            }
        }

        // Область кнопок
        Column {
            anchors.centerIn: parent
            spacing: 20

            // Кнопка "Пуск"
            Button {
                id: buttonStart

                text: qsTr("Пуск")
                width: pageMainMenu.width / 1.3
                height: pageMainMenu.height / 9.0

                onClicked: {
                    sigStart();
                }
            }

            // Кнопка "Рекорды"
            Button {
                id: buttonHighScore

                text: qsTr("Рекорды")
                width: pageMainMenu.width / 1.3
                height: pageMainMenu.height / 9.0

                onClicked: {
                    sigHighScore();
                }
            }

            // Кнопка "Выход"
            Button {
                id: buttonExit

                 text: qsTr("Выход")
                 width: pageMainMenu.width / 1.3
                 height: pageMainMenu.height / 9.0

                onClicked: {
                    sigExit();
                }
            }
        }

        // Заголовок с названием
        StyleText {
            id: textHeader

            borderColor: "gray"
            textString: qsTr("CATCHER")
            fontSize: pageMainMenu.width / 7.0

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: pageMainMenu.height / 5.9
        }
    }
}
