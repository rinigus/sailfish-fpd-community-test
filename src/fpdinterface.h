#ifndef FPDINTERFACE_H
#define FPDINTERFACE_H

#include <QObject>
#include <QDBusConnection>
#include <QDBusError>
#include <QDBusInterface>
#include <QDBusServiceWatcher>

#define SERVICE_NAME "org.sailfishos.fingerprint1"

class FPDInterface : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool connected MEMBER m_connected NOTIFY connectionStateChanged)
public:
    explicit FPDInterface(QObject *parent = nullptr);

signals:
    void connectionStateChanged();

public slots:
    void enroll(const QString &user);
    void identify();

private slots:
    void connectDaemon();
    void disconnectDaemon();

private:
    QDBusInterface *iface = nullptr;
    QDBusServiceWatcher *m_serviceWatcher = nullptr;
    bool m_connected = false;

};

#endif // FPDINTERFACE_H
