#ifndef TASKS_H
#define TASKS_H

#include <QSqlTableModel>

class Tasks : public QObject
{
    Q_OBJECT
public:
    explicit Tasks(QObject *parent = nullptr);
    Tasks(const Tasks &sameThing) = default;

    enum Status {
        ACTIVE = 2,
        DOABLE = 4,
        DISABLED = 8
    };
    Q_ENUM(Status)

    QSqlTableModel* getTasksQueryModel();
    Q_INVOKABLE void endDay();
    Q_INVOKABLE void resetDatabase();

private:
    void initTables();

    QSqlTableModel* model;
    QSqlDatabase db;
};

#endif // TASKS_H
