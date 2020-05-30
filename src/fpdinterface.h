#ifndef FPDINTERFACE_H
#define FPDINTERFACE_H

#include <QObject>
#include <QDBusConnection>
#include <QDBusError>
#include <QDBusInterface>
#include <QDBusServiceWatcher>
#include <QStringList>

#define SERVICE_NAME "org.sailfishos.fingerprint1"

class FPDInterface : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool connected MEMBER m_connected NOTIFY connectionStateChanged)
    Q_PROPERTY(QStringList fingerprints READ fingerprints NOTIFY fingerprintsChanged)

public:
    explicit FPDInterface(QObject *parent = nullptr);

signals:
    void connectionStateChanged();

    void stateChanged(const QString &state);
    void enrollProgressChanged(int progress);
    void acquisitionInfo(const QString &info);
    void added(const QString &finger);
    void identified(const QString &finger);
    void fingerprintsChanged(const QStringList &fingerprints);

public slots:
    void enroll(const QString &user);
    void identify();
    void clear();

public:
    QStringList fingerprints() const;

private slots:
    void connectDaemon();
    void disconnectDaemon();
    void onListChanged();

private:
    QDBusInterface *iface = nullptr;
    QDBusServiceWatcher *m_serviceWatcher = nullptr;
    bool m_connected = false;
    QStringList m_fingerprints;
};

#endif // FPDINTERFACE_H
