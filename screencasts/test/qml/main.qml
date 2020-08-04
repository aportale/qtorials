import QtQuick 2.14
import QtQuick.Timeline 1.0

Item {
    width: 640
    height: 480

    Rectangle {
        id: rectangle
        x: 40
        y: 40
        width: 128
        height: 128
        color: "#df2424"
        rotation: 360
        transformOrigin: Item.Center
        smooth: true
        antialiasing: true
    }

    Rectangle {
        id: rectangle1
        x: 40
        y: width + 80
        width: 128
        height: 128
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#00ff00"
            }

            GradientStop {
                position: 1
                color: "#000000"
            }
        }
    }

    Rectangle {
        id: rectangle2
        x: width + 80
        y: 40
        width: 128
        height: 128
        color: "#e17373"
        transformOrigin: Item.Center
        smooth: true
        antialiasing: true
    }

    Rectangle {
        id: rectangle4
        x: width + 80
        y: width + 80
        width: 128
        height: 128
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#ff0000"
            }

            GradientStop {
                position: 1
                color: "#00000000"
            }
        }
    }

    Timeline {
        id: timeline
        endFrame: 1000
        enabled: true
        startFrame: 0

        KeyframeGroup {
            target: rectangle
            property: "rotation"
            Keyframe {
                frame: 0
                value: 0
            }

            Keyframe {
                frame: 1000
                value: 360
            }
        }

        KeyframeGroup {
            target: rectangle2
            property: "scale"
            Keyframe {
                frame: 0
                value: 0.8
            }

            Keyframe {
                frame: 1000
                value: 1.2
            }
        }
    }
}
