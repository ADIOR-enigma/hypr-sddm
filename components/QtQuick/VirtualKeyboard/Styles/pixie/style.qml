import QtQuick
import QtQuick.VirtualKeyboard.Styles
import "../../../../"

KeyboardStyle {
    id: style

    keyboardDesignWidth:  2560
    keyboardDesignHeight: 800
    keyboardRelativeLeftMargin:   114 / keyboardDesignWidth
    keyboardRelativeRightMargin:  114 / keyboardDesignWidth
    keyboardRelativeTopMargin:     13 / keyboardDesignHeight
    keyboardRelativeBottomMargin:  86 / keyboardDesignHeight

    keyboardBackground: Rectangle { color: "transparent" }

    keyPanel: KeyPanel {
        Rectangle {
            id: keyBg
            anchors.fill: parent
            anchors.margins: Math.round(13 * scaleHint)
            radius: 10
            color: ThemeColors.keySpecial
            border.color: ThemeColors.keyBorder
            border.width: 1

            Text {
                anchors.fill: parent
                anchors.margins: Math.round(13 * scaleHint)
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: control.displayText
                color: ThemeColors.extractedAccent
                font.pixelSize: Math.round(58 * scaleHint)
                font.family: "sans-serif"
                fontSizeMode: Text.Fit
            }
        }
        states: State {
            name: "pressed"
            when: control.pressed
            PropertyChanges { target: keyBg; color: ThemeColors.keyPress }
        }
    }

    backspaceKeyPanel: KeyPanel {
        Rectangle {
            id: bsBg
            anchors.fill: parent
            anchors.margins: Math.round(13 * scaleHint)
            radius: 10
            color: ThemeColors.keySpecial
            border.color: ThemeColors.keyBorder
            border.width: 1

            Text {
                anchors.centerIn: parent
                text: "⌫"
                color: ThemeColors.extractedAccent
                font.pixelSize: Math.round(42 * scaleHint)
            }
        }
        states: State {
            name: "pressed"
            when: control.pressed
            PropertyChanges { target: bsBg; color: ThemeColors.keyPress }
        }
    }

    shiftKeyPanel: KeyPanel {
        Rectangle {
            id: shiftBg
            anchors.fill: parent
            anchors.margins: Math.round(13 * scaleHint)
            radius: 10
            color: ThemeColors.keySpecial
            border.color: ThemeColors.keyBorder
            border.width: 1

            Text {
                anchors.centerIn: parent
                text: "⇪"
                color: ThemeColors.extractedAccent
                font.pixelSize: Math.round(70 * scaleHint)
            }
        }
        states: State {
            name: "pressed"
            when: control.pressed
            PropertyChanges { target: shiftBg; color: ThemeColors.keyPress }
        }
    }

    spaceKeyPanel: KeyPanel {
        Rectangle {
            id: spaceBg
            anchors.fill: parent
            anchors.margins: Math.round(13 * scaleHint)
            radius: 10
            color: ThemeColors.keySpecial
            border.color: ThemeColors.keyBorder
            border.width: 1

            Text {
                anchors.centerIn: parent
                text: "space"
                color: ThemeColors.extractedAccent
                font.pixelSize: Math.round(42 * scaleHint)
            }
        }
        states: State {
            name: "pressed"
            when: control.pressed
            PropertyChanges { target: spaceBg; color: ThemeColors.keyPress }
        }
    }

    enterKeyPanel: KeyPanel {
        Rectangle {
            id: enterBg
            anchors.fill: parent
            anchors.margins: Math.round(13 * scaleHint)
            radius: 10
            color: Qt.rgba(ThemeColors.extractedAccent.r, ThemeColors.extractedAccent.g, ThemeColors.extractedAccent.b, 0.18)
            border.color: ThemeColors.extractedAccent
            border.width: 1

            Text {
                anchors.centerIn: parent
                text: "↵"
                color: ThemeColors.extractedAccent
                font.pixelSize: Math.round(58 * scaleHint)
            }
        }
        states: State {
            name: "pressed"
            when: control.pressed
            PropertyChanges { target: enterBg; color: Qt.darker(ThemeColors.extractedAccent, 1.4) }
        }
    }

    symbolKeyPanel: KeyPanel {
        Rectangle {
            id: symBg
            anchors.fill: parent
            anchors.margins: Math.round(13 * scaleHint)
            radius: 10
            color: ThemeColors.keySpecial
            border.color: ThemeColors.keyBorder
            border.width: 1

            Text {
                anchors.fill: parent
                anchors.margins: Math.round(13 * scaleHint)
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: control.displayText
                color: ThemeColors.extractedAccent
                font.pixelSize: Math.round(42 * scaleHint)
                fontSizeMode: Text.Fit
            }
        }
        states: State {
            name: "pressed"
            when: control.pressed
            PropertyChanges { target: symBg; color: ThemeColors.keyPress }
        }
    }

    hideKeyPanel: KeyPanel {
        Rectangle {
            id: hideBg
            anchors.fill: parent
            anchors.margins: Math.round(13 * scaleHint)
            radius: 10
            color: ThemeColors.keySpecial
            border.color: ThemeColors.keyBorder
            border.width: 1

            Text {
                anchors.centerIn: parent
                text: "▾"
                color: ThemeColors.extractedAccent
                font.pixelSize: Math.round(58 * scaleHint)
            }
        }
        states: State {
            name: "pressed"
            when: control.pressed
            PropertyChanges { target: hideBg; color: ThemeColors.keyPress }
        }
    }

    modeKeyPanel: KeyPanel {
        Rectangle {
            id: modeBg
            anchors.fill: parent
            anchors.margins: Math.round(13 * scaleHint)
            radius: 10
            color: ThemeColors.keySpecial
            border.color: ThemeColors.keyBorder
            border.width: 1

            Text {
                id: modeText
                anchors.fill: parent
                anchors.margins: Math.round(13 * scaleHint)
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: control.displayText
                color: ThemeColors.extractedAccent
                font.pixelSize: Math.round(42 * scaleHint)
                fontSizeMode: Text.Fit
            }

            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: parent.height * 0.1
                width: parent.width * 0.2
                height: Math.round(4 * scaleHint)
                radius: 2
                color: ThemeColors.extractedAccent
                visible: control.mode
            }
        }
        states: State {
            name: "pressed"
            when: control.pressed
            PropertyChanges { target: modeBg; color: ThemeColors.keyPress }
        }
    }

    characterPreviewMargin: 0
    characterPreviewDelegate: Item {
        property string text
        id: charPreview
        Rectangle {
            anchors.fill: parent
            color: ThemeColors.keyPress
            radius: 12
            border.color: ThemeColors.extractedAccent
            border.width: 1

            Text {
                anchors.fill: parent
                anchors.margins: Math.round(48 * scaleHint)
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: charPreview.text
                color: "#FFFFFF"
                font.pixelSize: Math.round(66 * scaleHint)
                fontSizeMode: Text.Fit
            }
        }
    }

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
            color: ThemeColors.keyBorderStrong
            font.pixelSize: Math.round(58 * scaleHint)
        }
        states: State {
            name: "current"
            when: altItem.ListView.isCurrentItem
            PropertyChanges { target: altText; color: ThemeColors.extractedAccent }
        }
    }

    alternateKeysListHighlight: Rectangle {
        color: ThemeColors.keyPress
        radius: 10
    }

    alternateKeysListBackground: Rectangle {
        color: ThemeColors.keySpecial
        border.color: ThemeColors.keyBorder
        border.width: 1
        radius: 12
    }

    navigationHighlight: Rectangle {
        color: "transparent"
        border.color: ThemeColors.extractedAccent
        border.width: Math.round(5 * scaleHint)
        radius: 6
    }
}
