pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Shapes
import QtQuick.Timeline

// Test scene for QtAviSynthQmlAnimation. QtAviSynth drives the timeline frame by frame, and
// timeline frames are milliseconds. Everything that moves is therefore either a keyframe of
// the timeline or a binding on root.t. Running animations, Behaviors and particles follow the
// wall clock instead, and would render differently on every run.
Item {
    id: root
    width: 640
    height: 480

    // Can be set from AviSynth with the "initialproperties" JSON
    property string text1Text: qsTr("Qt AviSynth")
    property string text2Text: qsTr("QML, rendered frame by frame")
    property int text2FontpixelSize: 30

    readonly property real t: timeline.currentFrame
    readonly property real duration: timeline.endFrame
    readonly property color qtGreen: "#41cd52"
    readonly property color darkGreen: "#0d3b16"
    readonly property point center: Qt.point(width / 2, 150)

    function clamp01(x: real): real { return Math.max(0, Math.min(1, x)) }
    // 0 until 'from' ms, then linearly up to 1 within 'length' ms
    function progress(time: real, from: real, length: real): real {
        return clamp01((time - from) / length)
    }
    function easeOutBack(x: real): real {
        const c = 1.70158
        return 1 + (c + 1) * Math.pow(x - 1, 3) + c * Math.pow(x - 1, 2)
    }
    function easeOutCubic(x: real): real { return 1 - Math.pow(1 - x, 3) }
    function easeInCubic(x: real): real { return x * x * x }
    function timecode(ms: real): string {
        const seconds = Math.floor(ms / 1000)
        return String(Math.floor(seconds / 60)).padStart(2, "0") + ":"
                + String(seconds % 60).padStart(2, "0") + "."
                + String(Math.floor(ms % 1000)).padStart(3, "0")
    }

    // Must be the first Timeline in the scene, QtAviSynth drives that one
    Timeline {
        id: timeline
        startFrame: 0
        endFrame: 10000
        enabled: true

        // Plays the scene in Qt Design Studio or the qml tool. QtAviSynth stops it.
        animations: TimelineAnimation {
            running: true
            loops: Animation.Infinite
            from: 0
            to: 10000
            duration: 10000
        }

        KeyframeGroup {
            target: backdrop
            property: "opacity"
            Keyframe { frame: 0; value: 0 }
            Keyframe { frame: 800; value: 1; easing.type: Easing.OutQuad }
            Keyframe { frame: 9200; value: 1 }
            Keyframe { frame: 10000; value: 0; easing.type: Easing.InQuad }
        }

        KeyframeGroup {
            target: grid
            property: "opacity"
            Keyframe { frame: 0; value: 0.28 }
            Keyframe { frame: 9000; value: 0.28 }
            Keyframe { frame: 9800; value: 0 }
        }

        KeyframeGroup {
            target: core
            property: "scale"
            Keyframe { frame: 0; value: 0 }
            Keyframe { frame: 300; value: 0 }
            Keyframe { frame: 1300; value: 1; easing.type: Easing.OutBack }
            Keyframe { frame: 8700; value: 1 }
            Keyframe { frame: 9600; value: 0; easing.type: Easing.InBack }
        }

        KeyframeGroup {
            target: core
            property: "rotation"
            Keyframe { frame: 0; value: 0 }
            Keyframe { frame: 8700; value: 0 }
            Keyframe { frame: 9600; value: 180; easing.type: Easing.InQuad }
        }

        KeyframeGroup {
            target: subtitle
            property: "opacity"
            Keyframe { frame: 0; value: 0 }
            Keyframe { frame: 2300; value: 0 }
            Keyframe { frame: 3000; value: 1 }
            Keyframe { frame: 8700; value: 1 }
            Keyframe { frame: 9300; value: 0 }
        }

        KeyframeGroup {
            target: subtitleShift
            property: "y"
            Keyframe { frame: 0; value: 30 }
            Keyframe { frame: 2300; value: 30 }
            Keyframe { frame: 3000; value: 0; easing.type: Easing.OutCubic }
        }

        KeyframeGroup {
            target: hud
            property: "opacity"
            Keyframe { frame: 0; value: 0 }
            Keyframe { frame: 300; value: 0 }
            Keyframe { frame: 900; value: 1 }
            Keyframe { frame: 9300; value: 1 }
            Keyframe { frame: 9900; value: 0 }
        }
    }

    // Translucent, so that the clip underneath shows through
    Rectangle {
        id: backdrop
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0; color: "#e0061a10" }
            GradientStop { position: 0.6; color: "#b0040d09" }
            GradientStop { position: 1; color: "#f0020604" }
        }
    }

    // Drifting grid, its lines grow in one after the other. A Shape rather than Rectangles,
    // which would snap to whole pixels and move in steps.
    Shape {
        id: grid
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer
        antialiasing: true
        readonly property real spacing: 40
        readonly property real drift: (root.t * 0.012) % spacing
        readonly property var lines: {
            const result = []
            for (let i = 0; i < 18; ++i) {
                const lineX = i * grid.spacing - grid.drift
                const length =
                    grid.height * root.easeOutCubic(root.progress(root.t, 100 + i * 25, 500))
                if (length > 0)
                    result.push([Qt.point(lineX, 0), Qt.point(lineX, length)])
            }
            for (let i = 0; i < 13; ++i) {
                const lineY = i * grid.spacing - grid.drift
                const length =
                    grid.width * root.easeOutCubic(root.progress(root.t, 100 + i * 35, 500))
                if (length > 0)
                    result.push([Qt.point(0, lineY), Qt.point(length, lineY)])
            }
            return result
        }

        ShapePath {
            strokeColor: root.qtGreen
            strokeWidth: 1
            fillColor: "transparent"
            PathMultiline { paths: grid.lines }
        }
    }

    // Shock waves, one every 400 ms
    Repeater {
        model: 3
        Rectangle {
            id: wave
            required property int index
            readonly property real start: 1200 + index * 400
            readonly property real period: 1200
            readonly property real phase: root.t < start ? 0 : ((root.t - start) % period) / period
            readonly property real size: 60 + phase * 200
            visible: root.t >= start
            x: root.center.x - size
            y: root.center.y - size
            width: 2 * size
            height: width
            radius: size
            color: "transparent"
            border.color: root.qtGreen
            border.width: 2
            opacity: (1 - wave.phase) * 0.6 * (1 - root.progress(root.t, 8300, 400))
        }
    }

    // Spinning arcs, a hue cycling square and orbiting squares
    Item {
        id: core
        x: root.center.x
        y: root.center.y

        Shape {
            x: -120
            y: -120
            width: 240
            height: 240
            // The default renderer has no antialiasing without multisampling. The software
            // backend ignores this and draws with QPainter, antialiased because of the below.
            preferredRendererType: Shape.CurveRenderer
            antialiasing: true

            ShapePath {
                strokeColor: root.qtGreen
                strokeWidth: 7
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                PathAngleArc {
                    centerX: 120; centerY: 120
                    radiusX: 92; radiusY: 92
                    startAngle: root.t * 0.15
                    sweepAngle: 100 + 50 * Math.sin(root.t / 600)
                }
            }
            ShapePath {
                strokeColor: root.qtGreen
                strokeWidth: 7
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                PathAngleArc {
                    centerX: 120; centerY: 120
                    radiusX: 92; radiusY: 92
                    startAngle: root.t * 0.15 + 180
                    sweepAngle: 100 + 50 * Math.sin(root.t / 600)
                }
            }
            ShapePath {
                strokeColor: "#ccffffff"
                strokeWidth: 2
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                PathAngleArc {
                    centerX: 120; centerY: 120
                    radiusX: 108; radiusY: 108
                    startAngle: -root.t * 0.08
                    sweepAngle: 60
                }
            }
            ShapePath {
                strokeColor: "#80ffffff"
                strokeWidth: 2
                fillColor: "transparent"
                strokeStyle: ShapePath.DashLine
                dashPattern: [2, 4]
                dashOffset: root.t * 0.004
                PathAngleArc {
                    centerX: 120; centerY: 120
                    radiusX: 70; radiusY: 70
                    startAngle: 0
                    sweepAngle: 360
                }
            }
        }

        // A Shape rather than a Rectangle, since the software backend draws Rectangles with a
        // gradient without antialiasing
        Shape {
            id: heart
            readonly property real hue: (root.t / 5000) % 1
            x: -32
            y: -32
            width: 64
            height: 64
            rotation: 45 + root.t * 0.09
            scale: 1 + 0.08 * Math.sin(root.t / 250)
            preferredRendererType: Shape.CurveRenderer
            antialiasing: true

            ShapePath {
                strokeColor: "transparent"
                fillGradient: LinearGradient {
                    x1: 0; y1: 0
                    x2: 0; y2: 64
                    GradientStop { position: 0; color: Qt.hsva(heart.hue, 0.75, 1, 1) }
                    GradientStop { position: 1; color: Qt.hsva((heart.hue + 0.25) % 1, 0.8, 0.7, 1) }
                }
                PathRectangle {
                    width: 64
                    height: 64
                    radius: 12
                }
            }
        }

        Repeater {
            model: 12
            Rectangle {
                id: satellite
                required property int index
                readonly property real appear:
                    root.easeOutBack(root.progress(root.t, 1700 + index * 70, 500))
                readonly property real leave:
                    root.easeInCubic(root.progress(root.t, 8300 + index * 40, 450))
                readonly property real angle: (index * 30 + root.t * 0.04) * Math.PI / 180
                readonly property real orbit: 120 + 10 * Math.sin(root.t / 450 + index) + 80 * leave
                width: 16
                height: 16
                radius: 4
                antialiasing: true
                x: satellite.orbit * Math.cos(satellite.angle) - width / 2
                y: satellite.orbit * Math.sin(satellite.angle) - height / 2
                scale: Math.max(0, satellite.appear * (1 - satellite.leave))
                rotation: index * 30 + root.t * 0.3
                color: Qt.hsva((index / 12 + root.t / 8000) % 1, 0.6, 1, 1)
            }
        }
    }

    // Title: the letters drop in one by one, a shine runs over them, then they fly away
    Row {
        id: title
        anchors.horizontalCenter: parent.horizontalCenter
        y: 300
        scale: Math.min(1, (root.width - 60) / implicitWidth)

        Repeater {
            model: root.text1Text.split("")
            Text {
                id: letter
                required property string modelData
                required property int index
                readonly property real enter: root.progress(root.t, 1000 + index * 80, 650)
                readonly property real exit: root.progress(root.t, 8500 + index * 50, 550)
                readonly property real shinePosition:
                    ((root.t - 3200) % 2600) / 1600 * (root.text1Text.length + 4) - 2
                readonly property real shine: root.t < 3200
                    ? 0 : root.clamp01(1 - Math.abs(index - shinePosition) / 2.5)
                text: modelData
                font.pixelSize: 60
                font.bold: true
                color: Qt.tint("#ffffff", Qt.rgba(0.25, 0.8, 0.32, letter.shine))
                style: Text.Outline
                styleColor: root.darkGreen
                opacity: letter.enter * (1 - letter.exit)
                rotation: (1 - root.easeOutBack(letter.enter)) * -30 + letter.exit * 25
                transform: Translate {
                    y: (1 - root.easeOutBack(letter.enter)) * -70
                       - root.easeInCubic(letter.exit) * 90
                       - letter.shine * 6
                }
            }
        }
    }

    // Subtitle: slides up while its letter spacing tightens
    Text {
        id: subtitle
        x: 30
        y: 382
        width: root.width - 60
        height: 44
        text: root.text2Text
        color: "#e0ffffff"
        font.pixelSize: root.text2FontpixelSize
        font.letterSpacing: 14 * (1 - root.easeOutCubic(root.progress(root.t, 2300, 900)))
        minimumPixelSize: 10
        fontSizeMode: Text.Fit
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        style: Text.Outline
        styleColor: root.darkGreen
        transform: Translate { id: subtitleShift }
    }

    // Corner brackets, progress bar and timecode
    Item {
        id: hud
        anchors.fill: parent

        Repeater {
            model: 4
            Item {
                id: corner
                required property int index
                readonly property bool atRight: index % 2 === 1
                readonly property bool atBottom: index >= 2
                readonly property real length:
                    26 * root.easeOutCubic(root.progress(root.t, 300 + index * 80, 500))
                x: atRight ? root.width - 18 : 18
                y: atBottom ? root.height - 18 : 18
                Rectangle {
                    x: corner.atRight ? -corner.length : 0
                    y: corner.atBottom ? -2 : 0
                    width: corner.length
                    height: 2
                    color: root.qtGreen
                }
                Rectangle {
                    x: corner.atRight ? -2 : 0
                    y: corner.atBottom ? -corner.length : 0
                    width: 2
                    height: corner.length
                    color: root.qtGreen
                }
            }
        }

        Text {
            x: track.x
            y: 438
            text: "QtAviSynthQmlAnimation"
            color: "#b0ffffff"
            font.family: "Consolas"
            font.pixelSize: 13
        }
        Text {
            anchors.right: track.right
            y: 438
            text: root.timecode(root.t) + " / " + root.timecode(root.duration)
            color: "#b0ffffff"
            font.family: "Consolas"
            font.pixelSize: 13
        }

        Rectangle {
            id: track
            readonly property real position: width * root.t / root.duration
            x: 40
            y: 462
            width: root.width - 80
            height: 4
            radius: 2
            color: "#40ffffff"

            Rectangle {
                width: track.position
                height: parent.height
                radius: 2
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0; color: "#1d6b27" }
                    GradientStop { position: 1; color: root.qtGreen }
                }
            }
            Rectangle {
                x: track.position - width / 2
                y: (track.height - height) / 2
                width: 12
                height: 12
                radius: 6
                color: "#ffffff"
                border.color: root.qtGreen
                border.width: 3
            }
        }
    }
}
