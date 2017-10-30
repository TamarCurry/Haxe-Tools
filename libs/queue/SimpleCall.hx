package libs.queue;
import libs.utils.Callback;

/**
 * ...
 * @author Tamar Curry
 */
class SimpleCall extends QueuedAction
{
	
	private var _callback:Void->Void;
	public function new() 
	{
		super();
		_callback = defaultFunc;
	}
	
	private static function defaultFunc():Void { }
	
	public function setCallback( callback:Void->Void ):Void
	{
		_callback = callback;
		if ( _callback == null ) {
			_callback = defaultFunc;
		}
	}
	
	override private function onDeactivate():Void 
	{
		_callback = defaultFunc;
	}
	
	override public function execute():Void 
	{
		if ( isFinished ) { return; }
		isFinished = true;
		_callback();
	}
}