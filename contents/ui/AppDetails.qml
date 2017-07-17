import QtQuick 2.7
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
  id: details

  property var app: {
    "iconName": "firefox",
    "name": "",
    "description": "",
    "terminal": false,
    "categories": {},
    "entryPath": '/usr/share/applications/ranger.desktop'
  }

  PlasmaCore.DataSource {
    id: pacmanSource
    engine: 'executable'

    property string currentSource
    property string currentPackage

    onSourceAdded: {
      connectSource(source);
      currentSource = source;
    }

    onNewData: {
      currentPackage = data.stdout.split('is owned by')[1];
    }
  }

  onVisibleChanged: {
    if (visible) {
      pacmanSource.sourceAdded('pacman -Qo ' + app.entryPath)
    }
  }

  PlasmaCore.IconItem {
    id: icon
    source: app.iconName
    width: units.iconSizes.enormous*1.2; height: width
    anchors {
      horizontalCenter: parent.horizontalCenter
      top: parent.top
      topMargin: 24
    }
  }

  Text {
    id: name
    text: app.name
    color: theme.textColor
    font.pointSize: 14
    font.bold: true
    anchors {
      horizontalCenter: parent.horizontalCenter
      top: icon.bottom
      topMargin: 12
    }
  }

  Column {
    anchors {
      top: name.bottom
      topMargin: 60
    }

    spacing: 14
    Text {
      text: '<b>Name</b><br>' + app.name
      color: theme.textColor
      lineHeight: 1.25
    }
    Text {
      width: details.width
      text: '<b>Description</b><br>' + (app.comment ? app.comment : 'None')
      color: theme.textColor
      wrapMode: Text.WordWrap
      lineHeight: 1.25
    }
    Text {
      width: details.width
      text: '<b>Categories</b><br>' + app.categories
      color: theme.textColor
      lineHeight: 1.25
      wrapMode: Text.WordWrap
    }
    Text {
      text: '<b>Display</b><br>' + (app.display ? 'Yes' : 'No')
      color: theme.textColor
      lineHeight: 1.25
    }

    Text {
      text: '<b>Package</b><br>' + (pacmanSource.currentSource ? pacmanSource.currentPackage : 'Not available')
      color: theme.textColor
      lineHeight: 1.25
    }
  }
}
