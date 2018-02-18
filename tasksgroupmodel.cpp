#include "tasksgroupmodel.h"
#include <QDateTime>
#include <QDebug>
#include <QSqlError>
#include <QSqlField>
#include <QSqlIndex>
#include <QSqlRecord>
#include "tasks.h"

TasksGroupModel::TasksGroupModel(const QSqlDatabase& db, QObject *parent) :
    QSqlTableModel(parent, db)
{
    setTable("tasks");
    setSort(0, Qt::SortOrder::AscendingOrder);
    setFilter(QString("NOT status='%1'").arg(Tasks::DISABLED));
    setEditStrategy(EditStrategy::OnFieldChange);
    select();
    qDebug() << primaryKey().name();
}

void TasksGroupModel::addTask(QString description)
{
    auto record = this->record();
    record.remove(record.indexOf("taskId"));
    record.setValue("description", description);
    record.setValue("status", Tasks::ACTIVE);
    record.setValue("doable", 0);
    record.setValue("history", "0");

    if (!insertRecord(-1, record)) {
        qWarning() << "couldn't insert" << record
                   << "last error" << database().lastError();
    }
}

bool TasksGroupModel::removeRow(int row)
{
    return QSqlTableModel::removeRows(row, 1);
}

