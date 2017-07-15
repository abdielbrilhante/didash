import QtQuick 2.5
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

MouseArea {
  id: root

  property alias model: repeater.model
  property int cellSize: units.iconSizes.huge * 1.5

  PlasmaExtras.ScrollArea {
    id: scrollArea

    horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
    verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff

    anchors {
      fill: parent
    }

    Grid {
      id: grid

      width: columns*(cellSize+spacing) - spacing
      columns: Math.floor(((root.width) + spacing)/(cellSize + spacing))
      spacing: 24
      x: (scrollArea.width - width)/2

      Repeater {
        id: repeater
        delegate: AppDelegate {
          id: appDelegate
          width: cellSize; height: width
          app: appsSource.data[model.modelData]
          visible: app.isApp && app.display && app.iconName
        }
      }
    }
  }
}
