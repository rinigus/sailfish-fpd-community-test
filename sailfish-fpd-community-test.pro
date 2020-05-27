# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = sailfish-fpd-community-test

CONFIG += sailfishapp

QT += dbus

SOURCES += src/sailfish-fpd-community-test.cpp \
    src/fpdinterface.cpp

DISTFILES += qml/sailfish-fpd-community-test.qml \
    qml/pages/FirstPage.qml \
    qml/pages/SecondPage.qml \
    rpm/sailfish-fpd-community-test.changes.in \
    rpm/sailfish-fpd-community-test.changes.run.in \
    rpm/sailfish-fpd-community-test.spec \
    rpm/sailfish-fpd-community-test.yaml \
    translations/*.ts \
    sailfish-fpd-community-test.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/sailfish-fpd-community-test-de.ts

HEADERS += \
    src/fpdinterface.h
