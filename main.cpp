#include "tasks.h"
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    Tasks tasks;
    engine.rootContext()->setContextProperty("taskModel", tasks.getTasksQueryModel());
    engine.rootContext()->setContextProperty("tasks", &tasks);

    QObject::connect(&app, &QGuiApplication::aboutToQuit, tasks.getTasksQueryModel(), &QSqlTableModel::submitAll);

    qmlRegisterUncreatableType<Tasks>("app.enums", 1, 0, "Tasks", "for enums");
    qmlRegisterInterface<QSqlTableModel>("QSqlTableModel");

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
