package libs.queue;

/**
 * ...
 * @author Tamar Curry
 */
class PauseAction extends QueuedAction
{
	private var _elapsed:Int;
	private var _duration:Int;
	private var _useFrames:Bool;
	
	// -----------------------------------------------------------------------------------------------
	// -----------------------------------------------------------------------------------------------
	public function new() 
	{
		super();
		
	}
	
	// -----------------------------------------------------------------------------------------------
	override function onActivate():Void 
	{
		_elapsed = 0;
	}
	
	// -----------------------------------------------------------------------------------------------
	override function onDeactivate():Void 
	{
		_duration = 0;
		_useFrames = false;
		super.onDeactivate();
	}
	
	// -----------------------------------------------------------------------------------------------
	public function setTime(duration:Int, useFrames:Bool):Void
	{
		_duration = duration;
		_useFrames = useFrames;
	}
	
	// -----------------------------------------------------------------------------------------------
	override public function execute():Void 
	{
		if ( isFinished ) { return; }
		
		isFinished = _elapsed >= _duration;
		if ( _useFrames ) {
			_elapsed += 1;
		}
		else {
			_elapsed += Globals.ms;
		}
	}
	
}