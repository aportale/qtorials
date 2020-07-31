import QtQuick 2.12

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
        transformOrigin: Item.Center
        NumberAnimation on rotation {
            from: 0
            to: 360
            duration: 2500
            loops: Animation.Infinite
        }
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
        NumberAnimation on rotation {
            from: 0
            to: 360
            duration: 5000
            loops: Animation.Infinite
        }
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
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.5}
}
##^##*/
