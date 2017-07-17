import QtQuick 2.5
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

MouseArea {
  id: root

  property alias model: repeater.model
  property int cellSize: mainItem.dimensions.cellSize
  property bool isDash: mainItem.dimensions.id == 'dash'

  PlasmaExtras.ScrollArea {
    id: scrollArea

    horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
    verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff

    anchors {
      fill: parent
    }

    Grid {
      id: grid

      property int currentIndex: -1

      width: columns*(cellSize+spacing) - spacing
      columns: isDash ? Math.floor(((root.width) + spacing)/(cellSize + spacing)) : 1
      spacing: mainItem.dimensions.appSpacing
      x: (scrollArea.width - width)/2

      Repeater {
        id: repeater
        delegate: AppDelegate {
          id: appDelegate
          width: cellSize; height: mainItem.dimensions.cellHeight
          app: appsSource.data[model.modelData]
          // visible: app.isApp && app.display && app.iconName // TODO: filter in apps array
        }
      }
    }
  }
}
