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

  Column {
    anchors.horizontalCenter: root.horizontalCenter
    spacing: 8
    PlasmaCore.IconItem {
      id: icon
      width: units.iconSizes.huge; height: width
      source: app ? app.iconName : ''
      anchors.horizontalCenter: parent.horizontalCenter
      active: hovered
    }

    PlasmaComponents.Label {
      id: label
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
