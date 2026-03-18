import QtQuick

Item {

    id: clock

    property string backgroundSource: ""

    property color defaultHoursColor: "#AED68A"

    property color defaultMinutesColor: "#D4E4BC"

    property string fontFamily: "Google Sans Flex Freeze"



    // This property automatically converts the hex string from config to a valid color object

    property color baseAccent: config.accentColor



    // Dynamic Colors

    property color smartHoursColor: defaultHoursColor

    property color smartMinutesColor: defaultMinutesColor



    // Helper to get individual digits for perfect alignment

    property string timeStr: Qt.formatTime(new Date(), "HHmm")



    function updateColors() {

        // Use the baseAccent property which QML has already parsed correctly

        var base = clock.baseAccent;

        

        // Debug check (will show in sddm-greeter output)

        // console.log("Clock Base Color: " + base + " Hue: " + base.hsvHue);



        // Material 3 logic: 

        // Hours = Vibrant/Deep version of accent

        // Minutes = Soft/Pastel version of accent

        

                if (base.hsvValue < 0.3) {

        

                    // Extremely dark: Shift towards light theme for clock

        

                    clock.smartHoursColor = Qt.hsva(base.hsvHue, 0.6, 0.9, 1.0);

        

                    clock.smartMinutesColor = Qt.hsva(base.hsvHue, 0.35, 0.85, 1.0);

        

                } else if (base.hsvValue > 0.8 && base.hsvSaturation < 0.2) {

        

                    // Very bright/white-ish: Darken slightly to keep it readable

        

                    clock.smartHoursColor = Qt.hsva(base.hsvHue, 0.8, 0.7, 1.0);

        

                    clock.smartMinutesColor = Qt.hsva(base.hsvHue, 0.5, 0.75, 1.0);

        

                        } else {

        

                            // Standard Range:

        

                            // Hours: Bold & Vibrant

        

                            clock.smartHoursColor = Qt.hsva(base.hsvHue, Math.min(1.0, base.hsvSaturation * 1.3), 0.95, 1.0);

        

                            // Minutes: Middle ground - brighter than before, but still distinctly tinted

        

                            clock.smartMinutesColor = Qt.hsva(base.hsvHue, Math.min(1.0, base.hsvSaturation * 0.75), 0.92, 1.0);

        

                        }

    }



    onBaseAccentChanged: updateColors()

    Component.onCompleted: updateColors()



    Row {
        anchors.centerIn: parent
        spacing: 0 // Resetting horizontal gap
 // Adjust this for horizontal gap between HH and mm columns

        // First Column: Tens digit of Hour over Tens digit of Minute
        Column {
            spacing: -130 // Ultra-compact vertical overlap
            Text {
                text: clock.timeStr.charAt(0)
                color: clock.smartHoursColor
                font.pixelSize: 200
                font.family: clock.fontFamily
                font.weight: Font.Medium
                width: 130 // Ensures digit 1 and digit 3 are centered in same space
                horizontalAlignment: Text.AlignHCenter
                antialiasing: true
            }
            Text {
                text: clock.timeStr.charAt(2)
                color: clock.smartMinutesColor
                font.pixelSize: 200
                font.family: clock.fontFamily
                font.weight: Font.Medium
                width: 130
                horizontalAlignment: Text.AlignHCenter
                antialiasing: true
            }
        }

        // Second Column: Ones digit of Hour over Ones digit of Minute
        Column {
            spacing: -130
            Text {
                text: clock.timeStr.charAt(1)
                color: clock.smartHoursColor
                font.pixelSize: 200
                font.family: clock.fontFamily
                font.weight: Font.Medium
                width: 130
                horizontalAlignment: Text.AlignHCenter
                antialiasing: true
            }
            Text {
                text: clock.timeStr.charAt(3)
                color: clock.smartMinutesColor
                font.pixelSize: 200
                font.family: clock.fontFamily
                font.weight: Font.Medium
                width: 130
                horizontalAlignment: Text.AlignHCenter
                antialiasing: true
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            clock.timeStr = Qt.formatTime(new Date(), "HHmm")
        }
    }
}
