#version 120

uniform float blindness;

void main()
{
    gl_FragData[0] = vec4(vec3(1)-blindness,1);
}
