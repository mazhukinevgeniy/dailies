#ifndef TASKS_H
#define TASKS_H

#include "sqlquerymodel.h"

class Tasks : public QObject
{
    Q_OBJECT
public:
    explicit Tasks(QObject *parent = nullptr);

    //TODO: rethink db design
    Q_INVOKABLE
    QSqlQueryModel* getChecksQueryModel(QVariant taskId);
    Q_INVOKABLE
    QSqlQueryModel* getTasksQueryModel();
    Q_INVOKABLE
    QSqlQueryModel* getResetsQueryModel();

    Q_INVOKABLE
    void addTask(QString description);
    Q_INVOKABLE
    void disableTask(QVariant taskId);

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

    void initTables();
    void addCheck(QVariant taskId);

    QSqlDatabase db;
};

#endif // TASKS_H
