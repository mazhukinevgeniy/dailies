#include "tasks.h"
#include <QDate>
#include <QDebug>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>

Tasks::Tasks(QObject *parent) : QObject(parent), db(QSqlDatabase::addDatabase("QSQLITE")) {
    db.setDatabaseName("dailies.sqlite");
    if (!db.open()) {
        qDebug() << db.lastError().text();
    }

    QSqlQuery create(db);
    bool success;

    success = create.exec("CREATE TABLE checks ("
                          "checkId INTEGER PRIMARY KEY,"
                          "taskId INTEGER,"
                          "status INTEGER,"
                          "date DATE)");

    if (!success) {
        qDebug() << db.lastError().text();
    }

    success = create.exec("CREATE TABLE tasks ("
                          "taskId INTEGER PRIMARY KEY,"
                          "description TEXT,"
                          "status INTEGER)");

    if (!success) {
        qDebug() << db.lastError().text();
    }
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

inline void addCheck(QVariant taskId, QSqlDatabase& db) {
    QString query = QString("INSERT INTO checks (taskId, status, date)"
                            "VALUES('%1','%2','%3')").arg(taskId.toLongLong())
                    .arg(__CHECK_STATUS_TBD)
                    .arg(QDate::currentDate().toString("yyyy-MM-dd"));
    QSqlQuery addCheck(query, db);
}

//TODO: add protection from sql injections
void Tasks::addTask(QString description) {
    QSqlQuery addTask(QString("INSERT INTO tasks (description, status)"
                      "VALUES('%1','%2')").arg(description).arg(__TASK_STATUS_ACTIVE), db);
    qDebug() << addTask.lastError().text();

    QSqlQuery getNewTaskId(QString("SELECT taskId FROM tasks"
                                   " WHERE description='%1' ORDER BY taskId DESC").arg(description), db);
    if (getNewTaskId.next()) {
        QVariant taskId = getNewTaskId.value(0);
        addCheck(taskId, db);
    } else {
        qDebug() << QString("no task added or what?") << addTask.lastError().text() << getNewTaskId.lastError().text();
    }

    updateTasksModel();//no need to updateChecksModel as check model for the new task would be fresh anyway
}

void Tasks::markDone(QVariant checkId) {
    QSqlQuery markDone(QString("UPDATE checks SET status='%1' WHERE checkId='%2'")
                       .arg(__CHECK_STATUS_DONE).arg(checkId.toLongLong()), db);
    QSqlQuery updateTaskStatus(QString("UPDATE tasks SET status='%1' WHERE taskId="
                                       "(SELECT taskId FROM checks WHERE checkId='%2')")
                               .arg(__TASK_STATUS_DONE_FOR_NOW).arg(checkId.toLongLong()), db);

    updateTasksModel();
    updateChecksModel();
}

void Tasks::endDay() {
    QSqlQuery markDone(QString("UPDATE checks SET status='%1'"
                       "WHERE status='%2'").arg(__CHECK_STATUS_FAILED).arg(__CHECK_STATUS_TBD), db);
    QSqlQuery activateTasks(QString("UPDATE tasks SET status='%1' WHERE status='%2'")
                            .arg(__TASK_STATUS_ACTIVE).arg(__TASK_STATUS_DONE_FOR_NOW), db);

    QSqlQuery knownTasks(QString("SELECT taskId FROM tasks WHERE NOT status='%1'")
                         .arg(__TASK_STATUS_DISABLED), db);
    while (knownTasks.next()) {
        qDebug() << "adding check for" << knownTasks.value(0);
        addCheck(knownTasks.value(0), db);
    }

    updateTasksModel();
    updateChecksModel();
}

void Tasks::resetDatabase() {
    QSqlQuery clearChecks("DELETE FROM checks", db);
    QSqlQuery clearTasks("DELETE FROM tasks", db);

    updateTasksModel();
    updateChecksModel();
}
