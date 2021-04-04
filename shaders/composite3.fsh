#version 120

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D colortex3;
uniform sampler2D colortex4;

#include "lib/Blur.inc"

varying vec2 coord0;

/* DRAWBUFFERS:3 */
void main()
{
    vec4 b = vec4(0);
    #ifdef Bloom_Pass3
        b = blur(colortex2,coord0,48.);
    #endif

    gl_FragData[0] = b;
}
