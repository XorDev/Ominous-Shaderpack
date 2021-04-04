#define Bloom_Quality 5 //[4 5 6 8]
//#define X_Bloom // Bloom in an "X" shape
#define Bloom_Pass3 //Toggles the third, medium-radius bloom pass. Disabling this will improve performance
#define Bloom_Pass4 //Toggles the fourth, high-radius bloom pass. Disabling this will improve performance

uniform float viewWidth;
uniform float viewHeight;
uniform sampler2D noisetex;
const int noiseTextureResolution = 64;
uniform int frameCounter;


float hash1(vec2 p)
{
	vec2 x = p*vec2(viewWidth,viewHeight);//+float(frameCounter);
	vec2 c = fract(x/float(noiseTextureResolution));
	return texture2D(noisetex,c).r*2.-1.;
}
vec2 hash2(vec2 p)
{
	vec2 x = p*vec2(viewWidth,viewHeight);//+float(frameCounter);
	vec2 c = fract(x/float(noiseTextureResolution));
	return texture2D(noisetex,c).gb*2.-1.;
}

vec4 blur(sampler2D t,vec2 c,float r)
{
	vec2 texel = 1./vec2(viewWidth,viewHeight);

    float weight = 0.;
    vec4 col = vec4(0);

    float d = 1.;
    vec2 samp = vec2(r,r)/float(Bloom_Quality);

	#ifdef X_Bloom
	mat2 ang = mat2(0,1,-1,0);
	#else
	mat2 ang = mat2(.73736882209777832,-.67549037933349609,.67549037933349609,.73736882209777832);
	#endif

	for(int i = 0;i<Bloom_Quality*Bloom_Quality;i++)
	{
        d += 1./d;
        samp *= ang;

        float w = 1./(d-1.);
        vec2 uv = c+ samp*(d-1.)*texel;

		col += texture2D(t,uv)*w;
        weight += w;
	}
    return col/weight;//+hash1(c-r)/128.;
}
