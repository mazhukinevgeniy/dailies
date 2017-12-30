#include "tasks.h"
#include <QDate>
#include <QDebug>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>

Tasks::Tasks(QObject *parent) : QObject(parent), db(QSqlDatabase::addDatabase("QSQLITE")) {
    db.setDatabaseName("dailies.sqlite");
    if (!db.open()) {
        qDebug() << "Couldn't open database!" << db.lastError().text();
    } else {
        initTables();
    }
}

void Tasks::initTables() {
    execute("CREATE TABLE IF NOT EXISTS checks ("
            "checkId INTEGER PRIMARY KEY,"
            "taskId INTEGER,"
            "status INTEGER,"
            "date DATE)");
    execute("CREATE TABLE IF NOT EXISTS tasks ("
            "taskId INTEGER PRIMARY KEY,"
            "description TEXT,"
            "status INTEGER)");
}

QSqlQuery Tasks::execute(QString query) {
    QSqlQuery sqlQuery(db);
    //create new object in case multithreading happens
    //or is QSqlQuery reentrant on its own?
    //TODO: investigate

    if (!sqlQuery.exec(query)) {
        qDebug() << query << "caused an error:" << db.lastError().text();
    }

    return sqlQuery;
}

QSqlQueryModel * Tasks::getChecksQueryModel(QVariant taskId) {
    SqlQueryModel *model = new SqlQueryModel();
    model->setQuery(QString("SELECT status, checkId FROM checks "
                            "WHERE taskId='%1' ORDER BY checkId DESC")
                    .arg(taskId.toLongLong()), db);
    return model;
}

QSqlQueryModel * Tasks::getTasksQueryModel() {
    SqlQueryModel *model = new SqlQueryModel();
    model->setQuery("SELECT taskId, description, status FROM tasks ORDER BY status, taskId", db);
    return model;
}

void Tasks::addCheck(QVariant taskId) {
    execute(QString("INSERT INTO checks (taskId, status, date)"
                    "VALUES('%1','%2','%3')").arg(taskId.toLongLong())
            .arg(__CHECK_STATUS_TBD)
            .arg(QDate::currentDate().toString("yyyy-MM-dd")));
}

//TODO: add protection from sql injections
void Tasks::addTask(QString description) {
    execute(QString("INSERT INTO tasks (description, status)"
                    "VALUES('%1','%2')").arg(description).arg(__TASK_STATUS_ACTIVE));

    auto getNewTaskId = execute(QString("SELECT taskId FROM tasks"
                                        " WHERE description='%1' ORDER BY taskId DESC")
                                .arg(description));
    if (getNewTaskId.next()) {
        QVariant taskId = getNewTaskId.value(0);
        addCheck(taskId);
    } else {
        qDebug() << QString("no id found for some reason") << getNewTaskId.lastError().text();
    }

    updateTasksModel();//no need to updateChecksModel as check model for the new task would be fresh anyway
}

void Tasks::removeTask(QVariant taskId) {
    execute(QString("DELETE FROM tasks WHERE taskId='%1'").arg(taskId.toLongLong()));
    updateTasksModel();
}

void Tasks::markDone(QVariant checkId) {
    execute(QString("UPDATE checks SET status='%1' WHERE checkId='%2'")
            .arg(__CHECK_STATUS_DONE).arg(checkId.toLongLong()));
    execute(QString("UPDATE tasks SET status='%1' WHERE taskId="
                    "(SELECT taskId FROM checks WHERE checkId='%2')")
            .arg(__TASK_STATUS_DONE_FOR_NOW).arg(checkId.toLongLong()));

    updateTasksModel();
}

void Tasks::endDay() {
    execute(QString("UPDATE checks SET status='%1'"
                    "WHERE status='%2'")
            .arg(__CHECK_STATUS_FAILED).arg(__CHECK_STATUS_TBD));
    execute(QString("UPDATE tasks SET status='%1' WHERE status='%2'")
            .arg(__TASK_STATUS_ACTIVE).arg(__TASK_STATUS_DONE_FOR_NOW));

    auto knownTasks = execute(QString("SELECT taskId FROM tasks WHERE NOT status='%1'")
                              .arg(__TASK_STATUS_DISABLED));
    while (knownTasks.next()) {
        addCheck(knownTasks.value(0));
    }

    updateTasksModel();
}

void Tasks::resetDatabase() {
    execute("DROP TABLE checks");
    execute("DROP TABLE tasks");
    initTables();

    updateTasksModel();
}
