package shaders;

import flixel.graphics.tile.FlxGraphicsShader;

class BloomShader extends FlxGraphicsShader
{
	@glFragmentSource("
	#pragma header
	
	uniform float dim;
	uniform float Directions;
	uniform float Quality;
	uniform float Size;
	
	void main(void)
	{
	  vec2 uv = openfl_TextureCoordv.xy;
	  
	  float safeDirs = clamp(Directions, 1.0, 64.0);
	  float safeQual = clamp(Quality, 1.0, 16.0);
	  
	  vec4 Color = texture2D(bitmap, uv);
	  
	  vec2 radiusStep = (Size / openfl_TextureSize.xy) / safeQual;
	  float angleStep = 6.28318530718 / safeDirs;

	  for(int j = 0; j < 64; j++)
	  {
		  if (float(j) >= safeDirs) break;
		  
		  float d = float(j) * angleStep;
		  vec2 dir = vec2(cos(d), sin(d)) * radiusStep;
		  
		  for(int k = 1; k <= 16; k++)
		  {		
			  if (float(k) > safeQual) break;
			  
			  Color += flixel_texture2D(bitmap, uv + (dir * float(k)));	
		  }
	  }

	  Color /= (dim * safeQual) * safeDirs - 15.0;
	  
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
