package libs.utils;

/**
 * ...
 * @author Tamar Curry
 */
class Duration
{
	private var _elapsed:Int;
	private var _duration:Int;
	private var _useFrames:Bool;
	
	// -----------------------------------------------------------------------------------------------
	public var elapsed(get, null):Int;
	public var time(get, null):Int;
	public var useFrames(get, null):Bool;
	public var progress(get, null):Float;
	
	// -----------------------------------------------------------------------------------------------
	private function get_elapsed():Int { return _elapsed; }
	private function get_time():Int { return _duration; }
	private function get_useFrames():Bool { return _useFrames; }
	private function get_progress():Float { return _duration > 0 ? _elapsed / _duration : 0; }
	
	// -----------------------------------------------------------------------------------------------
	public function new() 
	{
		
	}
	
	// -----------------------------------------------------------------------------------------------
	public function init(time:Int, useFrames:Bool = false):Void
	{
		_duration = time;
		_useFrames = useFrames;
		_elapsed = 0;
	}
	
	// -----------------------------------------------------------------------------------------------
	public function reset():Void {
		_elapsed = 0;
	}
	
	// -----------------------------------------------------------------------------------------------
	public function setElapsed(time:Int):Void {
		_elapsed = time;
	}
	
	// -----------------------------------------------------------------------------------------------
	public function update(ms:Int, frames:Int):Void {
		if ( _useFrames ) {
			_elapsed += frames;
		}
		else {
			_elapsed += ms;
		}
		
		if ( _elapsed > _duration ) {
			_elapsed = _duration;
		}
	}
	
}