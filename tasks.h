#ifndef TASKS_H
#define TASKS_H

#include "sqlquerymodel.h"

class Tasks : public QObject
{
    Q_OBJECT
public:
    explicit Tasks(QObject *parent = nullptr);

    Q_INVOKABLE
    QSqlQueryModel * getChecksQueryModel(QVariant taskId);
    Q_INVOKABLE
    QSqlQueryModel * getTasksQueryModel();

    Q_INVOKABLE
    void addTask(QString description);

    Q_INVOKABLE
    void markDone(QVariant checkId);

    Q_INVOKABLE
    void endDay();

    Q_INVOKABLE
    void resetDatabase();
signals:
    void updateTasksModel();
    void updateChecksModel();//TODO: maybe pass taskId; maybe google how is it actually done
};

#endif // TASKS_H
