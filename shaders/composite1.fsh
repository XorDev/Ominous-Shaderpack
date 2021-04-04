#version 120

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D colortex3;
uniform sampler2D colortex4;

#include "lib/Blur.inc"

varying vec2 coord0;

/* DRAWBUFFERS:1 */
void main()
{
    vec4 b = blur(colortex0,coord0,4.);
    gl_FragData[0] = b;
}
