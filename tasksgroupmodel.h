#ifndef TASKSGROUPMODEL_H
#define TASKSGROUPMODEL_H

#include <QSqlTableModel>

class TasksGroupModel : public QSqlTableModel
{
    Q_OBJECT
public:
    explicit TasksGroupModel(const QSqlDatabase& db, QObject* parent = nullptr);

    Q_INVOKABLE void addTask(QString description);
    Q_INVOKABLE bool removeRow(int row);
};

#endif // TASKSGROUPMODEL_H
