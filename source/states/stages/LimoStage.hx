package states.stages;

import shaders.DropShadowShader;
import shaders.WaterShader;
import flixel.addons.display.FlxBackdrop;
import states.stages.objects.*;
import objects.Character;

class LimoStage extends BaseStage
{
    var waterShader:WaterShader;

    var sky:FlxSprite;
    var clouds:FlxBackdrop;
    var buildingsBack:FlxBackdrop;
    var buildingsFront:FlxBackdrop;
    var water:FlxSprite;
    var road:FlxBackdrop;
    var truck:FlxSprite;

	override function create()
	{
        sky = new FlxSprite();
        sky.loadGraphic(Paths.image('sky'));
        add(sky);

        clouds = new FlxBackdrop(Paths.image('clouds'), X, 20, 0);
        add(clouds);

        buildingsBack = new FlxBackdrop(Paths.image('buildingBack'), X, 0, 0);
        buildingsBack.y = 200;
        add(buildingsBack);

        buildingsFront = new FlxBackdrop(Paths.image('building'), X, 0, 0);
        buildingsFront.y = 200;
        add(buildingsFront);

        water = new FlxSprite();
        water.loadGraphic(Paths.image('water'));
        add(water);

        if(ClientPrefs.data.shaders)
        {
            waterShader = new WaterShader();
            waterShader.iTime.value = [0];
            water.shader = waterShader;
        }

        road = new FlxBackdrop(Paths.image('road'), X, 0, 0);
        add(road);

        truck = new FlxSprite();
        truck.loadGraphic(Paths.image('truck'));
        add(truck);

        applyVelocites();
	}

    function applyVelocites()
    {
        clouds.velocity.set(20, 0);
        buildingsBack.velocity.set(50, 0);
        buildingsFront.velocity.set(75, 0);
        road.velocity.set(3000, 0);
    }

    override function update(elapsed:Float)
    {
        waterShader.iTime.value[0] += elapsed;
    }

    override function createPost() 
    {
        var light:FlxSprite = new FlxSprite();
        light.loadGraphic(Paths.image('light'));
        light.blend = ADD;
        add(light);

		if(ClientPrefs.data.shaders)
		{
			// lights on characters
			var rimBF = new DropShadowShader();
			rimBF.setAdjustColor(0, 10, 0, 0);
			rimBF.color = 0xFFFEF9AA;
			game.boyfriend.shader = rimBF;
			rimBF.attachedSprite = game.boyfriend;
			rimBF.angle = 90;

			game.boyfriend.animation.callback = function()
			{
				if (game.boyfriend != null)
				{
					rimBF.updateFrameInfo(game.boyfriend.frame);
				}
			};

			var rimGF = new DropShadowShader();
			rimGF.setAdjustColor(0, 10, 0, 0);
			rimGF.color = 0xFFFEF9AA;
			game.gf.shader = rimGF;
			rimGF.attachedSprite = game.gf;
			rimGF.distance = 10;
			rimGF.angle = 90;

			game.gf.animation.callback = function()
			{
				if (game.gf != null)
				{
					rimGF.updateFrameInfo(game.gf.frame);
				}
			};

			var rimDad = new DropShadowShader();
			rimDad.setAdjustColor(0, 10, 0, 0);
			rimDad.color = 0xFFFEF9AA;
			game.dad.shader = rimDad;
			rimDad.attachedSprite = game.dad;
			rimDad.angle = 90;

			game.dad.animation.callback = function()
			{
				if (game.dad != null)
				{
					rimDad.updateFrameInfo(game.dad.frame);
				}
			};
		}
    }
}