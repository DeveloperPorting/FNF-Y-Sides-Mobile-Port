package options;

import flixel.addons.display.FlxBackdrop;

class SaveFilesMenu extends MusicBeatState
{
    override function create()
    {
        super.create();

        FlxG.mouse.visible = true;

		var bg:FlxSprite = new FlxSprite().makeGraphic(1280, 720, 0xFFBFB4F1);
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.updateHitbox();

		bg.screenCenter();
		add(bg);

        var triangleTop:FlxBackdrop = new FlxBackdrop(Paths.image('resultsScreen/newResultsScreen/lettaBoxDark'), X, 0, 0);
        triangleTop.velocity.set(10, 0);
        triangleTop.angle = 180;
        add(triangleTop);

        var triangleBottom:FlxBackdrop = new FlxBackdrop(Paths.image('resultsScreen/newResultsScreen/lettaBoxDark'), X, 0, 0);
        triangleBottom.velocity.set(-10, 0);
        triangleBottom.y = FlxG.height - triangleBottom.height;
        add(triangleBottom);
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ESCAPE)
        {
            MusicBeatState.switchState(new OptionsState());
        }
    }
}