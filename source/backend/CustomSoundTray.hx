package backend;

import openfl.utils.Assets;
import openfl.display.Bitmap;
import flixel.system.ui.FlxSoundTray;

class CustomSoundTray extends FlxSoundTray
{
    var graphicScale:Float = 0.30;
    var lerpYPos:Float = 0;
    var alphaTarget:Float = 0;
  
    var volumeMaxSound:String;

    public function new()
    {
        super();
        removeChildren();

        var bg:Bitmap = new Bitmap(Assets.getBitmapData(Paths.simpleImage("soundtray/volumeBg")));
        bg.scaleX = graphicScale;
        bg.scaleY = graphicScale;
        addChild(bg);

        y = -height;
        visible = false;

        var volume:Bitmap = new Bitmap(Assets.getBitmapData(Paths.simpleImage("soundtray/volumeText")));
        volume.scaleX = graphicScale;
        volume.scaleY = graphicScale;
        addChild(volume);

        var backingBar:Bitmap = new Bitmap(Assets.getBitmapData(Paths.simpleImage("soundtray/bars_10")));
        backingBar.x = 2;
        backingBar.y = 0;
        backingBar.scaleX = graphicScale;
        backingBar.scaleY = graphicScale;
        addChild(backingBar);
        backingBar.alpha = 0.4;

        _bars = [];

        for (i in 1...11)
        {
          var bar:Bitmap = new Bitmap(Assets.getBitmapData(Paths.simpleImage("soundtray/bars_" + i)));
          bar.x = 2;
          bar.y = 0;
          bar.scaleX = graphicScale;
          bar.scaleY = graphicScale;
          addChild(bar);
          _bars.push(bar);
        }

        y = -height;
        screenCenter();
    
        volumeUpSound = Paths.simpleSound("Volup");
        volumeDownSound = Paths.simpleSound("Voldown");
        volumeMaxSound = Paths.simpleSound("VolMAX");
        
        trace("Custom sound tray added!");
    }

    public override function update(elapsed:Float):Void
    {
        super.update(elapsed);
        
        y = FlxMath.lerp(y, lerpYPos, 0.1);
        alpha = FlxMath.lerp(alpha, alphaTarget, 0.25);

        // Animate sound tray thing
        if (_timer > 0)
        {
            _timer -= (elapsed / 1000);
            alphaTarget = 1;
        }
        else if (y >= -height)
        {
            lerpYPos = -height - 10;
            alphaTarget = 0;
        }

        if (y <= -height)
        {
            visible = false;
            active = false;

            #if FLX_SAVE
            // Save sound preferences
            if (FlxG.save.isBound)
            {
              FlxG.save.data.mute = FlxG.sound.muted;
              FlxG.save.data.volume = FlxG.sound.volume;
              FlxG.save.flush();
            }
            #end
        }
    }

   /**
   * Makes the little volume tray slide out.
   *
   * @param	up Whether the volume is increasing.
   */
    override public function show(up:Bool = false):Void
    {
        _timer = 1;
        lerpYPos = 10;
        visible = true;
        active = true;
        var globalVolume:Int = Math.round(FlxG.sound.volume * 10);
        
        if (FlxG.sound.muted)
        {
            globalVolume = 0;
        }
    
        if (!silent)
        {
            var sound = up ? volumeUpSound : volumeDownSound;
            
            if (globalVolume == 10) sound = volumeMaxSound;
            
            if (sound != null) FlxG.sound.load(sound).play();
        }
    
        for (i in 0..._bars.length)
        {
            if (i < globalVolume)
            {
              _bars[i].visible = true;
            }
            else
            {
              _bars[i].visible = false;
            }
        }
    }
}