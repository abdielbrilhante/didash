import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

import org.kde.plasma.core 2.0 as PlasmaCore

Item {
  property alias cfg_isDash: isDash.checked

  CheckBox {
    id: isDash
  }
}
