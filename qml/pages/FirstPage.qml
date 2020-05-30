import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    property string msg: ""
    property string m_state: ""
    property string m_acquisition: ""

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Community FPD Test")
            }
            Label {
                x: Theme.horizontalPageMargin
                text: FPDInterface.connected ? "Conneceted" : "Disconnected"
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeExtraLarge
            }
            Button {
                text: "Enroll"
                onClicked: {
                    FPDInterface.enroll("finger");
                }
            }
            ProgressBar {
                id: enrollProgress
                minimumValue: 0
                maximumValue: 100
                value: 0
                width: parent.width
            }

            Label {
                width: parent.width
                text: "Message: " + msg
            }

            Button {
                text: "Identify"
                onClicked: {
                    FPDInterface.identify();
                }
            }
            Button {
                text: "Clear Store"
                onClicked: {
                    FPDInterface.clear();
                }
            }
            Button {
                text: "Enumerate"
                onClicked: {
                    FPDInterface.enumerate();
                }
            }
            Label {
                width: parent.width
                text: "State: " + m_state
            }
            Label {
                width: parent.width
                text: "Acquisition: " + m_acquisition
            }
        }
    }


    Connections {
        target: FPDInterface
        onEnrollProgressChanged: {
            console.log("Enrollment progress changed ", progress);
            enrollProgress.value = progress;
        }

        onAdded: {
            msg = "Added finger" + finger;
        }

        onStateChanged: {
            m_state = state;
        }

        onAcquisitionInfo: {
            m_acquisition = info;
        }

        onIdentified: {
            msg = "Identified: " + finger;
        }
    }
}
