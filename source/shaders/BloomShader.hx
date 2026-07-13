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
	  vec4 Color = texture2D(bitmap, uv);

	  vec2 radiusStep = (Size / openfl_TextureSize.xy) / Quality;

	  for(int j = 0; j < 32; j++)
	  {
		  if (float(j) >= Directions) break;
		  
		  float d = float(j) * 6.28318530718 / Directions;
		  vec2 dir = vec2(cos(d), sin(d)) * radiusStep;
		  
		  for(int k = 1; k <= 8; k++)
		  {		
			  if (float(k) > Quality) break;
			  
			  Color += texture2D(bitmap, uv + (dir * float(k)));	
		  }
	  }

	  Color /= (dim * Quality) * Directions - 15.0;
	  vec4 bloom = (flixel_texture2D(bitmap, uv) / dim) + (Color * openfl_Alphav);
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
