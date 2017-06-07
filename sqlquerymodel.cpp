#include "sqlquerymodel.h"
#include <QSqlRecord>
#include <QSqlField>

/**
 * Code from https://wiki.qt.io/How_to_Use_a_QSqlQueryModel_in_QML
 *
 * No idea what license is it under
 */
SqlQueryModel::SqlQueryModel(QObject *parent) :
    QSqlQueryModel(parent) {
}

void SqlQueryModel::setQuery(const QString &query, const QSqlDatabase &db) {
    QSqlQueryModel::setQuery(query, db);
    generateRoleNames();
}

void SqlQueryModel::setQuery(const QSqlQuery & query) {
    QSqlQueryModel::setQuery(query);
    generateRoleNames();
}

void SqlQueryModel::generateRoleNames() {
    m_roleNames.clear();
    for (int i = 0; i < record().count(); i++) {
        m_roleNames.insert(Qt::UserRole + i + 1, record().fieldName(i).toUtf8());
    }
}

QVariant SqlQueryModel::data(const QModelIndex &index, int role) const {
    QVariant value;

    if (role < Qt::UserRole) {
        value = QSqlQueryModel::data(index, role);
    } else {
        int columnIdx = role - Qt::UserRole - 1;
        QModelIndex modelIndex = this->index(index.row(), columnIdx);
        value = QSqlQueryModel::data(modelIndex, Qt::DisplayRole);
    }
    return value;
}
