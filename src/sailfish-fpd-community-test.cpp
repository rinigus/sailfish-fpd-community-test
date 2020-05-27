#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>
#include <QQuickView>
#include <QGuiApplication>
#include <QQmlContext>

#include "fpdinterface.h"

int main(int argc, char *argv[])
{
    // SailfishApp::main() will display "qml/sailfish-fpd-community-test.qml", if you need more
    // control over initialization, you can use:
    //
    //   - SailfishApp::application(int, char *[]) to get the QGuiApplication *
    //   - SailfishApp::createView() to get a new QQuickView * instance
    //   - SailfishApp::pathTo(QString) to get a QUrl to a resource file
    //   - SailfishApp::pathToMainQml() to get a QUrl to the main QML file
    //
    // To display the view, call "show()" (will show fullscreen on device).

    QGuiApplication *app = SailfishApp::application(argc, argv);
    FPDInterface fpd;

    QQuickView *view = SailfishApp::createView();
    view->rootContext()->setContextProperty("FPDInterface", &fpd);

    view->setSource(SailfishApp::pathTo("qml/sailfish-fpd-community-test.qml"));
    view->show();

    return app->exec();
}
