#version 120

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D colortex3;
uniform sampler2D colortex4;

#include "lib/Blur.inc"

varying vec2 coord0;

/* DRAWBUFFERS:4 */
void main()
{
    vec4 b = vec4(0);
    #ifdef Bloom_Pass4
        b = blur(colortex3,coord0,144.);
    #endif

    gl_FragData[0] = b;
}
