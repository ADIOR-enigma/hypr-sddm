import QtQuick

Row {
    id: powerBarRoot
    spacing: 20
    height: 30
    
    property color textColor: "white"

    // Battery
    Row {
        id: batteryRow
        spacing: 5
        // Show if battery object exists and reports a valid percentage
        visible: typeof battery !== "undefined" && battery.percent !== undefined
        anchors.verticalCenter: parent.verticalCenter
        
        Text {
            id: batteryText
            text: (typeof battery !== "undefined" ? battery.percent : "0") + "%"
            color: textColor
            font.pixelSize: 14
            font.weight: Font.Medium
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            text: (typeof battery !== "undefined" && battery.charging) ? "󱐋" : "󰁹"
            color: textColor
            font.pixelSize: 18
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    // Keyboard Layout
    Text {
        text: (typeof keyboard !== "undefined" && keyboard.layouts[keyboard.currentLayout]) ? keyboard.layouts[keyboard.currentLayout].shortName : "US"
        color: textColor
        font.pixelSize: 14
        font.capitalization: Font.AllUppercase
        visible: typeof keyboard !== "undefined" && keyboard.layouts.length > 1
        anchors.verticalCenter: parent.verticalCenter
        
        MouseArea {
            anchors.fill: parent
            onClicked: {
                keyboard.currentLayout = (keyboard.currentLayout + 1) % keyboard.layouts.length
            }
        }
    }

    // Suspend
    Text {
        text: "󰤄"
        color: textColor
        font.pixelSize: 20
        anchors.verticalCenter: parent.verticalCenter
        MouseArea {
            anchors.fill: parent
            onClicked: sddm.suspend()
        }
    }

    // Restart
    Text {
        text: "󰑐"
        color: textColor
        font.pixelSize: 20
        anchors.verticalCenter: parent.verticalCenter
        MouseArea {
            anchors.fill: parent
            onClicked: sddm.reboot()
        }
    }

    // Shutdown
    Text {
        text: "󰐥"
        color: textColor
        font.pixelSize: 20
        anchors.verticalCenter: parent.verticalCenter
        MouseArea {
            anchors.fill: parent
            onClicked: sddm.powerOff()
        }
    }
}
