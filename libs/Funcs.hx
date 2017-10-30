package libs;

import libs.interfaces.IDestroyable;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.events.IEventDispatcher;
import openfl.geom.ColorTransform;

/**
 * ...
 * @author Tamar Curry
 */
class Funcs
{
	
	// -----------------------------------------------------------------------------------------------
	public static function setListener(dispatcher:IEventDispatcher, active:Bool, type:String, listener:Dynamic->Void, useCapture:Bool=false, priority:Int=0, weakRef:Bool=false ) 
	{
		if ( dispatcher == null ) { return; }
		
		if ( active ) {
			dispatcher.addEventListener( type, listener, useCapture, priority, weakRef );
		}
		else {
			dispatcher.removeEventListener( type, listener, useCapture );
		}
	}
	
	// -----------------------------------------------------------------------------------------------
	public static function destroy(target:Dynamic):Dynamic
	{
		if ( Std.is( target, DisplayObject ) ) {
			var d:DisplayObject = cast target;
			if ( d.parent != null ) {
				d.parent.removeChild(d);
			}
		}
		
		if ( Std.is( target, DisplayObjectContainer ) ) {
			var p:DisplayObjectContainer = cast target;
			while ( p.numChildren > 0 ) {
				destroy( p.removeChildAt(0) );
			}
		}
		
		if ( Std.is( target, IDestroyable ) ) {
			cast(target, IDestroyable).destroy();
		}
		else if ( Std.is( target, Array ) ) {
			for ( i in 0...target.length ) {
				destroy( target[i] );
			}
		}
		
		return null;
	}

	// -----------------------------------------------------------------------------------------------
	public static function tint(target:DisplayObject, RGBColor:Int, amount:Float = 1):Void
	{
		var colorTransform:ColorTransform		= new ColorTransform();
		colorTransform.redOffset				= ( RGBColor >> 16 ) * amount;
		colorTransform.greenOffset				= ( (RGBColor >> 8) & 0xff) * amount;
		colorTransform.blueOffset				= (RGBColor & 0xff) * amount;
		
		colorTransform.redMultiplier			= 1 - amount;
		colorTransform.greenMultiplier			= 1 - amount;
		colorTransform.blueMultiplier			= 1 - amount;
		target.transform.colorTransform			= colorTransform;
	}
	
	// -----------------------------------------------------------------------------------------------
	public static function untint(target:DisplayObject):Void
	{
		target.transform.colorTransform	= new ColorTransform();
	}
}