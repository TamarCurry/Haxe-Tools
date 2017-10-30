package libs.utils;

import libs.baseClasses.Destroyable;

/**
 * ...
 * @author Tamar Curry
 */
class BoolCallback extends Destroyable
{
	private var _callback:Void->Bool;
	
	public function new(callback:Void->Bool=null) 
	{
		super();
		_callback = callback;
	}
	
	public function setCallback(callback:Void->Bool):Void
	{
		_callback = callback;
	}
	
	public function invoke():Bool
	{
		var result:Bool = false;
		if ( _callback != null ) {
			result = _callback();
		}
		return result;
	}
	
	override public function destroy():Void 
	{
		if ( this.isExpired ) { return; }
		super.destroy();
		_callback = null;
	}
}