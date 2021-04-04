#version 120

uniform int entityId;
uniform vec3 cameraPosition;
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;

varying vec4 color;
varying vec2 coord0;

void main()
{
    vec4 pos = gl_ModelViewProjectionMatrix * gl_Vertex;
    gl_Position = pos*float(entityId<1000);

    color = gl_Color;
    coord0 = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
}
