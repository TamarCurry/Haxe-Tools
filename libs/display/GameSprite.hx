package libs.display;

import libs.interfaces.IDestroyable;
import openfl.display.Sprite;

/**
 * ...
 * @author Tamar Curry
 */
class GameSprite extends Sprite implements IDestroyable
{

	// -----------------------------------------------------------------------------------------------
	// -----------------------------------------------------------------------------------------------
	public var isExpired(default, null):Bool;
	
	// -----------------------------------------------------------------------------------------------
	// -----------------------------------------------------------------------------------------------
	public function new() 
	{
		super();
		
	}
	
	// -----------------------------------------------------------------------------------------------
	public function destroy():Void 
	{
		if ( isExpired ) { return; }
		isExpired = true;
		if ( this.parent != null ) {
			this.parent.removeChild(this);
		}
		
		var len:Int = this.numChildren;
		for ( i in 0...len ) {
			Funcs.destroy( this.getChildAt(i) );
		}
		this.removeChildren();
	}
	
}