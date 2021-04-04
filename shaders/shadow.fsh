#version 120

uniform sampler2D texture;


varying vec4 color;
varying vec2 coord0;

void main()
{
    vec4 tex = color * texture2D(texture,coord0);
    gl_FragData[0] = tex;
}
