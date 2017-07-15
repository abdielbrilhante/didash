import QtQuick 2.5
import QtQuick.Window 2.2
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import QtGraphicalEffects 1.0

Window {
  id: rootWindow

  width: 1000; height: 600

  visible: false
  color: Qt.rgba(0.0, 0.0, 0.0, 1.0)
  flags: Qt.FramelessWindowHint

  function toggle() {
    if (visible)
      hide();
    else
      showFullScreen();
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

  AppGrid {
    id: appGrid
    anchors.fill: parent
  }
}
