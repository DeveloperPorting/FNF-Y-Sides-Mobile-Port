package shaders;

import flixel.system.FlxAssets.FlxShader;

class GlitchFragmentShader extends FlxShader
{
	@glFragmentSource('
	
	#pragma header
	
	uniform float iTime;
	uniform float GLITCH_THR;
	uniform float GLITCH_RECT_DIVISION;
	uniform int GLITCH_RECT_ITR;
	
	// MODE set effect type.
	// 0 : no effect
	// 1 : color 
	// 2 : uv.x slip if glitched
	// 3 : inverse
	// 4 : uv shift glitch
	// 5 : rgb shift
	#define ENABLE_MODE 2
	#define MODE 5
	
	float hash(in float v) { return fract(sin(v) * 43768.5453); }
	float hash(in vec2 v) { return fract(sin(dot(v, vec2(12.9898, 78.233))) * 43768.5453); }
	vec2 hash2(in float v) { return vec2(hash(v + 77.77), hash(v + 999.999)); }
	vec2 hash2(in vec2 v) { return vec2(hash(v + vec2(77.77)), hash(v + vec2(999.999))); }
	
	vec3 glitch(in vec2 p, in float seed) {
	    float g = -1.0;
	    
	    for(int i = 0; i < 16; i++) {
	        if (i >= GLITCH_RECT_ITR) break;
	        
	        float fi = float(i) + 1.0;
	        float fis = fi + seed;
	        
	        float h = hash(fis);
	        vec2 h2 = hash2(fis);
	
	        vec2 q = p * GLITCH_RECT_DIVISION * fi + h2;
	        q *= h2 * 2.0 - 1.0; 
	        
	        vec2 iq = floor(q);
	        float hq = hash(iq);
	        
	        if(hq < GLITCH_THR) {
	            p += hash2(iq) * 2.0 - 1.0;
	            g = h;
	        }
	    }
	    return vec3(fract(p), g);
	}
	
	void main()
	{
	    vec2 uv = openfl_TextureCoordv.xy;
	    float gps = 15.0;
	    vec3 g = glitch(uv, floor(iTime * gps) / gps);
	    
	    vec3 col = vec3(0.0);
	    
	    #if ENABLE_MODE == 0
	        float m = mod(iTime, 6.0);
	        if (m < 1.0) { col = flixel_texture2D(bitmap, uv).rgb; }
	        else if (m < 2.0) { col = g.z < 0.0 ? flixel_texture2D(bitmap, uv).rgb : g.z * flixel_texture2D(bitmap, uv).rgb; }
	        else if (m < 3.0) { col = g.z < 0.0 ? flixel_texture2D(bitmap, uv).rgb : flixel_texture2D(bitmap, uv + vec2(0.1 * (g.z * 2.0 - 1.0), 0.0)).rgb; }
	        else if (m < 4.0) { col = g.z < 0.0 ? flixel_texture2D(bitmap, uv).rgb : 1.0 - flixel_texture2D(bitmap, uv).rgb; }
	        else if (m < 5.0) { col = g.z < 0.0 ? flixel_texture2D(bitmap, uv).rgb : flixel_texture2D(bitmap, g.xy).rgb; }
	        else { 
	            vec3 shift = g.z * vec3(0.16, 0.04, -0.8);
	            col = g.z < 0.0 ? flixel_texture2D(bitmap, uv).rgb : vec3(flixel_texture2D(bitmap, uv + vec2(shift.r, 0.0)).r, flixel_texture2D(bitmap, uv + vec2(shift.g, 0.0)).g, flixel_texture2D(bitmap, uv + vec2(shift.b, 0.0)).b); 
	        }
	    #else
	        #if MODE == 0
	            col = flixel_texture2D(bitmap, uv).rgb;
	        #elif MODE == 1
	            col = g.z < 0.0 ? flixel_texture2D(bitmap, uv).rgb : g.z * flixel_texture2D(bitmap, uv).rgb;
	        #elif MODE == 2
	            col = g.z < 0.0 ? flixel_texture2D(bitmap, uv).rgb : flixel_texture2D(bitmap, uv + vec2(0.1 * (g.z * 2.0 - 1.0), 0.0)).rgb;
	        #elif MODE == 3
	            col = g.z < 0.0 ? flixel_texture2D(bitmap, uv).rgb : 1.0 - flixel_texture2D(bitmap, uv).rgb;
	        #elif MODE == 4
	            col = g.z < 0.0 ? flixel_texture2D(bitmap, uv).rgb : flixel_texture2D(bitmap, g.xy).rgb;
	        #elif MODE == 5
	            vec3 shift = g.z * vec3(0.16, 0.04, -0.8);
	            col = g.z < 0.0 ? flixel_texture2D(bitmap, uv).rgb : vec3(
	                flixel_texture2D(bitmap, uv + vec2(shift.r, 0.0)).r, 
	                flixel_texture2D(bitmap, uv + vec2(shift.g, 0.0)).g, 
	                flixel_texture2D(bitmap, uv + vec2(shift.b, 0.0)).b
	            );
	        #endif
	    #endif
	
	    // Output to screen
	    gl_FragColor = vec4(col, flixel_texture2D(bitmap, uv).a);
	}
	
	')

	public function new()
	{
		super();
		
		iTime.value = [0];
		GLITCH_THR.value = [0.09];
		GLITCH_RECT_DIVISION.value = [5.0];
		GLITCH_RECT_ITR.value = [2];
	}
}