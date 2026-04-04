package states.gallery;

import flixel.addons.display.FlxBackdrop;
import states.gallery.GalleryState.GalleryStateImages;
import shaders.WaterShader;
import haxe.Json;

class NewGalleryState extends MusicBeatState
{
    private static var curSelected:Int = 0;
    private static var curSelectedImages:Int = 0;

    var optionsGrp:FlxTypedGroup<GalleryObject>;
    var optionsArr:Array<String> = [
        'outdated_concepts',
        'music',
        'bored'
    ];

    var bg:FlxSprite;
    var leftDownBars:FlxSprite;
    var icons:FlxBackdrop;
    var polo:FlxSprite;
    var galleryTheme:FlxSprite;
    var disk:FlxSprite;
    var leftArrow:FlxSprite;
    var rightArrow:FlxSprite;

    var waterShader:WaterShader;

    // Images section
    var imagesGrp:FlxTypedGroup<GalleryObject>;
    var imageDataArray:Array<Dynamic> = [];

    override function create()
    {
        super.create();

		if(FlxG.sound.music != null)
		{
			if(!FlxG.sound.music.playing)
			{
				trace('Main menu music is not playing, starting gallery menu music!');
                FlxG.sound.playMusic(Paths.music('galleryMenu'), 0);
				FlxG.sound.music.fadeIn(1);
			}
		}

        waterShader = new WaterShader();
        waterShader.iTime.value = [0];

        bg = new FlxSprite();
        bg.loadGraphic(Paths.image('gallery/NEW/bg'));
        bg.antialiasing = ClientPrefs.data.antialiasing;
        bg.shader = waterShader;
        add(bg);

        optionsGrp = new FlxTypedGroup<GalleryObject>();
        add(optionsGrp);

        imagesGrp = new FlxTypedGroup<GalleryObject>();
        add(imagesGrp);

        leftDownBars = new FlxSprite();
        leftDownBars.loadGraphic(Paths.image('gallery/NEW/leftDownBars'));
        leftDownBars.antialiasing = ClientPrefs.data.antialiasing;
        add(leftDownBars);

        icons = new FlxBackdrop(Paths.image('gallery/NEW/icons'), Y, 0, -15);
        icons.velocity.set(0, 15);
        icons.antialiasing = ClientPrefs.data.antialiasing;
        icons.blend = ADD;
        add(icons);

        galleryTheme = new FlxBackdrop(Paths.image('gallery/NEW/galleryTheme'), X, 50);
        galleryTheme.x = 375;
        galleryTheme.y = 653;
        galleryTheme.antialiasing = ClientPrefs.data.antialiasing;
        galleryTheme.velocity.set(-20, 0);
        add(galleryTheme);

        polo = new FlxSprite();
        polo.loadGraphic(Paths.image('gallery/NEW/polo'));
        polo.antialiasing = ClientPrefs.data.antialiasing;
        add(polo);

        disk = new FlxSprite(37, 490);
        disk.loadGraphic(Paths.image('gallery/NEW/disk'));
        disk.antialiasing = ClientPrefs.data.antialiasing;
        add(disk);

        leftArrow = new FlxSprite(430, 0);
        leftArrow.frames = Paths.getSparrowAtlas('gallery/NEW/arrow');
        leftArrow.animation.addByPrefix('idle', 'idle', 2, true);
        leftArrow.animation.addByPrefix('press', 'press', 24, false);
        leftArrow.animation.play('idle');
        leftArrow.antialiasing = ClientPrefs.data.antialiasing;
        leftArrow.screenCenter(Y);
        add(leftArrow);

        rightArrow = new FlxSprite(1080, 0);
        rightArrow.frames = Paths.getSparrowAtlas('gallery/NEW/arrow');
        rightArrow.animation.addByPrefix('idle', 'idle', 2, true);
        rightArrow.animation.addByPrefix('press', 'press', 24, false);
        rightArrow.animation.play('idle');
        rightArrow.antialiasing = ClientPrefs.data.antialiasing;
        rightArrow.screenCenter(Y);
        rightArrow.flipX = true;
        add(rightArrow);

        for(i in 0...optionsArr.length)
        {
            var obj:GalleryObject = new GalleryObject();
            obj.frames = Paths.getSparrowAtlas('gallery/NEW/${optionsArr[i]}Spr');
            obj.animation.addByPrefix('idle', 'idle', 2, true);
            obj.animation.play('idle');
            obj.antialiasing = ClientPrefs.data.antialiasing;
            obj.x = 470;
            obj.y = 150;
            obj.startPosition = new FlxPoint(obj.x, obj.y);
            obj.targetX = i;
            obj.x += FlxG.width * i;
            obj.snapToPosition();
            optionsGrp.add(obj);
        }

        for(obj in optionsGrp)
        {
            var angleTarget = 1;
            new FlxTimer().start(0.5, function(tmr:FlxTimer)
            {
                obj.angle = obj.angle == angleTarget ? -angleTarget : angleTarget;
            }, 0);
        }

        var angleTarget = 1;
        new FlxTimer().start(0.5, function(tmr:FlxTimer)
        {
            icons.angle = icons.angle == angleTarget ? -angleTarget : angleTarget;
        }, 0);

        changeSelect(0, true);
    }

