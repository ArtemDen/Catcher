import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../Objects"

//-----------------------------------------------------------------//
//                         Страница рекордов                       //
//-----------------------------------------------------------------//

Page {

    id: pageHighScore

    signal sigBack();

    // Задний фон
    Rectangle {
        anchors.fill: parent
        gradient: "CloudyApple"

        // Сцена с орудиями
        Repeater {
            id: repeaterWeapons

            // Расстояния между делегатами
            model: [0, 50, -50, 100, -100, 150, -150, 200, -200]

            // Объект орудия
            Weapon {
                id: delegateItem
                width: pageHighScore.width / 10.0
                height: pageHighScore.width / 10.0
                x: Math.random() * (pageHighScore.width - width)

                NumberAnimation on y {
                    from: pageHighScore.height + 200 + modelData
                    to: Math.random() * (-200) - height
                    easing.type: Easing.OutSine
                    duration: 3000
                    loops: Animation.Infinite
                }
            }
        }

        // Область отображения рекордов
        Rectangle {
            id: rectHighScore
            anchors.centerIn: parent
            height: parent.height / 1.8
            width: parent.width / 1.1
            gradient: "SnowAgain"
            radius: 50

            // Эффект тени
            layer.enabled: true
            layer.effect: DropShadow {
                anchors.fill: rectHighScore
                horizontalOffset: rectHighScore.radius / 19.0
                verticalOffset: rectHighScore.radius / 17.0
                radius: 8
                color: "gray"
                source: rectHighScore
                transparentBorder: true
            }

            // Данные о рекордах
            TableView {
                id: listView

                anchors.left: parent.left
                anchors.leftMargin: anchors.topMargin
                anchors.top: parent.top
                anchors.topMargin: parent.width / 28. + 15.

                width: parent.width
                height: parent.height / 1.4
                contentWidth: width
                //contentHeight: height

                rowSpacing: parent.width / 15.

                model: HighScoreModel

                // Делегат
                delegate: Rectangle {
                    id: rectDelegate

                    implicitWidth: parent.width / 2.45
                    implicitHeight: parent.height / 15.

                    color: "transparent"

                    // Шрифт
                    FontLoader {
                        id: fontCustom
                        source: "../fonts/comic.ttf"
                    }

                    // Данные
                    Text {
                        id: textDate
                        anchors.fill: parent
                        text: model.column - 1 ? (model.row + 1) + ") " + display : display
                        horizontalAlignment: model.column - 1 ? Text.AlignLeft : Text.AlignRight
                        color: "black"
                        opacity: 0.7
                        font.pointSize: parent.width / 10.
                        font.family: fontCustom.name
                        font.bold: model.column - 1 ? false : true

                        layer.effect: Glow {
                            anchors.fill: textDate
                            radius: 8
                            color: "gray"
                            source: textDate
                        }
                    }
                }
            }

            // Кнопка возврата в главное меню
            Button {
                id: buttonBack

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.leftMargin: 10
                anchors.bottomMargin: 20

                width: pageHighScore.width / 4.0
                height: pageHighScore.height / 14.0
                fontSize: width / 5.0

                text: qsTr("В меню")

                onClicked: {
                    sigBack();
                    listView.positionViewAtRow(0, Qt.AlignTop);
                }
            }
        }
    }
}
