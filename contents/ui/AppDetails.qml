import QtQuick 2.7
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.kio 1.0 as Kio

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
    property string currentPackage: 'Unavailable'

    onSourceAdded: {
      connectSource(source);
      currentSource = source;
    }

    onNewData: {
      if (data && data.stdout)
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
      topMargin: 36
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

  Item {
    anchors {
      top: name.bottom
      topMargin: 60
    }

    Text {
      property string dName: '<b>Name</b><br>' + app.name
      property string dComment: '<b>Description</b><br>' + (app.comment ? app.comment : 'None')
      property string dCat: '<b>Categories</b><br>' + app.categories
      property string dDisplay: '<b>Display</b><br>' + (app.display ? 'Yes' : 'No')
      property string dPackage: '<b>Package</b><br>' + pacmanSource.currentPackage

      width: details.width
      text: dName + '<br><br>' + dComment + '<br><br>' + dCat + '<br><br>' + dDisplay + '<br><br>' + dPackage
      color: theme.textColor
      wrapMode: Text.WordWrap
      lineHeight: 1.25
    }
  }

  Kio.KRun {
    id: kRun
  }

  function openApp() {
    kRun.openUrl(app.entryPath);
    rootWindow.toggle();
  }

  Row {
    id: actions

    anchors {
      bottom: parent.bottom
      bottomMargin: 12
    }

    width: parent.width

    DetailsAction {
      label: 'Go back'
      iconSource: '\uf060'
      onClicked: details.visible = false;
    }
    DetailsAction {
      label: 'Pin'
      iconSource: '\uf005'
      onClicked: console.log('Fav toggle')
    }
    DetailsAction {
      label: 'Run'
      iconSource: '\uf085'
      onClicked: openApp();
    }
    DetailsAction {
      label: plasmoid.configuration.isDash ? 'Menu' : 'Dash'
      iconSource: plasmoid.configuration.isDash ? '\uf00b' : '\uf00a'
      onClicked: plasmoid.configuration.isDash = !plasmoid.configuration.isDash
    }
  }
}
