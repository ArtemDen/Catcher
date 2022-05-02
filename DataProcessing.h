#ifndef DATAPROCESSING_H
#define DATAPROCESSING_H
//-------------------------------------------------------------------------------------------------
#include <QObject>
#include <QVector>
#include <QVariant>
#include <QStandardItemModel>
//-------------------------------------------------------------------------------------------------
/** Класс-обработчик настроек */
class DataProcessing : public QObject
{
  Q_OBJECT

public:

  /** Конструктор */
  DataProcessing();

  /** Деструктор */
  ~DataProcessing();

  /** Сохранить */
  Q_INVOKABLE void vSave();

  /** Загрузить */
  void vLoad();

  QStandardItemModel* poGetModel() {
    return &_oHighScoreModel;
  }

public slots:

  /** Добавление строчки в список рекордов */
  void slotAddToModel(int iValue);

private:

  /** Название файла-хранилища данных */
  const QString _cstrHighScoreName = "HighScore.json";

  /** Модель представления данных */
  QStandardItemModel _oHighScoreModel;

};

#endif // DATAPROCESSING_H
