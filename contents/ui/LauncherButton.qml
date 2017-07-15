import QtQuick 2.5
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

MouseArea {
  id: root

  property QtObject window: null

  width: 128; height: parent.height
  Rectangle {
    id: rect
    anchors.fill: parent
  }

  onClicked: {
    window.toggle();
  }

  Component.onCompleted: {
    window = Qt.createQmlObject("DashWindow {}", root);
  }
}
