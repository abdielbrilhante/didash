import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

PlasmaCore.Dialog {
  id: rootWindow

  property string searching: searchField.text

  visible: false
  backgroundHints: PlasmaCore.Types.NoBackground

  function toggle() {
    if (visible)
      hide();
    else
      showFullScreen();

    searchField.text = '';
  }

  property var apps: []

  onSearchingChanged: {
    if (searching) {
      appGrid.model = sorted(filter(apps, searchField.text.toLowerCase()));
    }
    else {
      appGrid.model = sorted(apps);
    }
  }

  Keys.onEscapePressed: {
    toggle();
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

  Item {
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight

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

    Background {
      id: background
      anchors.fill: parent
    }

    Item {
      anchors {
        fill: parent
        topMargin: parent.height/5
        bottomMargin: parent.height/5
        rightMargin: parent.width/5
        leftMargin: parent.width/5
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

        Keys.onEscapePressed: {
          rootWindow.toggle();
        }
      }

      AppGrid {
        id: appGrid
        anchors {
          top: searchField.bottom
          topMargin: 72
          bottom: parent.bottom
          left: parent.left
          right: parent.right
        }
        model: apps ? apps : []
      }
    }
  }
}
