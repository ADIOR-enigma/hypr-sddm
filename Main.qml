/**
 * Pixie SDDM
 * A minimal SDDM theme inspired by Pixel UI and Material Design 3.
 * Author: xCaptaiN09
 * GitHub: https://github.com/xCaptaiN09/pixie-sddm
 */
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.VirtualKeyboard
import QtQuick.VirtualKeyboard.Settings
import "components"

Rectangle {
    id: container
    width: 1920
    height: 1080
    color: config.backgroundColor
    focus: !loginState.visible

    // User & Session Logic (Root Level)
    property int userIndex: 0
    property int sessionIndex: 0
    property bool isLoggingIn: false
    property bool showVirtualKeyboard: false

    Component.onCompleted: {
        if (typeof userModel !== "undefined" && userModel.lastIndex >= 0)
            userIndex = userModel.lastIndex;
        if (typeof sessionModel !== "undefined" && sessionModel.lastIndex >= 0)
            sessionIndex = sessionModel.lastIndex;
    }

    function cleanName(name) {
        if (!name)
            return "";
        var s = name.toString();
        if (s.endsWith("/"))
            s = s.substring(0, s.length - 1);
        if (s.indexOf("/") !== -1)
            s = s.substring(s.lastIndexOf("/") + 1);
        if (s.indexOf(".desktop") !== -1)
            s = s.substring(0, s.indexOf(".desktop"));
        s = s.replace(/[-_]/g, ' ');
        return s.charAt(0).toUpperCase() + s.slice(1);
    }

    function doLogin() {
        if (!loginState.visible || isLoggingIn)
            return;

        var user = "";
        if (typeof userModel !== "undefined" && userModel.count > 0) {
            var idx = container.userIndex;
            if (idx < 0 || idx >= userModel.count)
                idx = 0;

            var edit = userModel.data(userModel.index(idx, 0), Qt.EditRole);
            var nameRole = userModel.data(userModel.index(idx, 0), Qt.UserRole + 1);
            var display = userModel.data(userModel.index(idx, 0), Qt.DisplayRole);

            user = edit ? edit.toString() : (nameRole ? nameRole.toString() : (display ? display.toString() : ""));
        }

        if (!user || user === "" || user === "User") {
            user = sddm.lastUser;
        }

        if (!user && typeof userModel !== "undefined" && userModel.count > 0) {
            var firstEdit = userModel.data(userModel.index(0, 0), Qt.EditRole);
            user = firstEdit ? firstEdit.toString() : "";
        }

        if (!user)
            return;

        container.isLoggingIn = true;
        var pass = passwordField.text;
        var sess = container.sessionIndex;

        if (typeof sessionModel !== "undefined") {
            if (sess < 0 || sess >= sessionModel.count)
                sess = 0;
        } else {
            sess = 0;
        }

        console.log("Pixie SDDM: Attempting login for user [" + user + "] session index [" + sess + "]");
        sddm.login(user.trim(), pass, sess);
        loginTimeout.start();
    }

    Timer {
        id: loginTimeout
        interval: 5000
        onTriggered: container.isLoggingIn = false
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            container.isLoggingIn = false;
            loginTimeout.stop();
            loginState.isError = true;
            shakeAnimation.start();
            passwordField.text = "";
            passwordField.forceActiveFocus();
        }
        function onLoginSucceeded() {
            loginTimeout.stop();
        }
    }

    // Dynamic Color Extraction
    property color extractedAccent: "#A9C78F"
    property color cardSurface: "#161814"
    property color controlSurface: "#23261F"
    property color controlSurfaceActive: "#31342D"
    property color controlBorder: "#343830"
    property color cardBorder: "#2B2E27"

    Timer {
        id: colorDelay
        interval: 1000 // Give it a full second
        repeat: true   // Keep trying until we succeed
        running: backgroundImage.status === Image.Ready && !colorExtractor.processed
        onTriggered: colorExtractor.requestPaint()
    }

    Canvas {
        id: colorExtractor
        width: 60
        height: 60
        x: -100
        y: -100 // Off-screen but "visible" for reliable rendering
        z: -1
        renderTarget: Canvas.Image
        property bool processed: false

        onPaint: {
            var ctx = getContext("2d");
            var res = 60;
            ctx.clearRect(0, 0, res, res);
            ctx.drawImage(backgroundImage, 0, 0, res, res);
            var imgData = ctx.getImageData(0, 0, res, res).data;

            if (!imgData || imgData.length === 0)
                return;

            // 36 Buckets (10 degrees each) for high resolution hue detection
            var histogram = new Array(36).fill(0);
            var sampleColors = new Array(36).fill(null);
            var vibrantFound = false;

            for (var i = 0; i < imgData.length; i += 4) {
                var r = imgData[i] / 255;
                var g = imgData[i + 1] / 255;
                var b = imgData[i + 2] / 255;
                var pCol = Qt.rgba(r, g, b, 1.0);

                // Filter: Must be colorful and not too dark
                if (pCol.hsvSaturation > 0.3 && pCol.hsvValue > 0.25) {
                    var h = pCol.hsvHue * 360;
                    if (h < 0)
                        continue;

                    var bIdx = Math.floor(h / 10) % 36;
                    // Weight: Focus on saturation to find the "intended" accent
                    var weight = pCol.hsvSaturation * pCol.hsvValue;
                    histogram[bIdx] += weight;

                    if (!sampleColors[bIdx] || weight > (sampleColors[bIdx].hsvSaturation * sampleColors[bIdx].hsvValue)) {
                        sampleColors[bIdx] = pCol;
                    }
                    vibrantFound = true;
                }
            }

            if (!vibrantFound)
                return; // Keep trying

            // Merge Red wrap (350-360 and 0-10)
            histogram[0] += histogram[35];

            // Find the most frequent vibrant hue (The Mode)
            var maxCount = -1;
            var winnerIdx = -1;
            for (var j = 0; j < 35; j++) {
                if (histogram[j] > maxCount) {
                    maxCount = histogram[j];
                    winnerIdx = j;
                }
            }

            if (winnerIdx !== -1 && sampleColors[winnerIdx]) {
                var finalColor = sampleColors[winnerIdx];
                var h = finalColor.hsvHue;
                // Slightly decreased saturation for a more professional look
                var s = Math.max(0.35, Math.min(0.55, finalColor.hsvSaturation * 0.9));
                container.extractedAccent = Qt.hsva(h, s, 0.95, 1.0);
                console.log("Pixie SDDM: SUCCESS! Extracted Hue: " + (h * 360).toFixed(0) + "°");
                processed = true; // Stop the timer
            }
        }
    }

    Connections {
        target: backgroundImage
        function onStatusChanged() {
            if (backgroundImage.status === Image.Ready) {
                colorExtractor.processed = false;
                colorDelay.start();
            }
        }
    }

    FontLoader {
        id: fontRegular
        source: "assets/fonts/FlexRounded-R.ttf"
    }
    FontLoader {
        id: fontMedium
        source: "assets/fonts/FlexRounded-M.ttf"
    }
    FontLoader {
        id: fontBold
        source: "assets/fonts/FlexRounded-B.ttf"
    }

    Image {
        id: backgroundImage
        source: config.background
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
    }

    // High-Quality Standalone Blur (Qt6 Native)
    MultiEffect {
        id: backgroundBlur
        anchors.fill: parent
        source: backgroundImage
        blurEnabled: true
        blur: loginState.visible ? 1.0 : 0.0
        opacity: loginState.visible ? 1.0 : 0.0
        autoPaddingEnabled: false

        Behavior on opacity {
            NumberAnimation {
                duration: 400
                easing.type: Easing.InOutQuad
            }
        }
        Behavior on blur {
            NumberAnimation {
                duration: 400
                easing.type: Easing.InOutQuad
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: loginState.visible ? 0.6 : 0.4
        Behavior on opacity {
            NumberAnimation {
                duration: 400
            }
        }
    }

    Rectangle {
        id: sessionSwitcherBottomLeft
        width: 210
        height: 40
        anchors {
            left: parent.left
            bottom: parent.bottom
            leftMargin: 40
            bottomMargin: 32
        }
        z: 100
        visible: loginState.visible
        opacity: loginState.visible && colorExtractor.processed ? 1 : 0

        color: (sessionSwitcherArea.pressed || sessionPopup.opened) ? container.controlSurfaceActive : container.controlSurface
        radius: 20
        border.width: 1
        border.color: (sessionSwitcherArea.pressed || sessionPopup.opened) ? container.extractedAccent : container.controlBorder

        scale: sessionSwitcherArea.pressed ? 0.97 : 1.0
        Behavior on scale {
            NumberAnimation {
                duration: 100
            }
        }
        Behavior on opacity {
            NumberAnimation {
                duration: 200
            }
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            spacing: 6

            Text {
                text: "󰟀"
                color: container.extractedAccent
                font.pixelSize: 14
                Layout.alignment: Qt.AlignVCenter
            }

            Text {
                Layout.fillWidth: true
                text: {
                    if (typeof sessionModel !== "undefined" && sessionModel.count > 0) {
                        var idx = container.sessionIndex;
                        var modelIdx = sessionModel.index(idx, 0);
                        var n = sessionModel.data(modelIdx, Qt.UserRole + 4);
                        var f = sessionModel.data(modelIdx, Qt.UserRole + 2);
                        var d = sessionModel.data(modelIdx, Qt.DisplayRole);
                        var finalName = n ? n.toString() : (f ? f.toString() : (d ? d.toString() : "Session " + (idx + 1)));
                        return cleanName(finalName) + (sessionModel.count > 1 ? " ▾" : "");
                    }
                    return "Hyprland";
                }
                color: "white"
                font.pixelSize: 12
                font.weight: Font.Medium
                font.family: config.fontFamily
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
        }

        MouseArea {
            id: sessionSwitcherArea
            anchors.fill: parent
            enabled: typeof sessionModel !== "undefined" && sessionModel.count > 1
            onClicked: sessionPopup.open()
        }
    }

    Rectangle {
        id: keyboardSwitcherBottomRight
        width: 44
        height: 44
        anchors {
            right: parent.right
            bottom: parent.bottom
            rightMargin: 40
            bottomMargin: 32
        }
        z: 100
        visible: loginState.visible
        opacity: loginState.visible && colorExtractor.processed ? 1 : 0

        color: (keyboardSwitcherArea.pressed || container.showVirtualKeyboard) ? container.controlSurfaceActive : container.controlSurface
        radius: 22
        border.width: 1
        border.color: (keyboardSwitcherArea.pressed || container.showVirtualKeyboard) ? container.extractedAccent : container.controlBorder

        scale: keyboardSwitcherArea.pressed ? 0.97 : 1.0
        Behavior on scale {
            NumberAnimation {
                duration: 100
            }
        }
        Behavior on opacity {
            NumberAnimation {
                duration: 200
            }
        }

        Text {
            anchors.centerIn: parent
            text: "⌨"
            color: container.extractedAccent
            font.pixelSize: 16
            font.family: config.fontFamily
        }

        MouseArea {
            id: keyboardSwitcherArea
            anchors.fill: parent
            onClicked: {
                container.showVirtualKeyboard = !container.showVirtualKeyboard;
                passwordField.forceActiveFocus();
            }
        }
    }

    InputPanel {
        id: virtualKeyboard
        z: 200

        width: Math.min(container.width * 0.82, 1000)
        x: (container.width - width) / 2
        y: container.height - height

        active: Qt.inputMethod.visible
        visible: loginState.visible && container.showVirtualKeyboard
        opacity: visible ? 1.0 : 0.0

        Component.onCompleted: {
            VirtualKeyboardSettings.styleName = "default";
            VirtualKeyboardSettings.closeOnReturn = true;
            VirtualKeyboardSettings.visibleFunctionKeys = QtVirtualKeyboard.KeyboardFunctionKeys.None;
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 200
            }
        }

        onVisibleChanged: {
            if (visible) {
                passwordField.forceActiveFocus();
                Qt.inputMethod.show();
            } else {
                Qt.inputMethod.hide();
            }
        }
    }

    PowerBar {
        anchors {
            top: parent.top
            right: parent.right
            topMargin: 30
            rightMargin: 40
        }
        textColor: container.extractedAccent
        z: 100
        opacity: colorExtractor.processed ? 1 : 0
        Behavior on opacity {
            NumberAnimation {
                duration: 300
            }
        }
    }

    Shortcut {
        sequence: "Escape"
        enabled: loginState.visible
        onActivated: {
            loginState.visible = false;
            loginState.isError = false;
            container.showVirtualKeyboard = false;
            Qt.inputMethod.hide();
            passwordField.text = "";
            container.focus = true;
        }
    }

    Shortcut {
        sequences: ["Return", "Enter"]
        enabled: loginState.visible
        onActivated: container.doLogin()
    }

    Text {
        id: dateText
        text: Qt.formatDateTime(new Date(), "dddd, MMMM d")
        color: container.extractedAccent
        font.pixelSize: 22
        font.family: config.fontFamily
        anchors {
            top: parent.top
            left: parent.left
            topMargin: 50
            leftMargin: 60
        }
        opacity: colorExtractor.processed ? 1 : 0
        Behavior on opacity {
            NumberAnimation {
                duration: 300
            }
        }
    }

    Item {
        id: lockState
        anchors.fill: parent
        visible: !loginState.visible
        opacity: visible ? 1 : 0
        Behavior on opacity {
            NumberAnimation {
                duration: 400
            }
        }

        Clock {
            id: mainClock
            anchors.centerIn: parent
            backgroundSource: config.background
            baseAccent: container.extractedAccent
            fontFamily: config.fontFamily
            opacity: colorExtractor.processed ? 1 : 0
            Behavior on opacity {
                NumberAnimation {
                    duration: 300
                }
            }
        }

        Text {
            text: "Press any key to unlock"
            color: config.textColor
            font.pixelSize: 16
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
                bottomMargin: 100
            }
            opacity: 0.5
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                loginState.visible = true;
                passwordField.forceActiveFocus();
            }
        }
    }

    Item {
        id: loginState
        anchors.fill: parent
        visible: false
        opacity: visible ? 1 : 0
        z: 10
        Behavior on opacity {
            NumberAnimation {
                duration: 400
            }
        }

        onVisibleChanged: {
            if (visible)
                passwordField.forceActiveFocus();
        }

        property bool isError: false
        SequentialAnimation {
            id: shakeAnimation
            loops: 2
            PropertyAnimation {
                target: loginCard
                property: "x"
                from: (container.width - loginCard.width) / 2
                to: (container.width - loginCard.width) / 2 - 10
                duration: 50
                easing.type: Easing.InOutQuad
            }
            PropertyAnimation {
                target: loginCard
                property: "x"
                from: (container.width - loginCard.width) / 2 - 10
                to: (container.width - loginCard.width) / 2 + 10
                duration: 50
                easing.type: Easing.InOutQuad
            }
            PropertyAnimation {
                target: loginCard
                property: "x"
                from: (container.width - loginCard.width) / 2 + 10
                to: (container.width - loginCard.width) / 2
                duration: 50
                easing.type: Easing.InOutQuad
            }
            onStopped: isError = false
        }

        Rectangle {
            id: loginCard
            width: 400
            height: 430
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            color: loginState.isError ? "#442222" : "#161814"
            radius: 30
            border.width: 1
            border.color: loginState.isError ? "#7A3A3A" : "#2B2E27"
            opacity: 0.88

            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }
            Behavior on border.color {
                ColorAnimation {
                    duration: 200
                }
            }

            Rectangle {
                anchors.fill: parent
                anchors.margins: 1
                radius: 29
                color: "transparent"
                border.width: 1
                border.color: "#20231D"
                opacity: 0.7
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.leftMargin: 34
                anchors.rightMargin: 34
                anchors.topMargin: 54
                anchors.bottomMargin: 34
                spacing: 14

                Item {
                    Layout.preferredWidth: 108
                    Layout.preferredHeight: 108
                    Layout.alignment: Qt.AlignHCenter

                    Rectangle {
                        anchors.fill: parent
                        radius: width / 2
                        color: "#23261F"
                        border.width: 2
                        border.color: Qt.rgba(container.extractedAccent.r, container.extractedAccent.g, container.extractedAccent.b, 0.35)
                    }

                    Rectangle {
                        id: avatarFallback
                        anchors.centerIn: parent
                        width: 96
                        height: 96
                        color: "#2D2F27"
                        radius: width / 2
                        visible: avatar.status !== Image.Ready

                        Text {
                            anchors.centerIn: parent
                            text: {
                                var n = "";
                                if (typeof userModel !== "undefined" && userModel.count > 0) {
                                    var d = userModel.data(userModel.index(container.userIndex, 0), Qt.DisplayRole);
                                    var nr = userModel.data(userModel.index(container.userIndex, 0), Qt.UserRole + 1);
                                    n = d ? d.toString() : (nr ? nr.toString() : "U");
                                } else {
                                    n = sddm.lastUser ? sddm.lastUser : "U";
                                }
                                return n.charAt(0).toUpperCase();
                            }
                            color: container.extractedAccent
                            font.pixelSize: 42
                            font.family: fontBold.name
                            font.weight: Font.Bold
                        }
                    }

                    Canvas {
                        id: avatarCanvas
                        anchors.centerIn: parent
                        width: 96
                        height: 96
                        visible: avatar.status === Image.Ready

                        onPaint: {
                            var ctx = getContext("2d");
                            ctx.reset();
                            ctx.beginPath();
                            ctx.arc(width / 2, height / 2, width / 2, 0, 2 * Math.PI);
                            ctx.closePath();
                            ctx.clip();
                            ctx.drawImage(avatar, 0, 0, width, height);
                        }

                        Timer {
                            id: repaintTimer
                            interval: 500
                            onTriggered: avatarCanvas.requestPaint()
                        }

                        Image {
                            id: avatar
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectCrop
                            smooth: true
                            visible: false

                            Component.onCompleted: {
                                var s = Qt.resolvedUrl("assets/avatar.jpg");
                                if (typeof userModel !== "undefined" && userModel.count > 0) {
                                    var icon = userModel.data(userModel.index(container.userIndex, 0), Qt.UserRole + 3);
                                    if (icon && icon.toString().match(/\.(jpg|jpeg|png|bmp|webp|svg)$/i)) {
                                        s = icon.toString();
                                    }
                                }
                                source = s;
                            }

                            onStatusChanged: {
                                if (status === Image.Ready)
                                    repaintTimer.start();
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: Math.min(300, Math.max(180, userNameLabel.implicitWidth + 44))
                    Layout.preferredHeight: 42
                    radius: 21
                    color: (userClickArea.pressed || userPopup.opened) ? container.controlSurfaceActive : container.controlSurface
                    border.width: 1
                    border.color: userPopup.opened ? container.extractedAccent : container.controlBorder

                    scale: userClickArea.pressed ? 0.98 : 1.0
                    Behavior on scale {
                        NumberAnimation {
                            duration: 100
                        }
                    }
                    Behavior on color {
                        ColorAnimation {
                            duration: 120
                        }
                    }
                    Behavior on border.color {
                        ColorAnimation {
                            duration: 140
                        }
                    }

                    Text {
                        id: userNameLabel
                        anchors.centerIn: parent
                        width: parent.width - 28
                        text: {
                            if (typeof userModel !== "undefined" && userModel.count > 0) {
                                var idx = container.userIndex;
                                var modelIdx = userModel.index(idx, 0);
                                var display = userModel.data(modelIdx, Qt.DisplayRole);
                                var edit = userModel.data(modelIdx, Qt.EditRole);
                                var nr = userModel.data(modelIdx, Qt.UserRole + 1);
                                var realName = userModel.data(modelIdx, Qt.UserRole + 2);
                                var finalName = display ? display.toString() : (realName ? realName.toString() : (nr ? nr.toString() : (edit ? edit.toString() : "User")));
                                return cleanName(finalName) + (userModel.count > 1 ? " ▾" : "");
                            }
                            return cleanName(sddm.lastUser ? sddm.lastUser : "User");
                        }
                        color: "white"
                        font.pixelSize: 19
                        font.weight: Font.DemiBold
                        font.family: config.fontFamily
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }

                    MouseArea {
                        id: userClickArea
                        anchors.fill: parent
                        enabled: typeof userModel !== "undefined" && userModel.count > 1
                        onClicked: {
                            if (typeof userModel !== "undefined" && userModel.count > 1)
                                userPopup.open();
                        }
                    }
                }

                Item {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    Layout.preferredHeight: 18

                    Row {
                        anchors.centerIn: parent
                        spacing: 12

                        Text {
                            id: capsLockIndicator
                            text: "CapsLock"
                            color: (typeof keyboard !== "undefined" && typeof keyboard.capsLock !== "undefined" && keyboard.capsLock) ? container.extractedAccent : "#8D9388"
                            opacity: (typeof keyboard !== "undefined" && typeof keyboard.capsLock !== "undefined" && keyboard.capsLock) ? 1.0 : 0.55
                            font.pixelSize: 13
                            font.family: config.fontFamily
                            font.weight: Font.Medium

                            Behavior on color {
                                ColorAnimation {
                                    duration: 200
                                }
                            }
                            Behavior on opacity {
                                NumberAnimation {
                                    duration: 200
                                }
                            }
                        }

                        Text {
                            id: numLockIndicator
                            text: "NumLock"
                            color: (typeof keyboard !== "undefined" && typeof keyboard.numLock !== "undefined" && keyboard.numLock) ? container.extractedAccent : "#8D9388"
                            opacity: (typeof keyboard !== "undefined" && typeof keyboard.numLock !== "undefined" && keyboard.numLock) ? 1.0 : 0.55
                            font.pixelSize: 13
                            font.family: config.fontFamily
                            font.weight: Font.Medium

                            Behavior on color {
                                ColorAnimation {
                                    duration: 200
                                }
                            }
                            Behavior on opacity {
                                NumberAnimation {
                                    duration: 200
                                }
                            }
                        }
                    }
                }

                Item {
                    Layout.preferredHeight: 24
                }

                TextField {
                    id: passwordField
                    echoMode: TextInput.Password
                    Layout.fillWidth: true
                    Layout.preferredHeight: 56
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 17
                    color: "white"
                    focus: loginState.visible
                    enabled: !container.isLoggingIn
                    selectByMouse: true

                    background: Rectangle {
                        color: "#23261F"
                        radius: 18
                        border.width: parent.activeFocus ? 2 : 1
                        border.color: parent.activeFocus ? container.extractedAccent : "#343830"
                        opacity: parent.enabled ? 1.0 : 0.5
                    }

                    Text {
                        text: "Enter Password"
                        color: "#8D9388"
                        font.pixelSize: 15
                        visible: !parent.text
                        anchors.centerIn: parent
                    }

                    onAccepted: container.doLogin()
                }

                Item {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 44
                    Layout.preferredHeight: 20

                    Row {
                        anchors.centerIn: parent
                        spacing: 6
                        opacity: container.isLoggingIn ? 1 : 0

                        Behavior on opacity {
                            NumberAnimation {
                                duration: 150
                            }
                        }

                        Repeater {
                            model: 3

                            Rectangle {
                                width: 6
                                height: 6
                                radius: 3
                                color: container.extractedAccent
                                opacity: 0.35

                                SequentialAnimation on opacity {
                                    running: container.isLoggingIn
                                    loops: Animation.Infinite
                                    PauseAnimation {
                                        duration: index * 120
                                    }
                                    NumberAnimation {
                                        from: 0.25
                                        to: 1.0
                                        duration: 260
                                    }
                                    NumberAnimation {
                                        from: 1.0
                                        to: 0.25
                                        duration: 260
                                    }
                                    PauseAnimation {
                                        duration: 180
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Keys.onPressed: function (event) {
        if (!loginState.visible) {
            loginState.visible = true;
            passwordField.forceActiveFocus();
            event.accepted = true;
        }
    }

    Popup {
        id: userPopup
        width: 260
        height: (typeof userModel !== "undefined") ? Math.max(90, Math.min(250, userModel.count * 50 + 20)) : 100

        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        onOpened: {
            container.showVirtualKeyboard = false;
            Qt.inputMethod.hide();
            userList.forceActiveFocus();
        }

        x: (parent.width - width) / 2
        y: (parent.height - height) / 2 - 30

        background: Rectangle {
            color: "#1A1C18"
            radius: 24
            opacity: 0.95
            border.color: "#3D3F37"
            border.width: 1
        }

        enter: Transition {
            NumberAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 200
            }
        }
        exit: Transition {
            NumberAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 200
            }
        }

        ListView {
            id: userList
            anchors.fill: parent
            anchors.margins: 10
            model: (typeof userModel !== "undefined") ? userModel : null
            spacing: 5
            clip: true
            focus: true
            currentIndex: container.userIndex
            highlightFollowsCurrentItem: true

            delegate: ItemDelegate {
                width: parent.width
                height: 40
                property bool isCurrent: index === userList.currentIndex

                background: Rectangle {
                    color: isCurrent ? "#3D3F37" : (hovered ? "#2D2F27" : "transparent")
                    radius: 12
                    Rectangle {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 8
                        width: 4
                        height: isCurrent ? 16 : 0
                        color: container.extractedAccent
                        radius: 2
                        Behavior on height {
                            NumberAnimation {
                                duration: 150
                            }
                        }
                    }
                }

                contentItem: RowLayout {
                    anchors.fill: parent
                    spacing: 0

                    Item {
                        Layout.preferredWidth: 20
                    }

                    Text {
                        Layout.preferredWidth: 40
                        text: "󰀄"
                        color: isCurrent ? container.extractedAccent : "gray"
                        font.pixelSize: 16
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    Text {
                        Layout.fillWidth: true
                        text: {
                            var mIdx = userModel.index(index, 0);
                            var d = userModel.data(mIdx, Qt.DisplayRole);
                            var n_r = userModel.data(mIdx, Qt.UserRole + 1);
                            var r = userModel.data(mIdx, Qt.UserRole + 2);
                            var e = userModel.data(mIdx, Qt.EditRole);
                            return cleanName(d ? d : (r ? r : (n_r ? n_r : e)));
                        }
                        color: isCurrent ? "white" : "#AAAAAA"
                        font.pixelSize: 14
                        font.family: config.fontFamily
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        rightPadding: 10
                        elide: Text.ElideRight
                    }
                }

                onClicked: {
                    container.userIndex = index;
                    userPopup.close();
                }
            }

            Keys.onDownPressed: incrementCurrentIndex()
            Keys.onUpPressed: decrementCurrentIndex()
            Keys.onReturnPressed: {
                container.userIndex = currentIndex;
                userPopup.close();
            }
            Keys.onEnterPressed: {
                container.userIndex = currentIndex;
                userPopup.close();
            }
        }
    }

    Popup {
        id: sessionPopup
        width: 260
        height: (typeof sessionModel !== "undefined") ? Math.min(250, sessionModel.count * 50 + 20) : 100

        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        onOpened: {
            container.showVirtualKeyboard = false;
            Qt.inputMethod.hide();
            sessionList.forceActiveFocus();
        }

        x: Math.max(12, Math.min(sessionSwitcherBottomLeft.x, container.width - width - 12))
        y: Math.max(12, sessionSwitcherBottomLeft.y - height - 12)

        background: Rectangle {
            color: "#1A1C18"
            radius: 24
            opacity: 0.95
            border.color: "#3D3F37"
            border.width: 1
        }

        enter: Transition {
            NumberAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 200
            }
        }
        exit: Transition {
            NumberAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 200
            }
        }

        ListView {
            id: sessionList
            anchors.fill: parent
            anchors.margins: 10
            model: (typeof sessionModel !== "undefined") ? sessionModel : null
            spacing: 5
            clip: true
            focus: true
            currentIndex: container.sessionIndex
            highlightFollowsCurrentItem: true

            delegate: ItemDelegate {
                width: parent.width
                height: 40
                property bool isCurrent: index === sessionList.currentIndex

                background: Rectangle {
                    color: isCurrent ? "#3D3F37" : (hovered ? "#2D2F27" : "transparent")
                    radius: 12

                    Rectangle {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 8
                        width: 4
                        height: isCurrent ? 16 : 0
                        color: container.extractedAccent
                        radius: 2
                        Behavior on height {
                            NumberAnimation {
                                duration: 150
                            }
                        }
                    }
                }

                contentItem: RowLayout {
                    anchors.fill: parent
                    spacing: 0

                    Item {
                        Layout.preferredWidth: 14
                    }

                    Text {
                        Layout.preferredWidth: 20
                        text: "󰟀"
                        color: isCurrent ? container.extractedAccent : "gray"
                        font.pixelSize: 16
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    Text {
                        Layout.fillWidth: true
                        text: {
                            var n_val = sessionModel.data(sessionModel.index(index, 0), Qt.UserRole + 4);
                            var f_val = sessionModel.data(sessionModel.index(index, 0), Qt.UserRole + 2);
                            return cleanName(n_val ? n_val : f_val);
                        }
                        color: isCurrent ? "white" : "#AAAAAA"
                        font.pixelSize: 14
                        font.family: config.fontFamily
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        rightPadding: 10
                        elide: Text.ElideRight
                    }
                }

                onClicked: {
                    container.sessionIndex = index;
                    sessionPopup.close();
                }
            }

            Keys.onDownPressed: incrementCurrentIndex()
            Keys.onUpPressed: decrementCurrentIndex()
            Keys.onReturnPressed: {
                container.sessionIndex = currentIndex;
                sessionPopup.close();
            }
            Keys.onEnterPressed: {
                container.sessionIndex = currentIndex;
                sessionPopup.close();
            }
        }
    }
}

