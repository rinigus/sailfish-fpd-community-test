import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: mainPage

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    property ListModel log: ListModel {}
    property ListModel fingers: ListModel {}

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        PullDownMenu {

            MenuItem {
                enabled: FPDInterface.connected
                text: qsTr("Remove all fingerprints")
                onClicked: FPDInterface.clear()
            }

            MenuItem {
                enabled: FPDInterface.connected
                text: qsTr("Add fingerprint")
                onClicked: pageStack.push(Qt.resolvedUrl("EnrollPage.qml"),
                                          { "mainPage" : mainPage })
            }

            MenuItem {
                enabled: FPDInterface.connected
                text: "Identify"
                onClicked: {
                    var r = FPDInterface.identify();
                    if (r !== 0) {
                        mainPage.addLog(qsTr("Error while starting indentification: %1").arg(r));
                    }
                }
            }
        }

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: mainPage.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("Community FPD Test")
            }

            SectionHeader {
                text: qsTr("Status")
            }

            Label {
                text: qsTr("Connection: ") +
                      (FPDInterface.connected ? qsTr("Connected") : qsTr("Disconnected"))
                color: Theme.highlightColor
                width: parent.width - 2*x
                x: Theme.horizontalPageMargin
            }

            Label {
                text: qsTr("State: ") + FPDInterface.state
                color: Theme.highlightColor
                width: parent.width - 2*x
                x: Theme.horizontalPageMargin
            }

            SectionHeader {
                text: qsTr("Log")
            }

            Repeater {
                model: log
                delegate: Label {
                    text: model.text
                    color: Theme.highlightColor
                    width: parent.width - 2*x
                    wrapMode: Text.WordWrap
                    x: Theme.horizontalPageMargin
                }
            }

            SectionHeader {
                text: qsTr("Fingerprints")
            }

            Repeater {
                model: fingers
                delegate: ListItem {
                    id: listItem
                    contentHeight: Theme.itemSizeSmall
                    menu: ContextMenu {
                        MenuItem {
                            enabled: FPDInterface.connected
                            text: qsTr("Remove")
                            onClicked: listItem.remorseDelete(function() {
                                var r = FPDInterface.remove(model.finger);
                                if (r !== 0) {
                                    mainPage.addLog(qsTr("Error while starting removal: %1").arg(r));
                                }
                            })
                        }
                    }

                    Label {
                        anchors.verticalCenter: parent.verticalCenter
                        text: model.finger
                        width: parent.width - 2*x
                        wrapMode: Text.Wrap
                        x: Theme.horizontalPageMargin
                    }
                }
            }
        }
    }

    Connections {
        target: FPDInterface

        onAdded: addLog(qsTr("Added finger %1").arg(finger))
        onRemoved: addLog(qsTr("Removed finger: %1").arg(finger))
        onIdentified: addLog(qsTr("Identified finger: %1").arg(finger))
        onAborted: addLog(qsTr("Aborted"))
        onFailed: addLog(qsTr("Failed"))
        onVerified: addLog(qsTr("Verified"))

        onAcquisitionInfo: addLog(qsTr("Acqusition info: %1").arg(info))
        onErrorInfo: addLog(qsTr("Error: %1").arg(info))
        onFingerprintsChanged: updateFingers()
    }

    Component.onCompleted: updateFingers()

    function addLog(txt) {
        var maxlog = 5;
        if (log && log.count >= maxlog)
            log.remove(maxlog-1, log.count + 1 - maxlog);
        log.insert(0, {'text': txt});
    }

    function updateFingers() {
        fingers.clear();
        var fps = FPDInterface.fingerprints;
        console.log(fps)
        console.log(fps.length)
        for (var i=0; i < fps.length; ++i)
            fingers.append({'finger': fps[i]});
    }
}
