import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

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
            Button {
                text: "Identify"
                onClicked: {
                    FPDInterface.identify();
                }
            }
        }
    }
}
