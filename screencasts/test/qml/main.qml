import QtQuick 2.14
import QtQuick.Timeline 1.0

Item {
    width: 640
    height: 480
    property alias text1Text: text1.text
    property alias text2FontpixelSize: text2.font.pixelSize

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

        KeyframeGroup {
            target: text1
            property: "scale"
            Keyframe {
                frame: 0
                value: 1
            }

            Keyframe {
                frame: 1000
                value: 3
            }
        }

        KeyframeGroup {
            target: text2
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
    }

    Text {
        id: text1
        x: 87
        y: 371
        color: "#ffaa00"
        text: qsTr("text1.text")
        style: Text.Outline
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        transformOrigin: Item.Center
        font.pixelSize: 20
    }

    Text {
        id: text2
        x: 255
        y: 371
        text: qsTr("text2.text")
        style: Text.Outline
        styleColor: "#ffffff"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        transformOrigin: Item.Center
        font.pixelSize: 20
    }
}
