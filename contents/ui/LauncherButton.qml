import QtQuick 2.5
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

MouseArea {
  id: root

  property QtObject window: null

  Layout.fillHeight: true
  Layout.preferredWidth: label.implicitWidth + 32
  Layout.minimumWidth: Layout.preferredWidth
  Layout.maximumWidth: Layout.preferredWidth
  Layout.alignment: Qt.AlignHCenter

  property bool hovered: false
  hoverEnabled: true
  onEntered: hovered = true;
  onExited: hovered = false;

  Rectangle {
    height: parent.height
    width: 1
    color: theme.textColor
    x: label.width + 1
    opacity: 0.1
  }

  PlasmaComponents.Label {
    id: label
    text: window.visible ? '\uf111' : '\uf10c'
    anchors {
      fill: parent
      leftMargin: 0
    }
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    color: hovered ? theme.highlightColor : theme.textColor
  }

  Rectangle {
    width: 0
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
