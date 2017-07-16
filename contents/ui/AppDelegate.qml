import QtQuick 2.5
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.kio 1.0 as Kio

MouseArea {
  id: root

  property var app
  property bool hovered: false

  hoverEnabled: true
  onEntered: hovered = true;
  onExited: hovered = false;

  Kio.KRun {
    id: kRun
  }

  onClicked: {
    kRun.openUrl(app.entryPath);
    rootWindow.toggle();
  }

  Loader {
    id: uiElements
    sourceComponent: isDash ? column : row
  }

  Component {
    id: column
    Column {
      anchors.horizontalCenter: parent.horizontalCenter
      spacing: 4
      PlasmaCore.IconItem {
        width: units.iconSizes.huge; height: width
        source: app ? app.iconName : ''
        anchors.horizontalCenter: parent.horizontalCenter
        active: hovered
      }

      PlasmaComponents.Label {
        text: app ? app.name : ''
        width: cellSize
        elide: Text.ElideRight
        maximumLineCount: 1
        color: theme.textColor
        horizontalAlignment: Text.AlignHCenter
        font.bold: hovered
      }
    }
  }

  Component {
    id: row
    Row {
      anchors.verticalCenter: parent.verticalCenter
      spacing: 8
      PlasmaCore.IconItem {
        id: rowIcon
        width: units.iconSizes.smallMedium; height: width
        source: app ? app.iconName : ''
        anchors.verticalCenter: parent.verticalCenter
        active: hovered
      }

      PlasmaComponents.Label {
        text: app ? app.name : ''
        width: cellSize - rowIcon.width - parent.spacing
        elide: Text.ElideRight
        maximumLineCount: 1
        color: theme.textColor
        font.bold: hovered
      }
    }
  }
}
