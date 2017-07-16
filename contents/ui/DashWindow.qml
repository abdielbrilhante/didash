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
  x: 0

  visible: false
  // backgroundHints: PlasmaCore.Types.NoBackground
  hideOnWindowDeactivate: true

  function toggle() {
    if (visible)
      hide();
    else
      show();

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

      if (app.name.toLowerCase().includes(subs)) return true;

      for (var key in app.categories) {
        var cat = app.categories[key];
        if (cat.toLowerCase().includes(subs)) {
          return true;
        }
      }

      return false;
    });
  }

  function sorted(arr) {
    return arr.sort(function compare(a, b) {
      return appsSource.data[a].name.localeCompare(appsSource.data[b].name);
    });
  }

  Item {
    id: mainItem

    property QtObject dimensions: plasmoid.configuration.isDash ? dashDimensions : menuDimensions

    width: dimensions.width
    height: dimensions.height

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

    Rectangle {
      // anchors.fill: parent
      color: theme.backgroundColor
    }

    Background {
      id: background
      anchors.fill: parent
      visible: false
    }

    QtObject {
      id: menuDimensions
      property string id: 'menu'
      property int searchBoxSpacing: topMargin
      property int topMargin: 16
      property int bottomMargin: 0
      property int leftMargin: 16
      property int rightMargin: 16
      property int width: 300
      property int height: Screen.desktopAvailableHeight
      property int cellSize: width - leftMargin - rightMargin
      property int cellHeight: units.iconSizes.smallMedium * 1.5
      property int appSpacing: 4
    }

    QtObject {
      id: dashDimensions
      property string id: 'dash'
      property int searchBoxSpacing: 68
      property int topMargin: mainItem.height/5
      property int bottomMargin: mainItem.height/5
      property int leftMargin: mainItem.width/5
      property int rightMargin: mainItem.width/5
      property int width: Screen.desktopAvailableWidth
      property int height: Screen.desktopAvailableHeight
      property int cellSize: units.iconSizes.huge * 1.5
      property int cellHeight: units.iconSizes.huge * 1.5
      property int appSpacing: 24
    }

    Item {
      id: uiElements
      anchors {
        fill: parent
        topMargin: mainItem.dimensions.topMargin
        bottomMargin: mainItem.dimensions.bottomMargin
        rightMargin: mainItem.dimensions.rightMargin
        leftMargin: mainItem.dimensions.leftMargin
      }

      TextField {
        id: searchField

        property bool isDash: mainItem.dimensions.id == 'dash'

        anchors {
          horizontalCenter: parent.horizontalCenter
        }

        width: isDash ? 240 : uiElements.width

        focus: true
        placeholderText: 'Search...'
        font.pointSize: 11
        style: TextFieldStyle {
          textColor: theme.textColor
          placeholderTextColor: '#ddd'
          background: Rectangle {
            color: Qt.rgba(0.5, 0.5, 0.5, 0.03)
            radius: 0
            implicitWidth: searchField.width
            implicitHeight: 36
            border.color: Qt.rgba(0.5, 0.5, 0.5, 0.2)
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
          topMargin: mainItem.dimensions.searchBoxSpacing
          bottom: parent.bottom
          left: parent.left
          right: parent.right
        }
        model: apps ? apps : []
      }
    }
  }
}
