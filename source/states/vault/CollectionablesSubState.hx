package states.vault;

import backend.PsychCamera;

enum CollectPage
{
    ITEMS;
    AWARDS;
    PROGRESS;
}

class CollectionablesSubState extends MusicBeatSubstate
{
    var bg:FlxSprite;
    var collectBackground:FlxSprite;
    var currentPage:CollectPage = ITEMS;

    var itemsPageText:FlxText;
    var awardsPageText:FlxText;
    var progressPageText:FlxText;

    // collectionables thingie
    var collectItemsGrp:FlxTypedGroup<CollectItem>;

    // awards thingie
    var awardItemsGrp:FlxTypedGroup<AwardItem>;

    override function create()
    {
        super.create();

        bg = new FlxSprite();
        bg.makeGraphic(1280, 720, 0xFF000000);
        add(bg);

        collectBackground = new FlxSprite();
        collectBackground.makeGraphic(750, 570, 0xFFDAB5FE);
        collectBackground.antialiasing = ClientPrefs.data.antialiasing;
        collectBackground.screenCenter(X);
        collectBackground.y = FlxG.height;
        add(collectBackground);

        itemsPageText = new FlxText(0, collectBackground.y, 250, 'Items');
        itemsPageText.setFormat(Paths.font('GAU_pop_magic.ttf'), 25, 0xFFE0DEEA, CENTER);
        itemsPageText.antialiasing = ClientPrefs.data.antialiasing;
        itemsPageText.x = collectBackground.x;
        add(itemsPageText);

        awardsPageText = new FlxText(0, collectBackground.y, 250, 'Awards');
        awardsPageText.setFormat(Paths.font('GAU_pop_magic.ttf'), 25, 0xFFE0DEEA, CENTER);
        awardsPageText.antialiasing = ClientPrefs.data.antialiasing;
        awardsPageText.x = collectBackground.x + 250;
        add(awardsPageText);

        progressPageText = new FlxText(0, collectBackground.y, 250, 'Progress');
        progressPageText.setFormat(Paths.font('GAU_pop_magic.ttf'), 25, 0xFFE0DEEA, CENTER);
        progressPageText.antialiasing = ClientPrefs.data.antialiasing;
        progressPageText.x = collectBackground.x + 500;
        add(progressPageText);

        collectItemsGrp = new FlxTypedGroup<CollectItem>();
        add(collectItemsGrp);

        var rowAmount:Int = 5;
        var rows:Int = -1;
        for(i in 0...ShopSubState.itemsListArr.length)
        {
            if(i % rowAmount == 0) rows++;

            var item:CollectItem = new CollectItem();
            item.makeGraphic(120, 120, 0xFFFFFFFF);
            item.x = collectBackground.x + 20 + ((item.width + 25) * (i % rowAmount));
            item.y = collectBackground.y + 60 + ((item.height + 25) * rows);
            item.ID = i;
            item.row = rows;
            collectItemsGrp.add(item);
        }

        awardItemsGrp = new FlxTypedGroup<AwardItem>();
        add(awardItemsGrp);

        var awardNum:Int = 0;
        for(key => value in Achievements.achievements)
        {
            var item:AwardItem = new AwardItem(0, 0, key);
            item.makeGraphic(120, 120, 0xFFFFFFFF);
            item.x = collectBackground.x + 40;
            item.y = 60 + ((item.height + 25) * awardNum);
            item.ID = awardNum;
            awardItemsGrp.add(item);

            awardNum++;
        }

        setCurrentPage(currentPage);
        initTransition();
    }

    function initTransition()
    {
        bg.alpha = 0;
        FlxTween.tween(bg, {alpha: 0.2}, 0.8, {ease: FlxEase.quartOut});

        collectBackground.y = FlxG.height;
        FlxTween.tween(collectBackground, {y: FlxG.height - collectBackground.height}, 0.8, {ease: FlxEase.quartOut});

        itemsPageText.y = FlxG.height;
        FlxTween.tween(itemsPageText, {y: FlxG.height - collectBackground.height - itemsPageText.height / 2}, 0.8, {ease: FlxEase.quartOut});

        awardsPageText.y = FlxG.height;
        FlxTween.tween(awardsPageText, {y: FlxG.height - collectBackground.height - awardsPageText.height / 2}, 0.8, {ease: FlxEase.quartOut});

        progressPageText.y = FlxG.height;
        FlxTween.tween(progressPageText, {y: FlxG.height - collectBackground.height - progressPageText.height / 2}, 0.8, {ease: FlxEase.quartOut});

        /*
        switch(currentPage)
        {
            case ITEMS: initCollectTransition();
            case AWARDS: initAwardsTransition();
            default: 
        }
        */

        initCollectTransition();
        initAwardsTransition();
    }

    function initCollectTransition()
    {
        collectItemsGrp.forEach(function(spr:CollectItem)
        {
            FlxTween.tween(spr, {y: FlxG.height - collectBackground.height + 60 + ((spr.height + 10) * spr.row)}, 0.8, {ease: FlxEase.quartOut});
        });
    }

