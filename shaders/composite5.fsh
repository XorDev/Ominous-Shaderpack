#version 120

#define Light_Quality 40 // [10 20 40 60 100 200] Number of light volume samples. Higher = slower
#define Soften // This softens the fog lighting
#define Fog_Brightness 8 // [4 6 8 10 12 16] Total output brightness from the fog
#define Water_Density 2. // [0. 1. 2. 3. 4. 5.] Fog density in water

#define Fog_Scale 5. // [1. 3. 5. 8.] A small scale makes the color changes more frequent. Higher makes them more rare.
#define Fog_Cycle_Speed 1. // [0. 1. 10. 500. 10000.] This controls the rate the fog changes over time. By default it takes 100s of days
#define Fog_Min .2 // [.0 .1 .2 .3 .4] //Fog minimum brightness. This sets how bright it is in the shadows
//#define Fog_Custom_Color //If enabled, it uses the custom red, green and blue fog colors below.
#define Fog_Red .4 // [.0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1.] Red brightness between 0 and 1
#define Fog_Green .5 // [.0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1.] Green brightness between 0 and 1
#define Fog_Blue .8 // [.0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1.] Blue brightness between 0 and 1

uniform sampler2D depthtex0;
uniform sampler2D depthtex1;
uniform sampler2D shadowtex1;
uniform float near;
uniform float far;
uniform int isEyeInWater;
uniform ivec2 eyeBrightnessSmooth;
uniform mat4 shadowModelView;
uniform mat4 gbufferProjection;
uniform mat4 gbufferModelView;
uniform vec3 cameraPosition;
uniform int worldDay;
uniform int worldTime;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;

const float eyeBrightnessHalflife = 4.0f;
const float shadowDistance = 160.0f;
const int shadowMapResolution = 1024;

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D colortex3;
uniform sampler2D colortex4;

#include "lib/Blur.inc"

varying vec2 coord0;

float depth(float d)
{
    return near*far/(near+far-d*(far-near));
}
vec4 fog(vec3 p,float i)
{
    vec3 col = vec3(Fog_Red,Fog_Green,Fog_Blue);

    #ifndef Fog_Custom_Color
        float pos = dot((p+cameraPosition)/1e2,vec3(1,3,2))/Fog_Scale;
        vec3 ang = pos+vec3(0,.333,.666)+float(worldDay*24000+worldTime)/4e6*Fog_Cycle_Speed;
        vec3 ex = cos(ang*6.2831);
        float m1 = min(ex.r,min(ex.g,ex.b))-1.;
        float m2 = max(ex.r,max(ex.g,ex.b))+1.;
        col = smoothstep(m1,m2,ex);
    #endif

    return vec4(pow(vec3(i), 1.-col),1);
}

/* DRAWBUFFERS:5 */
void main()
{
    vec4 proj = gbufferProjectionInverse * vec4(coord0 * 2. - 1.,1,1);
    proj = gbufferModelViewInverse * vec4(proj.xyz/proj.w,1);
    vec3 dir = (proj.xyz)/far/2.;
    float dep = depth(texture2D(depthtex1,coord0).r);
    float wdep = depth(texture2D(depthtex0,coord0).r)/dep;
    float size = 1./float(Light_Quality);
    vec4 l = vec4(0);
    float flip = (isEyeInWater>0)?-1.:1.;

    float i = 1.-size*(hash1(coord0)*.499+.501);
    vec4 h = vec4(hash2(coord0),hash2(coord0+1.))*.5;

    vec2 off = vec2(0);
    #ifdef Soften
        off = hash2(coord0)*dep/far/size*.04;
    #endif
    mat2 ang = mat2(.73736882209777832,-.67549037933349609,.67549037933349609,.73736882209777832);

    float b = mix(sqrt(float(240-eyeBrightnessSmooth.y)/240.),1.,Fog_Min);
    for(;i>0.;i-=size)
    {

        float d = i;
        vec4 sp = shadowModelView*(vec4(dir*dep*d,0) + gbufferModelViewInverse[3]);
        off *= ang;//hash2(coord0+i)*.5;
        float s = b+step(-.5,texture2D(shadowtex1,(sp.xy+off)/shadowDistance*.5+.5).r*255.+sp.z);
        float ll = clamp((d-wdep)*dep/abs(dir.y)*flip,0.,1.);
        float w = 1.+Water_Density*float(wdep<i);// ^^ isEyeInWater>0);
        vec4 t = fog(dir*dep*d,dep/far*d*w)*vec4(s,s,s,1)*w*vec4(dep/far*vec3(Fog_Brightness),1);
        l += t*size;
    }
    //l = mix(l,vec4(1),smoothstep(.9,1.,wdep)*smoothstep(1.,.9999,wdep));

    gl_FragData[0] = l;///l.a;
}
