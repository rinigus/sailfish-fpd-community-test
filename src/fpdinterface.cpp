#include "fpdinterface.h"
#include <QDebug>

FPDInterface::FPDInterface(QObject *parent) : QObject(parent),
    m_serviceWatcher(new QDBusServiceWatcher(
        QStringLiteral(SERVICE_NAME), QDBusConnection::sessionBus(),
        QDBusServiceWatcher::WatchForRegistration | QDBusServiceWatcher::WatchForUnregistration))
{
    QObject::connect(m_serviceWatcher, &QDBusServiceWatcher::serviceRegistered,   this, &FPDInterface::connectDaemon);
    QObject::connect(m_serviceWatcher, &QDBusServiceWatcher::serviceUnregistered, this, &FPDInterface::disconnectDaemon);

    connectDaemon();
}

void FPDInterface::enroll(const QString &user)
{
    qDebug() << Q_FUNC_INFO;
    if (!iface->isValid()) {
        return;
    }
    iface->call("Enroll", user);
}

void FPDInterface::identify()
{
    qDebug() << Q_FUNC_INFO;
    if (!iface->isValid()) {
        return;
    }
    iface->call("Identify");
}

void FPDInterface::clear()
{
    qDebug() << Q_FUNC_INFO;
    if (!iface->isValid()) {
        return;
    }
    iface->call("Clear");
}

void FPDInterface::enumerate()
{
    qDebug() << Q_FUNC_INFO;
    if (!iface->isValid()) {
        return;
    }
    iface->call("Enumerate");
}

void FPDInterface::connectDaemon()
{
    qDebug() << Q_FUNC_INFO;

    if (iface) {
        iface->deleteLater();
    }

    iface = new QDBusInterface(QStringLiteral(SERVICE_NAME), QStringLiteral("/org/sailfishos/fingerprint1"), QStringLiteral(SERVICE_NAME), QDBusConnection::systemBus());

    if (!iface->isValid()) {
        iface->deleteLater();
        return;
    }
    m_connected = true;
    connectionStateChanged();

    //FPD Signals
    connect(iface, SIGNAL(EnrollProgressChanged(int)), this, SIGNAL(enrollProgressChanged(int)), Qt::UniqueConnection);
    connect(iface, SIGNAL(Added(const QString&)), this, SIGNAL(added(const QString&)), Qt::UniqueConnection);
    connect(iface, SIGNAL(StateChanged(const QString&)), this, SIGNAL(stateChanged(const QString&)), Qt::UniqueConnection);
    connect(iface, SIGNAL(AcquisitionInfo(const QString&)), this, SIGNAL(acquisitionInfo(const QString&)), Qt::UniqueConnection);
    connect(iface, SIGNAL(Identified(const QString&)), this, SIGNAL(identified(const QString&)), Qt::UniqueConnection);

}

void FPDInterface::disconnectDaemon()
{
    qDebug() << Q_FUNC_INFO;

    m_connected = false;
    connectionStateChanged();

}
