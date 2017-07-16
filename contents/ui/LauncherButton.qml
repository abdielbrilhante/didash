import QtQuick 2.5
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

MouseArea {
  id: root

  property QtObject window: null

  Layout.fillHeight: true
  Layout.preferredWidth: label.width + 32
  Layout.minimumWidth: Layout.preferredWidth
  Layout.maximumWidth: Layout.preferredWidth

  property bool hovered: false
  hoverEnabled: true
  onEntered: hovered = true;
  onExited: hovered = false;

  Rectangle {
    anchors.fill: parent
    color: theme.textColor
    visible: hovered
  }

  PlasmaComponents.Label {
    id: label
    text: 'Apps'
    anchors.centerIn: parent
    color: hovered ? theme.backgroundColor : theme.textColor
  }

  Rectangle {
    width: 1
    height: 16
    color: theme.textColor
    visible: !hovered
    anchors {
      verticalCenter: parent.verticalCenter
      left: parent.right
    }
  }

  onClicked: {
    window.toggle();
  }

  Component.onCompleted: {
    window = Qt.createQmlObject("DashWindow {}", root);
    plasmoid.activated.connect(function() {
      window.toggle()
    });
  }
}
