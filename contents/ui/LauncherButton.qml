import QtQuick 2.5
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

MouseArea {
  id: root

  property QtObject window: null

  // Layout.fillWidth: true
  // Layout.preferredHeight: label.implicitWidth + 32
  Layout.preferredWidth: parent.height + 4
  Layout.fillHeight: true
  Layout.minimumWidth: Layout.preferredWidth
  Layout.maximumWidth: Layout.preferredWidth
  Layout.alignment: Qt.AlignHCenter

  property bool hovered: false
  hoverEnabled: true
  onEntered: hovered = true;
  onExited: hovered = false;

  PlasmaComponents.Label {
    text: '\uf0c9'
    anchors.fill: parent
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
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
