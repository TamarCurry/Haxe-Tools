package libs.interfaces;

/**
 * @author Tamar Curry
 */

interface ITweenData extends IDestroyable
{
	public var reverse:Bool;
	public function isTarget(target:Dynamic):Bool;
	public function invalidate():Void;
	public function update(progress:Float):Void;
}