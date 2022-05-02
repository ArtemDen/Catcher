import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import "Pages"

ApplicationWindow {

    id: windowMain
    visible: true
    width: 400
    height: 750
    title: qsTr("Catcher")
    contentOrientation: Qt.PortraitOrientation

    // Страница с главным меню
    FirstPage {
        id: pageMainMenu
        width: windowMain.width
        height: windowMain.height

        // Удаление сцены из стека
        function popPageGame() {
            stack.pop();
        }

        // Создать страницу с игрой
        function createPageGame() {
            var componentPageGame = Qt.createComponent("../Pages/MainPage.qml");
            if(componentPageGame.status === Component.Ready) {
                pageHighScore.visible = false;
                var pageGame = componentPageGame.createObject(parent);
                if (stack.depth > 1) {
                    stack.pop();
                }
                stack.push(pageGame);
                pageGame.sigBack.connect(popPageGame);
                pageGame.sigRestart.connect(createPageGame);
            }
        }

        onSigStart: {
            createPageGame();
        }

        onSigHighScore: {
            stack.push(pageHighScore);
        }

        onSigExit: {
            windowMain.close();
        }
    }

    // Cтраница с рекордами
    TweakPage {
        id: pageHighScore
        width: windowMain.width
        height: windowMain.height

        // Удаление страницы из стека
        function popPageHighScore() {
            stack.pop();
        }

        Component.onCompleted: {
            pageHighScore.sigBack.connect(popPageHighScore);
        }
    }

    // Стек страниц
    StackView {
        id: stack
        anchors.fill: parent
        initialItem: pageMainMenu
    }

    Component.onCompleted: {
        if (Qt.platform.os.match("android")) {
            showFullScreen();
        }
    }
}
