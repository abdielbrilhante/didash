import QtQuick 2.7
import org.kde.plasma.core 2.0 as PlasmaCore

MouseArea {
  width: parent.width/4; height: width
  property alias iconSource: icon.text
  property alias label: iconLabel.text

  hoverEnabled: true
  property bool hovered
  onEntered: hovered = true;
  onExited: hovered = false;

  Text {
    id: icon
    font.pointSize: 20
    anchors.horizontalCenter: parent.horizontalCenter
    color: mainItem.globalTextColor
  }

  Text {
    id: iconLabel
    text: 'This is label'
    width: parent.width
    color: mainItem.globalTextColor
    horizontalAlignment: Text.AlignHCenter
    font.pointSize: 9
    font.weight: hovered ? Font.Bold : Font.Normal
    anchors {
      top: icon.bottom
      topMargin: 4
    }
  }
}
