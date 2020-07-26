import QtQuick 2.12

Item {
    width: 640
    height: 480

    Rectangle {
        id: rectangle
        x: 45
        y: 45
        width: 171
        height: 119
        color: "#df2424"
    }

    Rectangle {
        id: rectangle1
        x: 45
        y: 191
        width: 171
        height: 119
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#595df2"
            }

            GradientStop {
                position: 1
                color: "#000000"
            }
        }
    }

    Rectangle {
        id: rectangle2
        x: 311
        y: 45
        width: 171
        height: 119
        color: "#e17373"
    }

    Rectangle {
        id: rectangle4
        x: 311
        y: 191
        width: 171
        height: 119
        color: "#e2ee32"
    }
}
