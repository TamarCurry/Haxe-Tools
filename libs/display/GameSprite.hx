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
		
		while ( this.numChildren > 0 ) {
			Funcs.destroy( this.removeChildAt(0) );
		}
	}
	
}