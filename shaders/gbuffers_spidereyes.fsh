#version 120

uniform sampler2D texture;

uniform float blindness;

varying vec2 coord0;

void main()
{
    vec4 tex = texture2D(texture,coord0);

    //if (tex.a<.5) discard;

    gl_FragData[0] = vec4(vec3(1)-blindness,tex.a);
}
