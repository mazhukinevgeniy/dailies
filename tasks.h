#ifndef TASKS_H
#define TASKS_H

#include "sqlquerymodel.h"

class Tasks : public QObject
{
    Q_OBJECT
public:
    explicit Tasks(QObject *parent = nullptr);
    Tasks(const Tasks &sameThing) = default;

    //TODO: rethink db design
    Q_INVOKABLE
    QSqlQueryModel* getChecksQueryModel(QVariant taskId);
    Q_INVOKABLE
    QSqlQueryModel* getTasksQueryModel();
    Q_INVOKABLE
    QSqlQueryModel* getResetsQueryModel();

    Q_INVOKABLE
    void addTask(QString description, QStringList tags = {});
    Q_INVOKABLE
    void disableTask(QVariant taskId);


    Q_INVOKABLE
    bool checkTag(QVariant taskId, QString tag);
    //TODO: can we move it to a dedicated model class with rolenames etc?
    Q_INVOKABLE
    void addTag(QVariant taskId, QString tag);

    Q_INVOKABLE
    void markDone(QVariant checkId);

    Q_INVOKABLE
    void upgrade(QVariant checkId);

    Q_INVOKABLE
    void endDay();

    Q_INVOKABLE
    void resetDatabase();

    Q_INVOKABLE
    void resetModel();

signals:
    void updateTasksModel();
    void updateChecksModel();

private:

    QSqlQuery execute(QString query);
    //TODO: move everything to dedicated model classes?
    //we can also have something to init db connection and tables, it's fine

    void initTables();
    void addCheck(QVariant taskId);

    QSqlDatabase db;
};

#endif // TASKS_H
