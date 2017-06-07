#include "tasks.h"
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    Tasks tasks;
    engine.rootContext()->setContextProperty("tasks", &tasks);
    engine.rootContext()->setContextProperty("check_tbd", __CHECK_STATUS_TBD);
    engine.rootContext()->setContextProperty("check_done", __CHECK_STATUS_DONE);
    engine.rootContext()->setContextProperty("check_failed", __CHECK_STATUS_FAILED);
    engine.rootContext()->setContextProperty("task_tbd", __TASK_STATUS_ACTIVE);
    engine.rootContext()->setContextProperty("task_disabled", __TASK_STATUS_DISABLED);
    engine.rootContext()->setContextProperty("task_done", __TASK_STATUS_DONE_FOR_NOW);

    qmlRegisterInterface<QSqlQueryModel>("QSqlQueryModel");

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
