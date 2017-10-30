package libs.queue;

/**
 * ...
 * @author Tamar Curry
 */
class RepeatCall extends SimpleCall
{
	private var _elapsed:Int;
	private var _duration:Int;
	private var _useFrames:Bool;
	
	public function new() 
	{
		super();
	}
	
	override function onDeactivate():Void 
	{
		_elapsed = 0;
		_duration = 0;
		_useFrames = false;
		super.onDeactivate();
	}
	
	public function setTime(duration:Int, useFrames:Bool):Void
	{
		_duration = duration;
		_useFrames = useFrames;
	}
	
	override public function execute():Void 
	{
		if ( isFinished ) { return; }
		
		isFinished = _elapsed >= _duration;
		_callback();
		
		if ( _useFrames ) {
			_elapsed += 1;
		}
		else {
			_elapsed += Globals.ms;
		}
	}
	
}