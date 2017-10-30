package libs.utils;

import libs.baseClasses.Destroyable;

/**
 * ...
 * @author Tamar Curry
 */
class Callback extends Destroyable
{
	private var _callback:Void->Void;
	public function new(callback:Void->Void=null) 
	{
		super();
		_callback = callback;
	}
	
	public function setCallback(callback:Void->Void):Void
	{
		_callback = callback;
	}
	
	public function invoke():Void
	{
		if ( _callback != null ) {
			_callback();
		}
	}
	
	override public function destroy():Void 
	{
		if ( this.isExpired ) { return; }
		super.destroy();
		_callback = null;
	}
	
}