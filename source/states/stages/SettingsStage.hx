package states.stages;

import flixel.addons.display.FlxBackdrop;
import shaders.DeflectiveLens;
import openfl.filters.ShaderFilter;
import shaders.BloomShader;
import shaders.ChromaticAberration;
import shaders.GlitchFragmentShader;

class SettingsStage extends BaseStage
{
    var icons:FlxBackdrop;
    override function create()
    {
        var bg = new FlxSprite(-1000, -1000);
        bg.loadGraphic(Paths.image('stages/settingsStage/bg'));
        bg.antialiasing = ClientPrefs.data.antialiasing;
        add(bg);

        icons = new FlxBackdrop(Paths.image('mainmenu/icons'));
        icons.antialiasing = ClientPrefs.data.antialiasing;
        icons.velocity.set(-150, -150);
        add(icons);
    }

	var deflectiveLensShader:DeflectiveLens;
	var deflectiveLensFilter:ShaderFilter;
    var bloomShader:BloomShader;
    var bloomFilter:ShaderFilter;
	var chromaticAberration:ChromaticAberration;
    var chromaticAberrationFilter:ShaderFilter;
    var glitchShader:GlitchFragmentShader;
    var glitchFilter:ShaderFilter;
    override function createPost()
    {
        if(ClientPrefs.data.shaders)
        {
			deflectiveLensShader = new DeflectiveLens();
			deflectiveLensShader.distortionScale.value = [0.0];
			deflectiveLensFilter = new ShaderFilter(deflectiveLensShader);
			FlxG.camera.filters = [deflectiveLensFilter];

            bloomShader = new BloomShader();
			bloomShader.dim.value = [2.0]; // 1.8
			bloomShader.Directions.value = [20.0]; // 2.0, 100.0 to remove
			bloomShader.Quality.value = [8.0]; // 8.0
			bloomShader.Size.value = [4.0]; // 8.0, 1.0

			bloomFilter = new ShaderFilter(bloomShader);
			FlxG.camera.filters.push(bloomFilter);

			chromaticAberration = new ChromaticAberration();
			chromaticAberration.rOffset.value = [0.001];
			chromaticAberration.gOffset.value = [0.0];
			chromaticAberration.bOffset.value = [-0.001];

			chromaticAberrationFilter = new ShaderFilter(chromaticAberration);
			FlxG.camera.filters.push(chromaticAberrationFilter);

			glitchShader = new GlitchFragmentShader();
			glitchShader.GLITCH_THR.value = [0.0]; // velocity //// 0.01
			glitchShader.GLITCH_RECT_DIVISION.value = [0]; // size (more high, more small) name also say it, """""division""""" //// 5
			glitchShader.GLITCH_RECT_ITR.value = [0]; // its like make it more glitchy ////

			glitchFilter = new ShaderFilter(glitchShader);
			FlxG.camera.filters.push(glitchFilter);
        }
    }

    override function update(elapsed:Float)
    {
		if (glitchShader != null) glitchShader.iTime.value[0] += elapsed;
    }

    override function stepHit()
    {
        switch(curStep)
        {
            case 144:
			    deflectiveLensShader.distortionScale.value = [0.5];

                chromaticAberration.rOffset.value = [0.0015];
                chromaticAberration.gOffset.value = [0.0];
                chromaticAberration.bOffset.value = [-0.0015];

                FlxTween.num(1.65, 2, 0.96, {ease: FlxEase.quartOut}, function(v:Float) { bloomShader.dim.value[0] = v; } );
                FlxTween.num(3, 20, 0.96, {ease: FlxEase.quartOut}, function(v:Float) { bloomShader.Directions.value[0] = v; } );
            case 528:
			    deflectiveLensShader.distortionScale.value = [0.55];

                chromaticAberration.rOffset.value = [0.002];
                chromaticAberration.gOffset.value = [0.0];
                chromaticAberration.bOffset.value = [-0.002];

                icons.velocity.set(-250, -250);

                glitchShader.GLITCH_THR.value = [0.005]; // velocity //// 0.01
                glitchShader.GLITCH_RECT_DIVISION.value = [7]; // size (more high, more small) name also say it, """""division""""" //// 5
                glitchShader.GLITCH_RECT_ITR.value = [2]; // its like make it more glitchy ////

                FlxTween.num(1.65, 2, 0.96, {ease: FlxEase.quartOut}, function(v:Float) { bloomShader.dim.value[0] = v; } );
                FlxTween.num(3, 20, 0.96, {ease: FlxEase.quartOut}, function(v:Float) { bloomShader.Directions.value[0] = v; } );
            case 656:
			    deflectiveLensShader.distortionScale.value = [0.5];

                chromaticAberration.rOffset.value = [0.0015];
                chromaticAberration.gOffset.value = [0.0];
                chromaticAberration.bOffset.value = [-0.0015];

                icons.velocity.set(-150, -150);

                glitchShader.GLITCH_THR.value = [0.0]; // velocity //// 0.01
                glitchShader.GLITCH_RECT_DIVISION.value = [0]; // size (more high, more small) name also say it, """""division""""" //// 5
                glitchShader.GLITCH_RECT_ITR.value = [0]; // its like make it more glitchy ////
        }
    }
}