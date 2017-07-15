import QtQuick 2.5
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
  id: root

  property var app

  Text {
    text: 'hello'
  }

  Column {
    PlasmaCore.IconItem {
      id: icon
      width: units.iconSizes.huge; height: width
      source: app ? app['iconName'] : ''
    }

    PlasmaComponents.Label {
      id: label
      text: app ? app['name'] : ''
      width: cellSize
      elide: Text.ElideRight
      maximumLineCount: 1
      color: theme.textColor
      anchors.horizontalCenter: root.horizontalCenter
    }
  }
}
