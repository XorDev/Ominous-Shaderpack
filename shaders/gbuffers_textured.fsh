#version 120

#define Tex_Brightness 1. // [0. 1. 3. 5. 10. 20.]
#define Tex_Range 10. // [5. 10. 20. 40. 60.]

uniform sampler2D texture;
uniform sampler2D lightmap;

uniform vec4 entityColor;
uniform float blindness;
uniform int entityId;

varying vec4 color;
varying vec2 coord0;
varying vec2 coord1;
varying float glow;

void main()
{
    vec4 tex = color * texture2D(texture,coord0);
    float gray = dot(tex,vec4(.299,.587,.114,0));
    vec4 col = tex;
    col.rgb = vec3(gray*gray)*max(1.-gl_FogFragCoord/Tex_Range,0.)*Tex_Brightness/100.;

    col.rgb = mix(col.rgb,sqrt(entityColor.rgb),entityColor.a);
	col.rgb += pow(coord1.x,6.)*(.2+.2*gray)+glow;
    gl_FragData[0] = col+float(entityId==1001);
}
