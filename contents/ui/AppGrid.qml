import QtQuick 2.5
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

MouseArea {
  id: root

  focus: true
  property var apps: []

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

    apps = appsSource.sources.sort(function compare(a, b) {
      return a.localeCompare(b);
    });
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
        model: apps ? apps : []
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
