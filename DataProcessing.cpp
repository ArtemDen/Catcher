#include "DataProcessing.h"

#include <QApplication>
#include <QJsonArray>
#include <QJsonDocument>
#include <QFileDialog>
#include <QDateTime>
#include <QStandardPaths>
//-------------------------------------------------------------------------------------------------
DataProcessing::DataProcessing()
{

}
//-------------------------------------------------------------------------------------------------
DataProcessing::~DataProcessing()
{
  _oHighScoreModel.clear();
}
//-------------------------------------------------------------------------------------------------
void DataProcessing::vSave()
{
  // Путь к файлу
  QString strFilePath;

#ifdef ANDROID_ON
  strFilePath= QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/" + _cstrHighScoreName;
#else
  strFilePath = QApplication::applicationDirPath() + "/" + _cstrHighScoreName;
#endif

  // Файл
  QFile oFile(strFilePath);
  if(oFile.open(QIODevice::WriteOnly)){

      // Массив записей
      QJsonArray oJsonArray;

      for (int iRow = 0; iRow < _oHighScoreModel.rowCount(); iRow++) {
          oJsonArray.push_back(_oHighScoreModel.index(iRow, 0).data(Qt::DisplayRole).toString());
          oJsonArray.push_back(_oHighScoreModel.index(iRow, 1).data(Qt::DisplayRole).toInt());
      }

    // Файл записей
    QJsonDocument JsonDoc;
    JsonDoc.setArray(oJsonArray);
    oFile.write(JsonDoc.toJson());
    oFile.close();
  }
}
//-------------------------------------------------------------------------------------------------
void DataProcessing::vLoad()
{
  // Путь к файлу
  QString strFilePath;

#ifdef ANDROID_ON
  strFilePath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/" + _cstrHighScoreName;
#else
  strFilePath = QApplication::applicationDirPath() + "/" + _cstrHighScoreName;
#endif

  // Файл рекордов
  QFile oFile(strFilePath);

  // Проверка на существование файла
  if(oFile.exists()){
    if(oFile.open(QIODevice::ReadOnly)) {

      // Считанный файл записей
      QJsonDocument oJsonDoc(QJsonDocument::fromJson(oFile.readAll()));

      // Ссылка на массив записей
      const QJsonArray& croJsonArray = oJsonDoc.array();

      for (int iRow = 0; iRow < croJsonArray.count() / 2; iRow++) {

          // Объект данных
          QList<QStandardItem*> listItems(2);

          listItems[0] = new QStandardItem();
          listItems[0]->setData(croJsonArray[iRow * 2].toString(), Qt::DisplayRole);

          listItems[1] = new QStandardItem();
          listItems[1]->setData(croJsonArray[iRow * 2 + 1].toInt(), Qt::DisplayRole);

          _oHighScoreModel.insertRow(iRow, listItems);
      }

      oFile.close();
    }
  }
}
//-------------------------------------------------------------------------------------------------
void DataProcessing::slotAddToModel(int iValue)
{
  // Объект данных
  QList<QStandardItem*> listItems(2);

  listItems[0] = new QStandardItem();
  listItems[0]->setData(QDateTime::currentDateTime().toString(), Qt::DisplayRole);

  listItems[1] = new QStandardItem();
  listItems[1]->setData(iValue, Qt::DisplayRole);

  // Определение индекса записываемого значения
  int iRow = _oHighScoreModel.rowCount() - 1;
  if (iRow < 9) {
    _oHighScoreModel.insertRow(iRow + 1, listItems);
  }
  else {
    if (iValue > _oHighScoreModel.index(iRow, 1).data(Qt::DisplayRole).toInt()) {

       // Удаление заменяемого объекта из памяти
       QList<QStandardItem*> listOldItems = _oHighScoreModel.takeRow(iRow);
       for (QStandardItem* poItem: listOldItems) {
           delete poItem;
       }

       _oHighScoreModel.insertRow(iRow, listItems);
    }

    // Удаление неиспользуемого объекта из памяти
    else {
        for (QStandardItem* poItem: listItems) {
            delete poItem;
        }
    }
  }

  // Сортировка по убыванию и сохранение данных
  _oHighScoreModel.sort(1, Qt::DescendingOrder);
  vSave();
}
//-------------------------------------------------------------------------------------------------
