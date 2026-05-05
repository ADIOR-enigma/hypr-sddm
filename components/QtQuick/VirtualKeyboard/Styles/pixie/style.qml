import QtQuick
import QtQuick.VirtualKeyboard.Styles
import "../../../../"

KeyboardStyle {
    id: style

    readonly property color keyBg:          ThemeColors.keyBg
    readonly property color keyPress:       ThemeColors.keyPress
    readonly property color keySpecial:     ThemeColors.keySpecial
    readonly property color keyBorder:      ThemeColors.keyBorder
    readonly property color keyBorderStrong: ThemeColors.keyBorderStrong
    readonly property color accent:         ThemeColors.extractedAccent
    readonly property color textCol:        "#FFFFFF"
    readonly property color textDim:        "#8D9388"

    readonly property real margin:    Math.round(13 * scaleHint)
    readonly property real fontSize:  Math.round(72 * scaleHint)
    readonly property real fontSizeSm: Math.round(52 * scaleHint)

    keyboardDesignWidth:  2560
    keyboardDesignHeight: 800
    keyboardRelativeLeftMargin:   114 / keyboardDesignWidth
    keyboardRelativeRightMargin:  114 / keyboardDesignWidth
    keyboardRelativeTopMargin:     13 / keyboardDesignHeight
    keyboardRelativeBottomMargin:  86 / keyboardDesignHeight

    keyboardBackground: Rectangle { color: "transparent" }

    // Regular key
    keyPanel: KeyPanel {
        Rectangle {
            id: keyBg
            anchors.fill: parent
            anchors.margins: style.margin
            radius: 10
            color: style.keyBg
            border.color: style.keyBorder
            border.width: 1

            Text {
                anchors.fill: parent
                anchors.margins: style.margin
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: control.displayText
                color: style.textCol
                font.pixelSize: style.fontSize
                font.family: "sans-serif"
                fontSizeMode: Text.Fit
            }
        }
        states: State {
            name: "pressed"
            when: control.pressed
            PropertyChanges { target: keyBg; color: style.keyPress }
        }
    }

    // Backspace
    backspaceKeyPanel: KeyPanel {
        Rectangle {
            id: bsBg
            anchors.fill: parent
            anchors.margins: style.margin
            radius: 10
            color: style.keySpecial
            border.color: style.keyBorder
            border.width: 1

            Text {
                anchors.centerIn: parent
                text: "⌫"
                color: style.accent
                font.pixelSize: style.fontSize
            }
        }
        states: State {
            name: "pressed"
            when: control.pressed
            PropertyChanges { target: bsBg; color: style.keyPress }
        }
    }

    // Shift
    shiftKeyPanel: KeyPanel {
        Rectangle {
            id: shiftBg
            anchors.fill: parent
            anchors.margins: style.margin
            radius: 10
            color: style.keySpecial
            border.color: style.keyBorder
            border.width: 1
    
            Text {
                anchors.centerIn: parent
                text: "⇧"
                color: style.textCol
                font.pixelSize: style.fontSize
            }
        }
        states: State {
                name: "pressed"
                when: control.pressed
                PropertyChanges { target: shiftBg; color: style.keyPress }
        }
    }

    // Space
    spaceKeyPanel: KeyPanel {
        Rectangle {
            id: spaceBg
            anchors.fill: parent
            anchors.margins: style.margin
            radius: 10
            color: style.keyBg
            border.color: style.keyBorder
            border.width: 1

            Text {
                anchors.centerIn: parent
                text: "space"
                color: style.textDim
                font.pixelSize: style.fontSizeSm
            }
        }
        states: State {
            name: "pressed"
            when: control.pressed
            PropertyChanges { target: spaceBg; color: style.keyPress }
        }
    }

    // Enter
    enterKeyPanel: KeyPanel {
        Rectangle {
            id: enterBg
            anchors.fill: parent
            anchors.margins: style.margin
            radius: 10
            color: Qt.rgba(style.accent.r, style.accent.g, style.accent.b, 0.18)
            border.color: style.accent
            border.width: 1

            Text {
                anchors.centerIn: parent
                text: "↵"
                color: style.accent
                font.pixelSize: style.fontSize
            }
        }
        states: State {
            name: "pressed"
            when: control.pressed
            PropertyChanges { target: enterBg; color: Qt.darker(style.accent, 1.4) }
        }
    }

    // Symbol mode
    symbolKeyPanel: KeyPanel {
        Rectangle {
            id: symBg
            anchors.fill: parent
            anchors.margins: style.margin
            radius: 10
            color: style.keySpecial
            border.color: style.keyBorder
            border.width: 1

            Text {
                anchors.fill: parent
                anchors.margins: style.margin
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: control.displayText
                color: style.textDim
                font.pixelSize: style.fontSizeSm
                fontSizeMode: Text.Fit
            }
        }
        states: State {
            name: "pressed"
            when: control.pressed
            PropertyChanges { target: symBg; color: style.keyPress }
        }
    }

    // Hide
    hideKeyPanel: KeyPanel {
        Rectangle {
            id: hideBg
            anchors.fill: parent
            anchors.margins: style.margin
            radius: 10
            color: style.keySpecial
            border.color: style.keyBorder
            border.width: 1

            Text {
                anchors.centerIn: parent
                text: "▾"
                color: style.textDim
                font.pixelSize: style.fontSize
            }
        }
        states: State {
            name: "pressed"
            when: control.pressed
            PropertyChanges { target: hideBg; color: style.keyPress }
        }
    }

    // Mode key
    modeKeyPanel: KeyPanel {
        Rectangle {
            id: modeBg
            anchors.fill: parent
            anchors.margins: style.margin
            radius: 10
            color: style.keySpecial
            border.color: style.keyBorder
            border.width: 1

            Text {
                id: modeText
                anchors.fill: parent
                anchors.margins: style.margin
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: control.displayText
                color: style.textDim
                font.pixelSize: style.fontSizeSm
                fontSizeMode: Text.Fit
            }

            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: parent.height * 0.1
                width: parent.width * 0.2
                height: Math.round(4 * scaleHint)
                radius: 2
                color: style.accent
                visible: control.mode
            }
        }
        states: State {
            name: "pressed"
            when: control.pressed
            PropertyChanges { target: modeBg; color: style.keyPress }
        }
    }

    // Character preview
    characterPreviewMargin: 0
    characterPreviewDelegate: Item {
        property string text
        id: charPreview
        Rectangle {
            anchors.fill: parent
            color: style.keyPress
            radius: 12
            border.color: style.accent
            border.width: 1

            Text {
                anchors.fill: parent
                anchors.margins: Math.round(48 * scaleHint)
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: charPreview.text
                color: style.textCol
                font.pixelSize: Math.round(82 * scaleHint)
                fontSizeMode: Text.Fit
            }
        }
    }

    // Alt keys popup
    alternateKeysListItemWidth:  Math.round(99  * scaleHint)
    alternateKeysListItemHeight: Math.round(150 * scaleHint)

    alternateKeysListDelegate: Item {
        id: altItem
        width: alternateKeysListItemWidth
        height: alternateKeysListItemHeight

        Text {
            id: altText
            anchors.centerIn: parent
            text: model.text
            color: style.textDim
            font.pixelSize: style.fontSize
        }
        states: State {
            name: "current"
            when: altItem.ListView.isCurrentItem
            PropertyChanges { target: altText; color: style.textCol }
        }
    }

    alternateKeysListHighlight: Rectangle {
        color: style.keyPress
        radius: 10
    }

    alternateKeysListBackground: Rectangle {
        color: style.keySpecial
        border.color: style.keyBorder
        border.width: 1
        radius: 12
    }

    // Navigation highlight
    navigationHighlight: Rectangle {
        color: "transparent"
        border.color: style.accent
        border.width: Math.round(5 * scaleHint)
        radius: 6
    }
}
