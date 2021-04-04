#version 120

uniform sampler2D texture;

uniform float blindness;
uniform int isEyeInWater;

varying vec4 color;
varying vec2 coord0;

void main()
{
    discard;
    vec3 light = vec3(1.-blindness);
    vec4 col = color * vec4(light,1) * texture2D(texture,coord0);

    gl_FragData[0] = col*0.;
}
