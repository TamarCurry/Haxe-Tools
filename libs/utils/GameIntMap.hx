package libs.utils;

import haxe.ds.IntMap;
import libs.interfaces.IDestroyable;

/**
 * ...
 * @author Tamar Curry
 */
class GameIntMap<T> extends IntMap<T> implements IDestroyable
{
	public var isExpired(default, null):Bool;
	
	// -----------------------------------------------------------------------------------------------
	public function new() 
	{
		super();
	}
	
	// -----------------------------------------------------------------------------------------------
	public function destroy():Void
	{
		isExpired = true;
		for ( s in keys() ) {
			Funcs.destroy( get(s) );
		}
	}
	
}