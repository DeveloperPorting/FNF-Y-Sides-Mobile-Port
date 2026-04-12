package states;

import flixel.graphics.frames.FlxBitmapFont;
import flixel.text.FlxBitmapText;

class NewStoryMenuState extends MusicBeatState
{
	public static var weekCompleted:Map<String, Bool> = new Map<String, Bool>();
	public static var backFromStoryMode:Bool = false;

	var songTextTemp:FlxBitmapText;

    override function create()
    {
        super.create();

		var fontLetters:String = "abcgipydefhjqzklmnorstuvwx";
		songTextTemp = new FlxBitmapText(FlxBitmapFont.fromMonospace(Paths.image("storymenu/new/storyfont"), fontLetters, FlxPoint.get(42, 56)));
		songTextTemp.text = "";
		songTextTemp.antialiasing = ClientPrefs.data.antialiasing;
        songTextTemp.text = 'hola gbv princesa';
        songTextTemp.screenCenter();
        add(songTextTemp);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if(controls.BACK)
        {
            MusicBeatState.switchState(new MainMenuState());
        }
    }
}