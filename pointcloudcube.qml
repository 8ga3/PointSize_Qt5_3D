import Qt3D.Render 2.0

GeometryRenderer {
    id: root
    primitiveType: GeometryRenderer.Points

    property int count: 10000

    Buffer {
        id: vertexBuffer
        type: Buffer.VertexBuffer
        data: createRandomGeometry(root.count)
    }

    geometry: Geometry{
        // Vertex (x, y, z)
        Attribute{
            name: defaultPositionAttributeName
            attributeType: Attribute.VertexAttribute
            vertexBaseType: Attribute.Float
            vertexSize: 3     // x, y, z
            byteOffset: 0
            byteStride: 6 * 4 // (x, y, z, r, g, b) * sizeof(float)
            count: root.count
            buffer: vertexBuffer
        }
        // Color (r, g, b)
        Attribute {
            name: defaultColorAttributeName
            attributeType: Attribute.VertexAttribute
            vertexBaseType: Attribute.Float
            vertexSize: 3     // r, g, b
            byteOffset: 3 * 4
            byteStride: 6 * 4 // (x, y, z, r, g, b) * sizeof(float)
            count: root.count
            buffer: vertexBuffer
        }
    }

    function createRandomGeometry(conunt) {
        const size = count;
        var position = new Float32Array(size * 6);
        for (var i=0; i < count; i++) {
            var x = Math.random() * 10.0 - 5.0;
            var y = Math.random() * 10.0 - 5.0;
            var z = Math.random() * 10.0 - 5.0;
            var h = (y + 5.0) / 10.0;
            var vec3 = hsv(h, 0.8, 0.95);

            position[i*6+0] = x;
            position[i*6+1] = y;
            position[i*6+2] = z;
            position[i*6+3] = vec3.x;
            position[i*6+4] = vec3.y;
            position[i*6+5] = vec3.z;
        }
        return position;
    }

    function hsv(h, s, v) {
        let hh = h * 6.0;
        if (hh >= 6.0) hh = 0;
        let i = Math.floor(hh);
        let f = hh - i;
        let p = v * (1.0 - s);
        let q = v * (1.0 - (s * f));
        let t = v * (1.0 - (s * (1.0 - f)));
        let r, g, b;

        switch(i) {
        case 0:
            r = v;
            g = t;
            b = p;
            break;
        case 1:
            r = q;
            g = v;
            b = p;
            break;
        case 2:
            r = p;
            g = v;
            b = t;
            break;

        case 3:
            r = p;
            g = q;
            b = v;
            break;
        case 4:
            r = t;
            g = p;
            b = v;
            break;
        case 5:
        default:
            r = v;
            g = p;
            b = q;
            break;
        }

        return Qt.vector3d(r, g, b);
    }
}
