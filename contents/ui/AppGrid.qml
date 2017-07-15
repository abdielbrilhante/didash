import QtQuick 2.5
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

Item {
  id: root

  PlasmaCore.DataSource {
    id: appsSource
    engine: 'apps'

    onSourceAdded: {
      connectSource(source);
    }

    onSourceRemoved: {
      disconnectSource(source);
    }
  }

  Component.onCompleted: {
    for (var i in appsSource.sources) {
      appsSource.sourceAdded(appsSource.sources[i]);
    }
  }

  property int cellSize: units.iconSizes.huge * 1.5

  PlasmaExtras.ScrollArea {
    id: scrollArea
    width: root.width
    height: root.height

    Grid {
      id: grid

      x: (scrollArea.width - grid.width)/2

      columns: Math.floor((root.width + spacing)/(cellSize + spacing))
      spacing: 24

      Repeater {
        id: repeater
        model: appsSource.sources
        delegate: Item {
          width: cellSize; height: width
          visible: appDelegate.visible

          AppDelegate {
            id: appDelegate
            width: cellSize
            app: appsSource.data[model.modelData]
          }
        }
      }
    }
  }
}
