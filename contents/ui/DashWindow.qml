import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import QtGraphicalEffects 1.0

Window {
  id: rootWindow

  width: 1000; height: 600

  visible: true
  color: Qt.rgba(0.0, 0.0, 0.0, 1.0)
  flags: Qt.FramelessWindowHint

  function toggle() {
    if (visible)
      hide();
    else
      showFullScreen();
  }

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

    apps = appsSource.sources;
  }

  Image {
    id: wp
    source: '/home/diello/.local/share/wallpapers/montana.jpg'
    anchors.fill: parent
    visible: false
  }

  GaussianBlur {
    id: blur
    source: wp
    anchors.fill: wp
    samples: 81
  }

  Column {
    anchors {
      fill: parent
      margins: 80
    }

    AppGrid {
      id: appGrid
      anchors {
        top: searchField.bottom
        bottom: parent.bottom
        left: parent.left
        right: parent.right
      }
      Rectangle {
        id: rect
        anchors.fill: parent
        opacity: 0.5
      }
      model: apps ? apps.sort(function compare(a, b) {
        return a.localeCompare(b);
      }) : []
    }
  }
}
