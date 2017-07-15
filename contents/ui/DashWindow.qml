import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import QtGraphicalEffects 1.0

Window {
  id: rootWindow

  width: 1000; height: 600

  property string searching: searchField.text

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

    apps = sorted(appsSource.sources);
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

  onSearchingChanged: {
    if (searching) {
      appGrid.model = sorted(filter(apps, searchField.text.toLowerCase()));
    }
    else {
      appGrid.model = sorted(apps);
    }
  }

  function filter(arr, subs) {
    return arr.filter(function compare(str) {
      var app = appsSource.data[str];
      return app.name.toLowerCase().includes(subs);
    });
  }

  function sorted(arr) {
    return arr.sort(function compare(a, b) {
      return a.localeCompare(b);
    });
  }

  Column {
    anchors {
      fill: parent
      margins: 80
    }

    TextField {
      id: searchField
      anchors.horizontalCenter: parent.horizontalCenter
      focus: true
      placeholderText: "Search..."
      font.pointSize: 11
      style: TextFieldStyle {
        textColor: '#333'
        placeholderTextColor: '#444'
        background: Rectangle {
          radius: 4
          implicitWidth: 240
          implicitHeight: 32
          border.color: "#888"
          border.width: 1
        }
      }
    }

    AppGrid {
      id: appGrid
      anchors {
        top: searchField.bottom
        topMargin: 48
        bottom: parent.bottom
        left: parent.left
        right: parent.right
      }
      model: apps ? apps : []
    }
  }
}
