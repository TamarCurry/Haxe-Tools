package libs.interfaces;

/**
 * @author Tamar Curry
 */
interface IDestroyable 
{
	public var isExpired(default, null):Bool;
	public function destroy():Void;
}