    var tweenTransSpeed:Float = 0.4;
    var angleSpeed:Float = 15;
    var canInteract:Bool = true;
    var isPreviewingSomething:Bool = false;
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        disk.angle += angleSpeed * elapsed;
        if(waterShader != null) waterShader.iTime.value[0] += elapsed;

        if(canInteract) handleInputs();
    }

    function handleInputs()
    {
        if(isPreviewingSomething)
        {
            if(controls.UI_RIGHT_P)
            {
                changeSelect(1);
                rightArrow.animation.play('press', true);
                rightArrow.animation.finishCallback = function(name)
                {
                    rightArrow.animation.play('idle', true);
                };
            }
            if(controls.UI_LEFT_P)
            {
                changeSelect(-1);
                leftArrow.animation.play('press', true);
                leftArrow.animation.finishCallback = function(name)
                {
                    leftArrow.animation.play('idle', true);
                };
            }

            if(controls.BACK)
            {
                for(obj in imagesGrp)
                {
                    FlxTween.cancelTweensOf(obj);
                    FlxTween.tween(obj, {y: 1280}, tweenTransSpeed, {ease: FlxEase.quartInOut});
                }

                FlxTween.tween(optionsGrp.members[curSelected], {y: 150}, tweenTransSpeed, {ease: FlxEase.quartInOut});

                isPreviewingSomething = false;
            }
        }
        else
        {
            if(controls.UI_RIGHT_P)
            {
                changeSelect(1);
                rightArrow.animation.play('press', true);
                rightArrow.animation.finishCallback = function(name)
                {
                    rightArrow.animation.play('idle', true);
                };
            }
            if(controls.UI_LEFT_P)
            {
                changeSelect(-1);
                leftArrow.animation.play('press', true);
                leftArrow.animation.finishCallback = function(name)
                {
                    leftArrow.animation.play('idle', true);
                };
            }

            if(controls.BACK)
            {
                new FlxTimer().start(0.8, function(t:FlxTimer)
                {
		            	FlxTransitionableState.skipNextTransIn = true;
		            	FlxTransitionableState.skipNextTransOut = true;
                    MusicBeatState.switchState(new MainMenuState());
                });
            }

            if(controls.ACCEPT)
            {
                isPreviewingSomething = true;
                var selectedItem:String = optionsArr[curSelected];
                switch(selectedItem)
                {
                        case 'outdated_concepts' | 'bored':
                            FlxG.sound.play(Paths.sound('confirmMenu'));

                            for(obj in optionsGrp)
                            {
                                FlxTween.cancelTweensOf(obj);
                            }

                            disposeImages();
                            generateImages(selectedItem);

                            FlxTween.tween(optionsGrp.members[curSelected], {y: -380}, tweenTransSpeed, {ease: FlxEase.quartInOut});
                        case 'music':
                            FlxG.sound.play(Paths.sound('confirmMenu'));

                            FlxTween.cancelTweensOf(leftArrow);
                            for(obj in optionsGrp)
                            {
                                FlxTween.cancelTweensOf(obj);
                            }
                            FlxTween.cancelTweensOf(rightArrow);

                            FlxTween.tween(leftArrow, {y: 800}, 0.6, {ease: FlxEase.quartIn});
                            FlxTween.tween(optionsGrp.members[curSelected], {y: 800}, 0.6, {ease: FlxEase.quartIn, startDelay: 0.1});
                            FlxTween.tween(rightArrow, {y: 800}, 0.6, {ease: FlxEase.quartIn, startDelay: 0.2});

                            new FlxTimer().start(0.8, function(t:FlxTimer)
                            {
		            				FlxTransitionableState.skipNextTransIn = true;
		            				FlxTransitionableState.skipNextTransOut = true;
                                MusicBeatState.switchState(new GalleryStateMusic());
                            });
                        default:
                }
            }
        }
    }

    function changeSelect(change:Int = 0, firstTime:Bool = false)
    {
        if(isPreviewingSomething)
        {
            curSelectedImages = FlxMath.wrap(curSelectedImages + change, 0, imageDataArray.length - 1);

		    for (num => item in imagesGrp.members)
		    {
		    	item.targetX = num - curSelectedImages;
		    	item.alpha = 0.6;
		    	if (item.targetX == 0) item.alpha = 1;
                if (firstTime) item.snapToPosition();
		    }
        }
        else
        {
            curSelected = FlxMath.wrap(curSelected + change, 0, optionsArr.length - 1);

		    for (num => item in optionsGrp.members)
		    {
		    	item.targetX = num - curSelected;
		    	item.alpha = 0.6;
		    	if (item.targetX == 0) item.alpha = 1;
                if (firstTime) item.snapToPosition();
		    }
        }
    }

    function generateImages(folderName:String)
    {
        var imagesOnFolder = FileSystem.readDirectory('assets/shared/images/gallery/$folderName');

        // Delete json files
        for(obj in imagesOnFolder)
        {
            if(StringTools.endsWith(obj, '.json'))
            {
                imagesOnFolder.remove(obj);
            }
        }

        for(num => image in imagesOnFolder)
        {
            #if debug
                trace(' * $image');
            #end
            
            // removing the extension .png
            var imageName = StringTools.replace(image, '.png', '');

            try {
                var content = File.getContent('assets/shared/images/gallery/$folderName/$imageName.json');
                var imageData = Json.parse(content);

                #if debug
                trace('$num: ${imageData.name}');
                trace('$num: ${imageData.description}');
                #end

                imageDataArray.push(imageData);
            } 
            catch(exc)
            {
                #if debug trace('No json has been found for the image with ID $num'); #end
            }

            var spr = new GalleryObject();
            spr.loadGraphic(Paths.image('gallery/$folderName/$imageName'));
            #if debug
            trace(' - [$num] Path: ${'assets/shared/images/gallery/$folderName/$imageName.png'}');
            #end
            spr.antialiasing = ClientPrefs.data.antialiasing;
            spr.screenCenter();
            spr.x = 800;
            spr.x += -(spr.width / 2);
            spr.startPosition = new FlxPoint(spr.x, spr.y);
            spr.targetX = num;
            spr.x += FlxG.width * num;
            spr.snapToPosition();
            imagesGrp.add(spr);
        }

        changeSelect(0, true);

        for(obj in imagesGrp)
        {
            obj.y = 1280;
            FlxTween.tween(obj, {y: obj.startPosition.y}, tweenTransSpeed, {ease: FlxEase.quartInOut});
        }
    }

    function disposeImages()
    {
        imagesGrp.forEach(function(spr:FlxSprite) spr.destroy());
        imagesGrp.clear();
        imageDataArray = [];
    }
}