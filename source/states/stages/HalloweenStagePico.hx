package states.stages;

class HalloweenStagePico extends BaseStage
{
    var blackBackground:FlxSprite;
	override function create()
	{
		if(!ClientPrefs.data.lowQuality)
		{
            var sky:BGSprite = new BGSprite('stages/halloweenStage/sky', -1248 + 250, -1041, 0, 0);
            add(sky);

            var moon:BGSprite = new BGSprite('stages/halloweenStage/moon', 485, -805, 0.1, 0.1);
            add(moon);

            var clouds:BGSprite = new BGSprite('stages/halloweenStage/clouds', -1286, -1146, 0.2, 0.2);
            add(clouds);
        }
                
        var buildings:BGSprite = new BGSprite('stages/halloweenStage/buildings', -1038, -885, 0.6, 0.6);
        add(buildings);

        var bgmain:BGSprite = new BGSprite('stages/halloweenStage/bgmain', -730, -878, 1, 1);
        add(bgmain);

		if(!ClientPrefs.data.lowQuality)
		{
            var lolas:BGSprite = new BGSprite('stages/halloweenStage/lolas', -17, 263, 1, 1, ['persjnaoi'], true);
            add(lolas);
        }

        blackBackground = new FlxSprite();
        blackBackground.makeGraphic(FlxG.width * 3, FlxG.height * 3, 0xFF000000);
        blackBackground.scrollFactor.set(0, 0);
        blackBackground.screenCenter();
        blackBackground.alpha = 0;
        add(blackBackground);
	}

	override function createPost()
	{

	}

    var maxAlpha:Float = 0.25;
	override function stepHit()
	{
        trace(game.curSong);
        switch(game.curSong)
        {
            case 'South':
                switch(curStep)
                {
                    case 399:
                        FlxTween.tween(blackBackground, {alpha: maxAlpha / 1.3}, 0.15);
                    case 416:
                        blackBackground.alpha = 0;
                    case 655:
                        FlxTween.tween(blackBackground, {alpha: maxAlpha / 1.3}, 0.15);
                    case 672:
                        FlxTween.tween(blackBackground, {alpha: maxAlpha}, 0.35);
                    case 911:
                        FlxTween.tween(blackBackground, {alpha: maxAlpha / 1.3}, 0.15);
                    case 928:
                        blackBackground.alpha = 0;
                }
        }
	}
}