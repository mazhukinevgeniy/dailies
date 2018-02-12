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
            "rank INTEGER,"
            "date DATE)");//TODO: merge status with tags
    execute("CREATE TABLE IF NOT EXISTS tasks ("
            "taskId INTEGER PRIMARY KEY,"
            "description TEXT,"
            "status INTEGER)");
    execute("CREATE TABLE IF NOT EXISTS tags ("
            "taskId INTEGER,"
            "tag TEXT,"
            "PRIMARY KEY (taskId, tag))");

    //TODO: why does resetdates exist?
    execute("CREATE TABLE IF NOT EXISTS resetDates ("
            "date DATE PRIMARY KEY)");
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
    model->setQuery(QString("SELECT status, rank, checkId FROM checks "
                            "WHERE taskId='%1' ORDER BY checkId DESC")
                    .arg(taskId.toLongLong()), db);
    return model;
}

QSqlQueryModel * Tasks::getTasksQueryModel() {
    SqlQueryModel *model = new SqlQueryModel();
    model->setQuery(QString("SELECT taskId, description, status FROM tasks "
                            "WHERE NOT status='%1' "
                            "ORDER BY taskId ASC")
                    .arg(__TASK_STATUS_DISABLED), db);
    return model;
}

QSqlQueryModel * Tasks::getResetsQueryModel() {
    SqlQueryModel *model = new SqlQueryModel();
    model->setQuery(QString("SELECT date FROM resetDates "
                            "ORDER BY date"), db);
    return model;
}

void Tasks::addCheck(QVariant taskId) {
    execute(QString("INSERT INTO checks (taskId, status, rank, date)"
                    "VALUES('%1','%2', '0', '%3')").arg(taskId.toLongLong())
            .arg(__CHECK_STATUS_TBD)
            .arg(QDate::currentDate().toString("yyyy-MM-dd")));
}

//TODO: add protection from sql injections
void Tasks::addTask(QString description, QStringList tags) {
    execute(QString("INSERT INTO tasks (description, status)"
                    "VALUES('%1','%2')")
            .arg(description).arg(__TASK_STATUS_ACTIVE));

    //TODO: there must be a better way to get new task's id:
    auto getNewTaskId = execute(QString("SELECT taskId FROM tasks"
                                        " WHERE description='%1' ORDER BY taskId DESC")
                                .arg(description));
    if (getNewTaskId.next()) {
        QVariant taskId = getNewTaskId.value(0);
        addCheck(taskId);

        for (QString tag : tags) {
            addTag(taskId, tag);
        }
    } else {
        qDebug() << QString("no id found for some reason") << getNewTaskId.lastError().text();
    }

    updateTasksModel();//no need to updateChecksModel as check model for the new task would be fresh anyway
}

bool Tasks::checkTag(QVariant taskId, QString tag) {
    return execute(QString("SELECT taskId FROM tags "
                           "WHERE taskId='%1' AND tag='%2'")
                   .arg(taskId.toLongLong()).arg(tag)).next();
}

void Tasks::addTag(QVariant taskId, QString tag) {
    execute(QString("INSERT INTO tags (taskId, tag) "
                    "VALUES('%1','%2')")
            .arg(taskId.toLongLong()).arg(tag));
}

void Tasks::disableTask(QVariant taskId) {
    execute(QString("UPDATE tasks SET status='%1' WHERE taskId='%2'")
            .arg(__TASK_STATUS_DISABLED).arg(taskId.toLongLong()));
    updateTasksModel();
}

void Tasks::markDone(QVariant checkId) {
    execute(QString("UPDATE checks SET status='%1', rank='1' WHERE checkId='%2'")
            .arg(__CHECK_STATUS_DONE).arg(checkId.toLongLong()));
    execute(QString("UPDATE tasks SET status='%1' WHERE taskId="
                    "(SELECT taskId FROM checks WHERE checkId='%2')")
            .arg(__TASK_STATUS_DONE_FOR_NOW).arg(checkId.toLongLong()));

    updateTasksModel();
}

void Tasks::upgrade(QVariant checkId) {
    execute(QString("UPDATE checks SET rank=1+"
                    "(SELECT rank FROM checks "
                    "WHERE checkId='%1') WHERE checkId='%1'")
            .arg(checkId.toLongLong()));

    updateTasksModel();
}

void Tasks::endDay() {
    execute(QString("UPDATE checks SET status='%1'"
                    "WHERE status='%2'")
            .arg(__CHECK_STATUS_FAILED).arg(__CHECK_STATUS_TBD));
    execute(QString("UPDATE tasks SET status='%1' WHERE status='%2'")
            .arg(__TASK_STATUS_ACTIVE).arg(__TASK_STATUS_DONE_FOR_NOW));
    execute(QString("INSERT INTO resetDates (date) VALUES('%1')")
            .arg(QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss")));

    auto knownTasks = execute(QString("SELECT taskId FROM tasks"));
    while (knownTasks.next()) {
        addCheck(knownTasks.value(0));
    }

    updateTasksModel();
}

void Tasks::resetDatabase() {
    execute("DROP TABLE checks");
    execute("DROP TABLE tasks");
    execute("DROP TABLE resetDates");
    execute("DROP TABLE tags");
    initTables();

    updateTasksModel();
}

void Tasks::resetModel() {
    updateTasksModel();
}
