package libs.baseClasses;

import libs.interfaces.IDestroyable;

/**
 * ...
 * @author Tamar Curry
 */
class Destroyable implements IDestroyable
{
	public var isExpired(default, null):Bool;
	
	// -----------------------------------------------------------------------------------------------
	// -----------------------------------------------------------------------------------------------
	public function new() 
	{
		
	}
	
	// -----------------------------------------------------------------------------------------------
	public function destroy():Void 
	{
		if ( isExpired ) { return; }
		isExpired = true;
		cleanupVars();
	}
	
	// -----------------------------------------------------------------------------------------------
	private function cleanupVars():Void
	{
		
	}
}