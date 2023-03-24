import QtQuick.Window 2.15
import Qt3D.Core 2.0
import Qt3D.Input 2.0
import Qt3D.Render 2.0
import Qt3D.Extras 2.0

Entity {
    id: root

    property int count: 10000
    property int pointSize: 5
    property bool perspective: true
    property real aspect: 1

    Camera {
        id: perspectiveCamera
        projectionType: CameraLens.PerspectiveProjection
        fieldOfView: 60
        aspectRatio: root.aspect
        nearPlane: 0.1
        farPlane : 1000.0
        upVector: Qt.vector3d( 0.0, 1.0, 0.0 )
        position: Qt.vector3d( 0.0, 0.0, 15.0 )
        viewCenter: Qt.vector3d( 0.0, 0.0, 0.0 )
    }

    Camera {
        id: orthographicCamera
        projectionType: CameraLens.OrthographicProjection
        nearPlane: 0.1
        farPlane : 1000.0
        upVector: Qt.vector3d( 0.0, 1.0, 0.0 )
        position: Qt.vector3d( 0.0, 0.0, 15.0 )
        viewCenter: Qt.vector3d( 0.0, 0.0, 0.0 )
        right: width / 2
        left: -(width / 2)
        top: height / 2
        bottom:  -(height/2)

        property real viewSize: 15
        property real height: viewSize
        property real width: viewSize * root.aspect
    }

    components: [
        RenderSettings {
            activeFrameGraph: RenderSurfaceSelector {
                ForwardRenderer {
                    clearColor: Qt.rgba(0.95, 1.0, 1.0, 1.0)
                    CameraSelector {
                        camera: root.perspective == true ? perspectiveCamera : orthographicCamera
                        RenderStateSet {
                            renderStates: [
                                PointSize {
                                    sizeMode: PointSize.Fixed
                                    // Common values are 1.0 on normal displays and 2.0 on Apple "retina" displays.
                                    value: root.pointSize * Screen.devicePixelRatio
                                },
                                DepthTest {
                                    depthFunction: DepthTest.Less
                                }
                            ]
                        }
                    }
                }
            }
        },
        InputSettings {}
    ]

    MouseDevice {
        id: mouseDevice
        // Common values are 1.0 on normal displays and 2.0 on Apple "retina" displays.
        sensitivity: Screen.devicePixelRatio
    }

    Entity {
        property PointCloudCube pointCloudCube : PointCloudCube {
            count: root.count
        }

        property PerVertexColorMaterial material: PerVertexColorMaterial {
        }

        property Transform transform: Transform {
        }

        property MouseHandler mouseHandler: MouseHandler {
            sourceDevice: mouseDevice

            property int posX
            property int posY

            onPressed: {
                if (mouse.buttons == Qt.LeftButton) {
                    posX = mouse.x
                    posY = mouse.y
                }
            }

            onPositionChanged: {
                if (mouse.buttons == Qt.LeftButton) {
                    var sensitivity = mouseDevice.sensitivity
                    if (mouse.modifiers & Qt.ShiftModifier)
                        sensitivity *= .1
                    var yaw = parent.transform.rotationY + (mouse.x - posX) * sensitivity
                    var pitch = parent.transform.rotationZ + (mouse.y - posY) * sensitivity

                    parent.transform.rotationY = yaw % 360
                    parent.transform.rotationZ = pitch % 360

                    posX = mouse.x
                    posY = mouse.y
                }
            }
        }

        components: [pointCloudCube, material, transform, mouseHandler]
    }
}
