import QtQuick 2.5
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

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

  Grid {
    id: grid

    // TODO: Margens e outras âncoras
    anchors {
      horizontalCenter: parent.horizontalCenter
    }

    columns: Math.floor((parent.width + spacing)/(cellSize + spacing))
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
