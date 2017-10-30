package libs.queue;
import libs.utils.BoolCallback;

/**
 * ...
 * @author Tamar Curry
 */
class QueryCall extends QueuedAction
{
	private var _callback:Void->Bool;
	
	public function new() 
	{
		super();
		_callback = defaultFunc;
	}
	
	public function setCallback( callback:Void->Bool ):Void
	{
		_callback = callback;
		if ( _callback == null ) {
			_callback = defaultFunc;
		}
	}
	
	override function onDeactivate():Void 
	{
		_callback = defaultFunc;
	}
	
	private static function defaultFunc():Bool {
		return true;
	}
	
	override public function execute():Void 
	{
		if ( isFinished ) { return; }
		
		isFinished = _callback();
	}
}