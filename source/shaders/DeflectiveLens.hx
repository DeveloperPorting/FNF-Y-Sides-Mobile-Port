package shaders;

import flixel.system.FlxAssets.FlxShader;

class DeflectiveLens extends FlxShader
{
    @glFragmentSource('
	#pragma header
	
	uniform float iTime;
	uniform vec4 iMouse;
	uniform float distortionScale;
	
	vec4 flixel_texture2D(sampler2D bitmap, vec2 coord) {
	    vec4 color = texture2D(bitmap, coord);
	    if (!hasTransform) {
	        return color;
	    }
	    if (color.a == 0.0) {
	        return vec4(0.0);
	    }
	    if (!hasColorTransform) {
	        return color * openfl_Alphav;
	    }
	    color = vec4(color.rgb / color.a, color.a);
	    mat4 colorMultiplier = mat4(0.0);
	    colorMultiplier[0][0] = openfl_ColorMultiplierv.x;
	    colorMultiplier[1][1] = openfl_ColorMultiplierv.y;
	    colorMultiplier[2][2] = openfl_ColorMultiplierv.z;
	    colorMultiplier[3][3] = openfl_ColorMultiplierv.w;
	    color = clamp(openfl_ColorOffsetv + (color * colorMultiplier), 0.0, 1.0);
	    if (color.a > 0.0) {
	        return vec4(color.rgb * color.a * openfl_Alphav, color.a * openfl_Alphav);
	    }
	    return vec4(0.0);
	}
	
	void main() {
	    vec2 baseUV = openfl_TextureCoordv.xy;
	    vec2 fromCentre = baseUV - 0.5;
	    fromCentre.y *= openfl_TextureSize.y / openfl_TextureSize.x;
	    
	    float radius = length(fromCentre);
	    float strength = 0.5 - (iMouse.x / openfl_TextureSize.x);
	    
	    vec2 distortUV = baseUV - fromCentre * (distortionScale * radius * strength);
	    
	    float fringing = 0.0 * pow(radius, 2.3) * strength;
	    float rotation = (iMouse.y / openfl_TextureSize.y) * 6.28318530718;
	    
	    float a1 = 4.37615265 + rotation;
	    float a2 = a1 + 2.0943951;
	    float a3 = a2 + 2.0943951;
	    
	    vec2 d1 = vec2(sin(a1), cos(a1)) * fringing;
	    vec2 d2 = vec2(sin(a2), cos(a2)) * fringing;
	    vec2 d3 = vec2(sin(a3), cos(a3)) * fringing;
	    
	    float r = flixel_texture2D(bitmap, distortUV + d1).r;
	    float g = flixel_texture2D(bitmap, distortUV + d2).g;
	    float b = flixel_texture2D(bitmap, distortUV + d3).b;
	    float a = flixel_texture2D(bitmap, distortUV).a;
	    
	    gl_FragColor = vec4(r, g, b, a);
	}
	')

    public function new()
    {
        super();
    	distortionScale.value = [0.3]; // default moved here
    }
}