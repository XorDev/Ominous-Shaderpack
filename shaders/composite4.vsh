#version 120

varying vec2 coord0;

void main()
{
    gl_Position = ftransform();

    coord0 = (gl_MultiTexCoord0).xy;
}
