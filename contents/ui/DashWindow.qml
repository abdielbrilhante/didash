import QtQuick 2.5
import QtQuick.Window 2.2
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Window {
  id: root

  width: 500; height: width

  visible: true

  function toggle() {
    if (visible)
      hide();
    else
      show();
  }
}
