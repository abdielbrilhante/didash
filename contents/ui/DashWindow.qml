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
  hideOnWindowDeactivate: true
  backgroundHints: PlasmaCore.Types.NoBackground

  function reset() {
    searchField.text = '';
    appDetails.visible = false;
  }

  function toggle() {
    if (visible)
      hide();
    else
      show();

    reset();
  }

  onWindowDeactivated: {
    reset();
  }

  property var apps: []
  property var favorites: []

  Component.onCompleted: {
    for (var i = 0; i < plasmoid.configuration.favorites.length; i++) {
      favorites.push(plasmoid.configuration.favorites[i]);
    }
  }

  Component.onDestruction: {
    plasmoid.configuration.favorites = favorites;
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

  function concatenate(a, b) {
    if (!a.length && !b.length) return [];
    if (!a.length) return b;
    if (!b.length) return a;

    var f = b.filter(function check(item) {
      return a.indexOf(item) < 0;
    });

    var c = a.concat(f);

    return c;
  }

  Item {
    id: mainItem

    Keys.onEscapePressed: {
      rootWindow.toggle();
    }

    property QtObject dimensions: plasmoid.configuration.isDash ? dashDimensions : menuDimensions
    property color globalTextColor: {
      if (!appDetails.visible) return theme.textColor;

      var bColor = appDetails.background;

      var tLum = 0.2126*theme.textColor.r + 0.7152*theme.textColor.g + 0.0722*theme.textColor.b + 0.05;
      var bLum = 0.2126*bColor.r + 0.7152*bColor.g + 0.0722*bColor.b + 0.05;

      var contrast = tLum > bLum ? (tLum/bLum) : (bLum/tLum);

      if (contrast < 1.5) return theme.backgroundColor;
      return theme.textColor;
    }

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

      apps = sorted(appsSource.sources.filter(function check(key) {
        var app = appsSource.data[key];
        return (app.isApp && app.display && app.iconName);
      }));
    }

    Rectangle {
      id: opaqueBackground
      color: theme.backgroundColor
      anchors.fill: parent
      opacity: 0.9
    }

    Rectangle {
      id: background
      anchors.fill: parent
      color: appDetails.background
      opacity: appDetails.visible ? 1.0 : 0.0

      Behavior on opacity {
        NumberAnimation { duration: 300 }
      }

      Behavior on color {
        ColorAnimation { duration: 150 }
      }
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
        visible: !appDetails.visible
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



        Keys.onDownPressed: {
          appGrid.setFocus(0, 0, 0);
        }
      }

      AppGrid {
        id: appGrid
        visible: !appDetails.visible
        anchors {
          top: searchField.bottom
          topMargin: mainItem.dimensions.searchBoxSpacing
          bottom: parent.bottom
          left: parent.left
          right: parent.right
        }
        model: searching ? filter(concatenate(favorites, apps), searchField.text.toLowerCase()) : concatenate(favorites, apps)
      }

      AppDetails {
        id: appDetails
        anchors {
          fill: parent
        }
        visible: false
      }
    }
  }
}
