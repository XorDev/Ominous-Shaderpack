#version 120

#define Bloom_Amount .5 // [.0, .2 .4 .5 .6 .8 1.]
#define Soften // This softens the fog lighting

uniform sampler2D depthtex1;
uniform float near;
uniform float far;
uniform mat4 gbufferProjection;
uniform mat4 gbufferModelView;

const float eyeBrightnessHalflife = 1.0f;
const float shadowDistance = 160.0f;
const int shadowMapResolution = 1024;

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D colortex3;
uniform sampler2D colortex4;
uniform sampler2D colortex5;

#include "lib/Blur.inc"

varying vec2 coord0;

float depth(float d)
{
    return near*far/(near+far-d*(far-near));
}
void main()
{
    vec4 tex0 = texture2D(colortex0,coord0);
	vec4 tex1 = texture2D(colortex1,coord0);
	vec4 tex2 = texture2D(colortex2,coord0);
	vec4 tex3 = texture2D(colortex3,coord0);
    vec4 tex4 = texture2D(colortex4,coord0);
    float dep = depth(texture2D(depthtex1,coord0).r);
    vec4 tex5 = texture2D(colortex5,coord0);//
    #ifdef Soften
        float gray = dot(tex5,vec4(.299,.587,.114,0));
        tex5 = blur(colortex5,coord0,2.*gray);
    #endif

    vec4 col = tex0+(tex1+tex2+tex3+tex4)*Bloom_Amount;

    //tex5 *= pow(vec4(dep/far),vec4(1,.5,.2,1)*4.)*2.;
    gl_FragData[0] = col+tex5;//*pow(l,vec4(1.5));//dep/far+col*0.;
}
