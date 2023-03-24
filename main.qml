import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Scene3D 2.15

Window {
    width: 800
    height: 600
    visible: true
    title: qsTr("Point Size")
    color: Qt.rgba(0.95, 1.0, 1.0, 1.0)

    Scene3D {
        anchors.fill: parent
        focus: true
        aspects: ["input", "logic"]

        Stage {
            id: stage
            count: _sliderPoints.value
            pointSize: _sliderSize.value
            perspective: true
            aspect: width / height
        }
    }

    ColumnLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 10
        anchors.bottomMargin: 10
        opacity: 0.75

        Label {
            property var profile: ["", "Core", "Compat"]
            text: "OpenGL: " + OpenGLInfo.majorVersion + '.' + OpenGLInfo.minorVersion + ' ' + profile[OpenGLInfo.profile]
        }

        RowLayout {
            spacing: 4

            RadioButton {
                checked: true
                text: qsTr("Perspective")
                onCheckedChanged: stage.perspective = true
            }

            RadioButton {
                text: qsTr("Orthographic")
                onCheckedChanged: stage.perspective = false
            }
        }

        RowLayout {
            spacing: 4

            Slider {
                id: _sliderPoints
                Layout.fillWidth: true
                Layout.maximumWidth: 600
                snapMode: RangeSlider.SnapAlways
                value: 10000
                stepSize: 10000
                from: 10000
                to: 1000000
            }

            Text {
                Layout.minimumWidth: 120
                Layout.maximumWidth: 120
                verticalAlignment: Text.AlignVCenter
                text: _sliderPoints.value.toFixed(0)
                font.pixelSize: 24
            }
        }

        RowLayout {
            spacing: 4

            Slider {
                id: _sliderSize
                Layout.fillWidth: true
                Layout.maximumWidth: 600
                snapMode: RangeSlider.SnapAlways
                value: 1
                stepSize: 1
                from: 1
                to: 32
            }

            Text {
                Layout.minimumWidth: 120
                Layout.maximumWidth: 120
                verticalAlignment: Text.AlignVCenter
                text: _sliderSize.value.toFixed(0)
                font.pixelSize: 24
            }
        }
    }
}
