import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
import Qt5Compat.GraphicalEffects
import "../Objects"

//-----------------------------------------------------------------//
//                         Игровая страница                        //
//-----------------------------------------------------------------//

Page {

    id: pageGame

    // Массивы объектов на сцене
    property variant arrCircles: []
    property variant arrWeapons: []

    // Логические переменные
    property bool bGameIsOver: false
    property bool bShootingIsPermitted: true

    // Количество используемых анимаций падения
    property int iEasingLength: 1

    // Назад в меню и перезапуск сессии
    signal sigBack();
    signal sigRestart();

    // Отправка данных о результатах
    signal sigResult(var value);

    // Обнаружение пересечения орудия и цели
    function checkingCross(number) {
        for (var iNum = 0; iNum < arrWeapons.length; iNum++) {
            if (arrCircles[number].visible) {

                // Разности координат
                var dDiffX = Math.abs(arrCircles[number].x - arrWeapons[iNum].x);
                var dDiffY = Math.abs(arrCircles[number].y - arrWeapons[iNum].y);

                // Коэффициент учета неквадратной формы орудия
                var dCrossCoeff = 1.325;

                if(dDiffX < arrCircles[number].width / dCrossCoeff) {
                    if (dDiffY < arrCircles[number].height / dCrossCoeff) {
                        arrCircles[number].visible = false;

                        if (!bGameIsOver) {                    
                            if (soundSmash.playbackState == MediaPlayer.PlayingState) {
                                soundSmash.stop();
                            }
                            soundSmash.play();

                            catcher.iHitCounter += 1;
                            // Повышение количества возможных анимаций падения
                            if (catcher.iHitCounter % 10 == 0 && iEasingLength <= 10) {
                                iEasingLength += 1;
                            }
                        }
                    }
                }
            }
        }
     }

    // Конец игры
    function lost() {
        if (!bGameIsOver) {

            bGameIsOver = true;
            buttonBack.visible = true;
            buttonRestart.visible = true;
            textGameOver.visible = true;

            soundLose.play();
            sigResult(catcher.iHitCounter);
        }
    }

    // Задний фон
    Rectangle {
        anchors.fill: parent
        gradient: "CloudyApple"
    }

    // Период расчета пересечений
    Timer {
        id: timerCross
        interval: 20
        running: true
        repeat: true
        onTriggered: {
            for (var iNum = 0; iNum < arrCircles.length; iNum++) {
                checkingCross(iNum);
            }
        }
    }

    // Период запрета стрельбы
    Timer {
        id: timerShooting
        interval: timerCircles.interval / 3
        running: false
        repeat: false
        onTriggered: {
            bShootingIsPermitted = true;
            catcher.indicatorColor = "lightgreen";
        }
    }

    // Период падения целей (переменный)
    Timer {
        id: timerCircles
        interval: 1200
        running: true
        repeat: true

        // Создание объектов целей
        onTriggered: {
            var componentCircle = Qt.createComponent("../Objects/AimCircle.qml");
            if((componentCircle.status === Component.Ready) && !bGameIsOver) {

                var objCircle = componentCircle.createObject(pageGame);
                objCircle.width = pageGame.width / 8.0;
                objCircle.height = pageGame.width / 8.0;
                objCircle.x = Math.random() * (pageGame.width - objCircle.width);

                objCircle.dStartY = -4 * objCircle.height;
                objCircle.dAimY = pageGame.height + objCircle.height;

                objCircle.iEasingLength = iEasingLength;

                objCircle.move.start();
                objCircle.iNumber = arrCircles.length;
                arrCircles.push(objCircle);

                objCircle.sigLose.connect(lost);

                if (timerCircles.interval > 100) {
                    timerCircles.interval -= 10;
                }
            }
        }
    }

    // Звуки
    MediaPlayer {
        id: soundLaunch
        source: "qrc:/sound/Launch.wav"
        audioOutput: AudioOutput {}
    }
    MediaPlayer {
        id: soundSmash
        source: "qrc:/sound/Smash.wav"
        audioOutput: AudioOutput {}
    }
    MediaPlayer {
        id: soundLose
        source: "qrc:/sound/Lose.wav"
        audioOutput: AudioOutput {}
    }

    // Объект "пускания" целей
    Catcher {
        id: catcher
        width: pageGame.width / 5.25
        height: pageGame.width / 5.25
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        textVisible: true
    }

    // Область мыши (По щелчку пуск орудий)
    MouseArea {
        id: mouse
        anchors.fill: parent

        // Создание объектов орудий
        onPressed: {
            var componentWeapon = Qt.createComponent("../Objects/Weapon.qml");
            if((componentWeapon.status === Component.Ready) && !bGameIsOver && bShootingIsPermitted) {
                var objWeapon = componentWeapon.createObject(pageGame);

                catcher.fireMode();

                objWeapon.x = catcher.x;
                objWeapon.y = catcher.y;

                objWeapon.width = pageGame.width / 10.0;
                objWeapon.height = pageGame.width / 10.0;

                objWeapon.velocity *= (pageGame.height / 850); // Для одинаковой длительности анимации на всех разрешениях экрана

                // Вычисление расстояния и угла между Catcher'ом и точкой клика сыши
                var dDiffX = mouseX - catcher.x;
                var dDiffY = 0.1;
                if (mouseY < catcher.y) { // Углы ниже уровня Catcher'а игнорируются
                    dDiffY = catcher.y - mouseY;
                }
                var dAngle = Math.atan(dDiffY / dDiffX);
                var dMaxRange = Math.sqrt(Math.pow(pageGame.width / 2, 2) + Math.pow(pageGame.height, 2));

                // Привидение угла
                if(dAngle < 0.) {
                    dAngle += Math.PI;
                }

                // Задание конечных координат орудия
                objWeapon.dTargetX = catcher.x + dMaxRange * Math.cos(dAngle) - objWeapon.width / 2;
                objWeapon.dTargetY = pageGame.height - (dMaxRange * Math.sin(dAngle) + (pageGame.height - catcher.y) + objWeapon.height / 2);

                objWeapon.moveX.start();
                objWeapon.moveY.start();

                objWeapon.iNumber = arrWeapons.length;
                arrWeapons.push(objWeapon);

                bShootingIsPermitted = false;
                catcher.indicatorColor = "red";
                timerShooting.start();


                if (soundLaunch.playbackState == MediaPlayer.PlayingState) {
                    soundLaunch.stop();
                }
                soundLaunch.play();
            }
        }
        onReleased: {
            catcher.silentMode();
        }
    }

    // Слой для отображения кнопок перезапуска и возврата в меню
    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: pageGame.height / 5.0
        spacing: 20

        // Рестарт
        Button {
            id: buttonRestart
            visible: false

            width: pageGame.width / 1.3
            height: pageGame.height / 9.0

            text: qsTr("Заново")

            onClicked: {
                sigRestart();
            }
        }

        // Возврат в главное меню
        Button {
            id: buttonBack
            visible: false

            width: pageGame.width / 1.3
            height: pageGame.height / 9.0

            text: qsTr("В меню")

            onClicked: {
                arrWeapons.splice(0, arrWeapons.length);
                arrCircles.splice(0, arrCircles.length);
                sigBack();
                pageGame.destroy();
            }
        }
    }

    // Конец игры и итоговое число попаданий
    StyleText {
        id: textGameOver

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: pageGame.height / 6.4
        visible: false

        fontSize: pageGame.width / 9.0
        textString: "GAME OVER\n" + "Hit: " + catcher.iHitCounter
    }

    Component.onCompleted:  {
        sigResult.connect(DataProcessing.slotAddToModel);
    }
}
