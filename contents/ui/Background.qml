import QtQuick 2.5
import QtGraphicalEffects 1.0

Item {
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
}
