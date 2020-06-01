import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    property var mainPage
    property bool started: false

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("Add new fingerprint")
            }

            Label {
                text: qsTr("Define unique name for a fingerprint and start by pressing Add")
                color: Theme.highlightColor
                wrapMode: Text.WordWrap
                width: parent.width - 2*x
                x: Theme.horizontalPageMargin
            }

            TextField {
                id: name
                focus: true
                placeholderText: qsTr("Fingerprint name")
                width: parent.width
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Add")
                enabled: name.text
                onClicked: {
                    var r = FPDInterface.enroll(name.text);
                    if (r !== 0) {
                        mainPage.addLog(qsTr("Error while starting to enroll: %1").arg(r));
                    } else {
                        started = true;
                    }
                }
            }

            ProgressBar {
                minimumValue: 0
                maximumValue: 100
                value: FPDInterface.enrollProgress
                width: parent.width
                visible: started
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
                model: mainPage.log
                delegate: Label {
                    text: model.text
                    color: Theme.highlightColor
                    width: parent.width - 2*x
                    wrapMode: Text.Wrap
                    x: Theme.horizontalPageMargin
                }
            }

            SectionHeader {
                text: qsTr("Defined fingerprints")
            }

            Repeater {
                model: mainPage.fingers
                delegate: ListItem {
                    id: listItem
                    contentHeight: Theme.itemSizeSmall

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

        VerticalScrollDecorator {}
    }
}
