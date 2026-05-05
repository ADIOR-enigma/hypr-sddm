pragma Singleton
import QtQuick
QtObject {
    id: root
    property color extractedAccent: "#A9C78F"
    property color keyBg:           Qt.hsva(extractedAccent.hsvHue, Math.max(0.30, extractedAccent.hsvSaturation * 0.55), 0.32, 1.0)
    property color keySpecial:      Qt.hsva(extractedAccent.hsvHue, Math.max(0.35, extractedAccent.hsvSaturation * 0.60), 0.26, 1.0)
    property color keyPress:        Qt.hsva(extractedAccent.hsvHue, Math.max(0.40, extractedAccent.hsvSaturation * 0.65), 0.44, 1.0)
    property color keyBorder:       Qt.hsva(extractedAccent.hsvHue, extractedAccent.hsvSaturation * 0.35, 0.50, 1.0)
    property color keyBorderStrong: Qt.hsva(extractedAccent.hsvHue, extractedAccent.hsvSaturation * 0.55, 0.70, 1.0)
}
