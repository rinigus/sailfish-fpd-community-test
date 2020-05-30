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

    void stateChanged(const QString &state);
    void enrollProgressChanged(int progress);
    void acquisitionInfo(const QString &info);
    void added(const QString &finger);
    void identified(const QString &finger);

public slots:
    void enroll(const QString &user);
    void identify();
    void clear();
    void enumerate();

private slots:
    void connectDaemon();
    void disconnectDaemon();

private:
    QDBusInterface *iface = nullptr;
    QDBusServiceWatcher *m_serviceWatcher = nullptr;
    bool m_connected = false;

};

#endif // FPDINTERFACE_H
