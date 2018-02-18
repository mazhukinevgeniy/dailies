#include "tasks.h"
#include "tasksgroupmodel.h"
#include <QSqlError>
#include <QSqlQuery>
#include <QDebug>

Tasks::Tasks(QObject *parent) : QObject(parent), db(QSqlDatabase::addDatabase("QSQLITE")) {
    db.setDatabaseName("dailies.sqlite");
    if (!db.open()) {
        qDebug() << "Couldn't open database!" << db.lastError().text();
    } else {
        initTables();
    }

    model = new TasksGroupModel(db);
}

void Tasks::initTables() {
    db.exec("CREATE TABLE IF NOT EXISTS tasks ("
            "taskId INTEGER PRIMARY KEY,"
            "description TEXT,"
            "status INTEGER,"
            "history TEXT)");
}

QSqlTableModel* Tasks::getTasksQueryModel()
{
    return model;
}

void Tasks::endDay() {
    model->select();
    for (int i = 0; i < model->rowCount(); i++) {
        auto index = model->index(i, 3);
        model->setData(index, QString("0%1").arg(model->data(index).toString()));
    }
    model->select();
}

void Tasks::resetDatabase() {
    db.exec("DROP TABLE tasks");
    initTables();
    model->select();
}
