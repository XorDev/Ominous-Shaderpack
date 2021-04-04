#version 120

uniform sampler2D depthtex1;
uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D colortex3;
uniform sampler2D colortex4;

varying vec2 coord0;

/* DRAWBUFFERS:0 */
void main()
{
    float dep = texture2D(depthtex1,coord0).r;
    vec4 tex = texture2D(colortex0,coord0);

    tex = (dep>=.99999) ? vec4(1) : vec4(tex.rgb,1);

    gl_FragData[0] = tex;
}
