package shaders;

import flixel.graphics.tile.FlxGraphicsShader;

class BloomShader extends FlxGraphicsShader
{
	@glFragmentSource("
	#pragma header
	// GAUSSIAN BLUR SETTINGS
	uniform float dim;
	uniform float Directions;
	uniform float Quality;
	uniform float Size;
	
	void main(void)
	{
	  vec2 uv = openfl_TextureCoordv.xy;
	  float Pi = 6.28318530718; // Pi*2.0
	  vec4 Color = texture2D(bitmap, uv);

	  vec2 radius = Size / openfl_TextureSize.xy;

	  for(int j = 0; j < 32; j++)
	  {
		  if (float(j) >= Directions) break;
		  
		  float d = float(j) * Pi / Directions;
		  vec2 dir = vec2(cos(d), sin(d)) * radius;
		  
		  for(int k = 1; k <= 8; k++)
		  {		
			  if (float(k) > Quality) break;
			  
			  float i = float(k) / Quality;
			  Color += flixel_texture2D(bitmap, uv + (dir * i));	
		  }
	  }

	  Color /= (dim * Quality) * Directions - 15.0;
	  vec4 bloom = (flixel_texture2D(bitmap, uv) / dim) + Color;
	  gl_FragColor = bloom;
	}
	")

	public function new()
	{
		super();

        dim.value = [1.8];
        Directions.value = [16.0];
        Quality.value = [8.0];
        Size.value = [8.0];
	}
}
