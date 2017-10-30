package libs.tweens;

import libs.interfaces.ITweenData;

/**
 * THIS CLASS IS EMPTY ON PURPOSE
 * @author Tamar Curry
 */
class TweenGhost implements ITweenData 
{
	public var reverse:Bool;
	public var isExpired(default, null):Bool = false;
	
	// -------------------------------------------------------------------------
	// -------------------------------------------------------------------------
	public function new() 
	{
		
	}
	
	// -------------------------------------------------------------------------
	public function isTarget(target:Dynamic):Bool
	{
		return false;
	}
	
	// -------------------------------------------------------------------------
	public function invalidate():Void 
	{
		
	}
	
	// -------------------------------------------------------------------------
	public function update(progress:Float):Void 
	{
		
	}
	
	// -------------------------------------------------------------------------
	public function destroy():Void {
		
	}
	
}