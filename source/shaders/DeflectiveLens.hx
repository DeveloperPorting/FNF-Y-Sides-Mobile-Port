package shaders;

import flixel.system.FlxAssets.FlxShader;

class DeflectiveLens extends FlxShader
{
    @glFragmentSource('
	#pragma header
	
	#define round(a) floor(a + 0.5)
	#define iResolution vec3(openfl_TextureSize, 0.0)
	uniform float iTime;
	#define iChannel0 bitmap
	uniform sampler2D iChannel1;
	uniform sampler2D iChannel2;
	uniform sampler2D iChannel3;
	#define texture flixel_texture2D
	
	// variables which is empty, they need just to avoid crashing shader
	uniform float iTimeDelta;
	uniform float iFrameRate;
	uniform int iFrame;
	#define iChannelTime iTime
	#define iChannelResolution iResolution
	uniform vec4 iMouse;
	uniform vec4 iDate;
	
	const float pi = 3.14159265358979323846;
	const float epsilon = 1e-6;
	
	const float fringeExp = 2.3;
	const float fringeScale = 0.0;
	const float distortionExp = 2.0;
	uniform float distortionScale;
	
	const float startAngle = 1.23456 + pi;	// tweak to get different fringe colouration
	const float angleStep = pi * 2.0 / 3.0;	// space samples every 120 degrees
	
	void mainImage( out vec4 fragColor, in vec2 fragCoord )
	{
	    vec2 baseUV = fragCoord.xy / iResolution.xy;
	    vec2 fromCentre = baseUV - vec2(0.5, 0.5);
	    
	    // correct for aspect ratio
	    fromCentre.y *= iResolution.y / iResolution.x;
	    float radius = length(fromCentre);
	    fromCentre = radius > epsilon
	        ? (fromCentre * (1.0 / radius))
	        : vec2(0.0);
	    
	    float strength = 0.5 - (iMouse.x / iResolution.x);
	    float rotation = iMouse.y / iResolution.y * 2.0 * pi;
	    
	    float fringing = fringeScale * pow(radius, fringeExp) * strength;
	    float distortion = distortionScale * pow(radius, distortionExp) * strength;
	    
	    vec2 distortUV = baseUV - fromCentre * distortion;
	    
	    float angle;
	    vec2 dir;
	    
	    angle = startAngle + rotation;
	    dir = vec2(sin(angle), cos(angle));
	    vec4 redPlane = texture(iChannel0, distortUV + fringing * dir);
	    
	    angle += angleStep;
	    dir = vec2(sin(angle), cos(angle));
	    vec4 greenPlane = texture(iChannel0, distortUV + fringing * dir);
	    
	    angle += angleStep;
	    dir = vec2(sin(angle), cos(angle));
	    vec4 bluePlane = texture(iChannel0, distortUV + fringing * dir);
	    
	    fragColor = vec4(redPlane.r, greenPlane.g, bluePlane.b, texture(iChannel0, distortUV).a);
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