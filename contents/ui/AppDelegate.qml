import QtQuick 2.5
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.kio 1.0 as Kio

MouseArea {
  id: delegate

  property var app
  property bool highlighted: activeFocus || grid.currentIndex === index

  hoverEnabled: true
  onEntered: grid.currentIndex = index;
  onExited: grid.currentIndex = -1;

  Keys.onDownPressed: {
    root.setFocus(index + 1);
  }

  Keys.onTabPressed: {
    root.setFocus(-1);
  }

  Kio.KRun {
    id: kRun
  }

  Keys.onEnterPressed: openApp();

  onClicked: openApp();

  function openApp() {
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
        active: highlighted
      }

      PlasmaComponents.Label {
        text: app ? app.name : ''
        width: cellSize
        elide: Text.ElideRight
        maximumLineCount: 1
        color: theme.textColor
        horizontalAlignment: Text.AlignHCenter
        font.bold: highlighted
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
        active: highlighted
      }

      PlasmaComponents.Label {
        text: app ? app.name : ''
        width: cellSize - rowIcon.width - parent.spacing
        elide: Text.ElideRight
        maximumLineCount: 1
        color: theme.textColor
        font.bold: highlighted
      }
    }
  }
}