    function initAwardsTransition()
    {
        awardItemsGrp.forEach(function(spr:AwardItem)
        {
            FlxTween.tween(spr, {y: FlxG.height - collectBackground.height + 60 + ((spr.height + 10) * spr.ID)}, 0.8, {ease: FlxEase.quartOut});
        });
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        handleMouseBehaviour();

        if(controls.BACK)
        {
            FlxTween.cancelTweensOf(collectBackground);
            FlxTween.cancelTweensOf(VaultState.poloDown);

            collectItemsGrp.forEach(function(spr:CollectItem)
            {
                FlxTween.cancelTweensOf(spr);
                FlxTween.tween(spr, {y: FlxG.height + ((spr.height + 10) * spr.row)}, 0.15, {ease: FlxEase.quartOut});
            });

            FlxG.sound.play(Paths.sound('vault/shop/zoomOut'));
            if(VaultState.blurShaderTween != null) VaultState.blurShaderTween.cancel();
            VaultState.blurShaderTween = FlxTween.num(5, 0, 1, {ease: FlxEase.quartOut, onComplete: (_) -> VaultState.blurShaderTween = null}, function(v:Float)
            {
                VaultState.blurShader.radius.value[0] = v;
            });

            FlxTween.tween(collectBackground, {y: FlxG.height}, 0.15, {ease: FlxEase.quartOut, onComplete: function(twn:FlxTween)
            {
                close();
            }});
            FlxTween.tween(VaultState.poloDown, {y: FlxG.height - VaultState.poloDown.height}, 0.15, {ease: FlxEase.quintOut});
        }
    }

    function handleMouseBehaviour()
    {
        // changing shitty pages
        // items
        if(FlxG.mouse.overlaps(itemsPageText))
        {
            if(FlxG.mouse.justPressed)
            {
                currentPage = ITEMS;
                setCurrentPage(currentPage);
            }
        }

        if(FlxG.mouse.overlaps(awardsPageText))
        {
            if(FlxG.mouse.justPressed)
            {
                currentPage = AWARDS;
                setCurrentPage(currentPage);
            }
        }

        if(FlxG.mouse.overlaps(progressPageText))
        {
            if(FlxG.mouse.justPressed)
            {
                currentPage = PROGRESS;
                setCurrentPage(currentPage);
            }
        }

        // depending on the page
        switch(currentPage)
        {
            case AWARDS:
                var wheelSpeed:Int = 10;
            default:
        }
    }

    function setCurrentPage(page:CollectPage)
    {
        switch(page)
        {
            case ITEMS:
                collectItemsGrp.forEach(function(item:CollectItem)
                {
                    item.visible = true;
                });

                awardItemsGrp.forEach(function(item:AwardItem)
                {
                    item.visible = false;
                });
            case AWARDS:
                collectItemsGrp.forEach(function(item:CollectItem)
                {
                    item.visible = false;
                });

                awardItemsGrp.forEach(function(item:AwardItem)
                {
                    item.visible = true;
                });
            case PROGRESS:
                collectItemsGrp.forEach(function(item:CollectItem)
                {
                    item.visible = false;
                });

                awardItemsGrp.forEach(function(item:AwardItem)
                {
                    item.visible = false;
                });
        }
    }
}

class CollectItem extends FlxSprite
{
    public var row:Int = 0;
    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);
    }
}

class AwardItem extends FlxSpriteGroup
{
    public var background:FlxSprite;
    public var awardLogo:FlxSprite;
    public var awardNameText:FlxText;
    public var awardDescriptionText:FlxText;

    public function new(x:Float = 0, y:Float = 0, awardName:String)
    {
        super(x, y);

        var achievementData = Achievements.get(awardName);

        background = new FlxSprite();
        background.makeGraphic(570, 130, 0xFF000000);
        background.alpha = 0.56;
        background.antialiasing = ClientPrefs.data.antialiasing;
        add(background);

        awardLogo = new FlxSprite();
        awardLogo.loadGraphic(Paths.image('achievements/$awardName'));
        awardLogo.antialiasing = ClientPrefs.data.antialiasing;
        awardLogo.scale.set(0.85, 0.85);
        awardLogo.updateHitbox();
        add(awardLogo);

        awardNameText = new FlxText(0, 0, 0, achievementData.name);
        awardNameText.setFormat(Paths.font('GAU_pop_magic.ttf'), 25, 0xFFE0DEEA, CENTER);
        awardNameText.antialiasing = ClientPrefs.data.antialiasing;
        awardNameText.x += awardLogo.width + 10;
        add(awardNameText);

        awardDescriptionText = new FlxText(0, 0, 0, achievementData.description);
        awardDescriptionText.setFormat(Paths.font('GAU_pop_magic.ttf'), 25, 0xFFE0DEEA, CENTER);
        awardDescriptionText.antialiasing = ClientPrefs.data.antialiasing;
        awardDescriptionText.x += awardLogo.width + 10;
        awardDescriptionText.y += awardNameText.height + 10;
        add(awardDescriptionText);
    }
}