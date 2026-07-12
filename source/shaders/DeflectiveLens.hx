package shaders;

import flixel.system.FlxAssets.FlxShader;

class DeflectiveLens extends FlxShader
{
    @glFragmentSource('
	#pragma header
	
	uniform float iTime;
	uniform sampler2D iChannel1;
	uniform sampler2D iChannel2;
	uniform sampler2D iChannel3;
	uniform float iTimeDelta;
	uniform float iFrameRate;
	uniform int iFrame;
	uniform vec4 iMouse;
	uniform vec4 iDate;
	uniform float distortionScale;
	
	#define round(a) floor(a + 0.5)
	#define iResolution vec3(openfl_TextureSize, 0.0)
	#define iChannel0 bitmap
	#define texture flixel_texture2D
	#define iChannelTime iTime
	#define iChannelResolution iResolution
	
	const float pi = 3.14159265358979323846;
	const float fringeExp = 2.3;
	const float fringeScale = 0.0; 
	const float distortionExp = 2.0;
	
	const float startAngle = 4.37615265; // 1.23456 + pi
	const float angleStep = 2.0943951;   // pi * 2.0 / 3.0
	
	void mainImage( out vec4 fragColor, in vec2 fragCoord )
	{
	    vec2 baseUV = fragCoord.xy / iResolution.xy;
	    vec2 fromCentre = baseUV - 0.5;
	    
	    fromCentre.y *= iResolution.y / iResolution.x;
	    float radius = length(fromCentre);
	    
	    float strength = 0.5 - (iMouse.x / iResolution.x);
	    
	    vec2 distortUV = baseUV - fromCentre * (distortionScale * radius * strength);
	    
	    float fringing = fringeScale * pow(radius, fringeExp) * strength;
	    
	    if (fringing == 0.0) {
	        fragColor = texture(iChannel0, distortUV);
	        return;
	    }
	    
	    float rotation = (iMouse.y / iResolution.y) * 6.2831853; // 2.0 * pi
	    float angle = startAngle + rotation;
	    
	    vec2 dir = vec2(sin(angle), cos(angle));
	    float r = texture(iChannel0, distortUV + fringing * dir).r;
	    
	    angle += angleStep;
	    dir = vec2(sin(angle), cos(angle));
	    float g = texture(iChannel0, distortUV + fringing * dir).g;
	    
	    angle += angleStep;
	    dir = vec2(sin(angle), cos(angle));
	    vec4 bluePlane = texture(iChannel0, distortUV + fringing * dir);
	    
	    fragColor = vec4(r, g, bluePlane.b, bluePlane.a);
	}
	
	void main() {
	    mainImage(gl_FragColor, openfl_TextureCoordv * openfl_TextureSize);
	}
	')

    public function new()
    {
        super();
    	distortionScale.value = [0.3]; // default moved here
    }
}