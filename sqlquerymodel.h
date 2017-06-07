#ifndef SQLQUERYMODEL_H
#define SQLQUERYMODEL_H

#include <QSqlQueryModel>

/**
 * Code from https://wiki.qt.io/How_to_Use_a_QSqlQueryModel_in_QML
 *
 * No idea what license is it under
 */
class SqlQueryModel : public QSqlQueryModel
{
    Q_OBJECT

public:
    explicit SqlQueryModel(QObject *parent = 0);

    void setQuery(const QString &query, const QSqlDatabase &db = QSqlDatabase());
    void setQuery(const QSqlQuery &query);
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const { return m_roleNames; }

private:
    void generateRoleNames();
    QHash<int, QByteArray> m_roleNames;
};

#endif // SQLQUERYMODEL_H
