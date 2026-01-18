package backend;

import flixel.util.FlxSave;

class Saves
{
    public static var currentSaveSlot:Null<Int> = null;
    static var recorderFile = null;

    public static function loadSlot(slotNum:Int)
    {
        if(slotNum < 0) throw "Cannot load a negative slot!";
        if(currentSaveSlot == null) throw "Cannot load a slot because save files have not initialized yet!";
        if(FlxG.save == null) throw "Could not load save slot because it's null!";

        FlxG.save.bind('funkin$slotNum', CoolUtil.getSavePath());

        currentSaveSlot = slotNum;

        recorderFile.data.currentSlot = currentSaveSlot;
        recorderFile.flush();
        
        trace('Loading slot $currentSaveSlot');
    }

    static var initialized:Bool = false;
    private static function init()
    {
        if(initialized) return;

        recorderFile = new FlxSave();
        recorderFile.bind('slotRecorder', CoolUtil.getSavePath());
        
        if(recorderFile == null) throw "Could not initialize!";

        // if it doesn't exist, the slot loaded is 0
        recorderFile.data.currentSlot = recorderFile.data.currentSlot == null ? 0 : recorderFile.data.currentSlot;
        recorderFile.flush();

        currentSaveSlot = recorderFile.data.currentSlot;
        trace('Init save files at slot $currentSaveSlot');

        loadSlot(currentSaveSlot);
    }
}