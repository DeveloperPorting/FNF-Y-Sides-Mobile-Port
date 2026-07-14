package mobile.controls;

import flixel.FlxG;
import flixel.util.FlxDestroyUtil;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import openfl.display.BitmapData;
import mobile.backend.MobileUtil;
import mobile.backend.flixel.FlxButton;
import mobile.backend.flixel.input.TouchInputManager;
import mobile.backend.flixel.input.FlxMobileInputID;
import flixel.util.FlxColor;

/**
 * Hitbox... HIT
 * @author StarNova (Cream.BR)
 */
class MobileHitbox extends TouchInputManager
{
	public var buttons:Array<FlxButton> = [];
	
	public var buttonLeft:FlxButton;
	public var buttonDown:FlxButton;
	public var buttonUp:FlxButton;
	public var buttonRight:FlxButton;
	
	public var buttonAction:FlxButton;

	private final alphaTarget:Float = 0.2;
	
	private var _cachedGraphics:Map<Int, flixel.graphics.FlxGraphic> = new Map();

	/**
	 * @param hasAction If true, it adds a giant yellow button at the top (25% of the screen)
	 */
	public function new(hasAction:Bool = false):Void
	{
		super();

		var mainY:Int = hasAction ? Std.int(FlxG.height * 0.25) : 0;
		var mainHeight:Int = hasAction ? Std.int(FlxG.height * 0.75) : FlxG.height;
		var buttonWidth:Int = Std.int(FlxG.width / 4);

		if (hasAction) 
		{
			var actionBtn = createHint(0, 0, FlxG.width, Std.int(FlxG.height * 0.25), 0xFFFF00, [FlxMobileInputID.NONE, FlxMobileInputID.NONE]);
			add(actionBtn);
			buttons.push(actionBtn);
			buttonAction = actionBtn;
		}

		var data = [
			{color: 0xFF00FF, ids: [FlxMobileInputID.hitboxLEFT, FlxMobileInputID.noteLEFT]},
			{color: 0x00FFFF, ids: [FlxMobileInputID.hitboxDOWN, FlxMobileInputID.noteDOWN]},
			{color: 0x00FF00, ids: [FlxMobileInputID.hitboxUP, FlxMobileInputID.noteUP]},
			{color: 0xFF0000, ids: [FlxMobileInputID.hitboxRIGHT, FlxMobileInputID.noteRIGHT]}
		];
		
		for (i in 0...data.length) {
			var btn = createHint(i * buttonWidth, mainY, buttonWidth, mainHeight, data[i].color, data[i].ids);
			add(btn);
			buttons.push(btn);
		}

		var offset:Int = hasAction ? 1 : 0;
		buttonLeft  = buttons[offset];
		buttonDown  = buttons[offset + 1];
		buttonUp    = buttons[offset + 2];
		buttonRight = buttons[offset + 3];

		scrollFactor.set();
		refreshMappedButtons();
	}

	private function createHint(X:Float, Y:Float, Width:Int, Height:Int, Color:FlxColor, IDs:Array<FlxMobileInputID>):FlxButton
	{
		var hint:FlxButton = new FlxButton(X, Y, IDs);
		
		var graphicKey:Int = Color + Width;
		var bgGraphic:flixel.graphics.FlxGraphic = _cachedGraphics.get(graphicKey);
		
		if (bgGraphic == null) {
			var bitmap:BitmapData = new BitmapData(Width, Height, true, (Color & 0x00FFFFFF) | 0x88000000);
			bgGraphic = FlxG.bitmap.add(bitmap, false, "hitbox_" + graphicKey);
			_cachedGraphics.set(graphicKey, bgGraphic);
		}
		
		hint.loadGraphic(bgGraphic);
		hint.solid = hint.moves = false;
		hint.immovable = true;
		hint.scrollFactor.set();
		hint.alpha = 0.00001;

		if (!ClientPrefs.data.invisibleHitbox) {
			var hintTween:FlxTween = null;
			hint.onDown.callback = function() {
				if (hintTween != null) hintTween.cancel();
				
				hintTween = FlxTween.tween(hint, {alpha: alphaTarget}, 0.075, {
					ease: FlxEase.circInOut,
					onComplete: function(_) { hintTween = null; }
				});
			}
			
			hint.onUp.callback = function() {
				if (hintTween != null) hintTween.cancel();
				
				hintTween = FlxTween.tween(hint, {alpha: 0.00001}, 0.15, {
					ease: FlxEase.circInOut,
					onComplete: function(_) { hintTween = null; }
				});
			}
			
			hint.onOut.callback = hint.onUp.callback;
		}

		#if FLX_DEBUG
		hint.ignoreDrawDebug = true;
		#end
		
		return hint;
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		MobileUtil.setControlsState(this, buttons);
	}

	override function destroy():Void
	{
		super.destroy();
		for (btn in buttons)
			FlxDestroyUtil.destroy(btn);
			
		for (key in _cachedGraphics.keys()) {
			var graphic = _cachedGraphics.get(key);
			FlxG.bitmap.remove(graphic);
			graphic.destroy();
		}
		_cachedGraphics.clear();
	}
}