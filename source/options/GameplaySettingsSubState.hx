package options;

class GameplaySettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = Language.getPhrase('gameplay_menu', 'Gameplay Settings');
		rpcTitle = 'Gameplay Settings Menu'; //for Discord Rich Presence

		//I'd suggest using "Downscroll" as an example for making your own option since it is the simplest here
		var option:Option = new Option('Downscroll', //Name
			'If checked, notes go Down instead of Up, simple enough.', //Description
			'downScroll', //Save data variable name
			BOOL); //Variable type
		option.onChange = onChangeDownscroll;
		addOption(option);

		var option:Option = new Option('Middlescroll',
			'If checked, your notes get centered.',
			'middleScroll',
			BOOL);
		option.onChange = onChangeMiddleScroll;
		addOption(option);
		
		#if mobile
		var option:Option = new Option('Invisible Hitbox',
            'If checked, the hitbox will become invisible.',
            'invisibleHitbox',
            'bool');
		addOption(option);
		
		#if !ios
		var option:Option = new Option('Invisible Pause Button',
            'If checked, the pause button will become invisible.',
            'invisibleButtonPause',
            'bool');
		addOption(option);
		#end
		#end

		var option:Option = new Option('Opponent Notes',
			'If unchecked, opponent notes get hidden.',
			'opponentStrums',
			BOOL);
		option.onChange = onChangeOpponentStrums;
		addOption(option);

		var option:Option = new Option('Ghost Tapping',
			"If checked, you won't get misses from pressing keys\nwhile there are no notes able to be hit.",
			'ghostTapping',
			BOOL);
		option.onChange = onChangeGhostTapping;
		addOption(option);
		
		var option:Option = new Option('Auto Pause',
			"If checked, the game automatically pauses if the screen isn't on focus.",
			'autoPause',
			BOOL);
		addOption(option);
		option.onChange = onChangeAutoPause;

		var option:Option = new Option('Disable Reset Button',
			"If checked, pressing Reset won't do anything.",
			'noReset',
			BOOL);
		addOption(option);

		var option:Option = new Option('Hitsound Volume',
			'Funny notes does \"Tick!\" when you hit them.',
			'hitsoundVolume',
			PERCENT);
		addOption(option);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		option.onChange = onChangeHitsoundVolume;

		var option:Option = new Option('Rating Offset',
			'Changes how late/early you have to hit for a "Sick!"\nHigher values mean you have to hit later.',
			'ratingOffset',
			INT);
		option.displayFormat = '%vms';
		option.scrollSpeed = 20;
		option.minValue = -30;
		option.maxValue = 30;
		addOption(option);

		var option:Option = new Option('Sick! Hit Window',
			'Changes the amount of time you have\nfor hitting a "Sick!" in milliseconds.',
			'sickWindow',
			INT);
		option.displayFormat = '%vms';
		option.scrollSpeed = 15;
		option.minValue = 15;
		option.maxValue = 45;
		addOption(option);

		var option:Option = new Option('Good Hit Window',
			'Changes the amount of time you have\nfor hitting a "Good" in milliseconds.',
			'goodWindow',
			INT);
		option.displayFormat = '%vms';
		option.scrollSpeed = 30;
		option.minValue = 15;
		option.maxValue = 90;
		addOption(option);

		var option:Option = new Option('Bad Hit Window',
			'Changes the amount of time you have\nfor hitting a "Bad" in milliseconds.',
			'badWindow',
			INT);
		option.displayFormat = '%vms';
		option.scrollSpeed = 60;
		option.minValue = 15;
		option.maxValue = 135;
		addOption(option);

		var option:Option = new Option('Safe Frames',
			'Changes how many frames you have for\nhitting a note earlier or late.',
			'safeFrames',
			FLOAT);
		option.scrollSpeed = 5;
		option.minValue = 2;
		option.maxValue = 10;
		option.changeValue = 0.1;
		addOption(option);

		var option:Option = new Option('Sustains as One Note',
			"If checked, Hold Notes can't be pressed if you miss,\nand count as a single Hit/Miss.\nUncheck this if you prefer the old Input System.",
			'guitarHeroSustains',
			BOOL);
		addOption(option);

		super();
	}

	var alreadyTalked:Bool = false;
	function onChangeDownscroll()
	{
		if(ClientPrefs.data.downScroll && !alreadyTalked)
		{
			alreadyTalked = true;
			startDialogue('question');
			dialogueText.resetText('Are you a pro player or something like that? Upscroll is nice, I mean...');
			dialogueText.start(0.04, true);
			dialogueText.completeCallback = function() 
			{
				new FlxTimer().start(thingTimer, function(t:FlxTimer)
				{
					endDialogue();
				});
			}
		}
	}

	var alreadyTalked2:Bool = false;
	function onChangeMiddleScroll()
	{
		if(ClientPrefs.data.middleScroll && !alreadyTalked2)
		{
			alreadyTalked2 = true;
			startDialogue('laugh');
			dialogueText.resetText('Weirdo...');
			dialogueText.start(0.06, true);
			dialogueText.completeCallback = function() 
			{
				new FlxTimer().start(1, function(t:FlxTimer)
				{
					endDialogue();
				});
			}
		}
	}

	var alreadyTalked3:Bool = false;
	function onChangeOpponentStrums()
	{
		if(!ClientPrefs.data.opponentStrums && !alreadyTalked3)
		{
			alreadyTalked3 = true;
			startDialogue('question');
			dialogueText.resetText('Do you hate opponent strums or what??? Nonsense...');
			dialogueText.start(0.04, true);
			dialogueText.completeCallback = function() 
			{
				new FlxTimer().start(thingTimer, function(t:FlxTimer)
				{
					endDialogue();
				});
			}
		}
	}

	var alreadyTalked4:Bool = false;
	function onChangeGhostTapping()
	{
		if(!ClientPrefs.data.ghostTapping && !alreadyTalked4)
		{
			alreadyTalked4 = true;
			startDialogue('question');
			dialogueText.resetText('Are you feeling nostalgic or just feeling inspired by V-Slice?');
			dialogueText.start(0.04, true);
			dialogueText.completeCallback = function() 
			{
				new FlxTimer().start(thingTimer, function(t:FlxTimer)
				{
					endDialogue();
				});
			}
		}
	}

	function onChangeHitsoundVolume()
		FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.data.hitsoundVolume);

	function onChangeAutoPause()
		FlxG.autoPause = ClientPrefs.data.autoPause;
}