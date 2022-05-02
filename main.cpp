#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>

#include "DataProcessing.h"

int main(int argc, char *argv[])
{
  QGuiApplication app(argc, argv);

  QIcon oIcon("img/weapon.png");
  app.setWindowIcon(oIcon);
  app.setDesktopFileName("Catcher");
  app.setApplicationDisplayName("Catcher");

  DataProcessing oDataProcessing;
  oDataProcessing.vLoad();

  QQmlApplicationEngine engine;
  engine.rootContext()->setContextProperty("DataProcessing", &oDataProcessing);
  engine.rootContext()->setContextProperty("HighScoreModel", oDataProcessing.poGetModel());
  engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

  if (engine.rootObjects().isEmpty())
    return -1;

  return app.exec();
}
