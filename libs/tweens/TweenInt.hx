package libs.tweens;

import libs.interfaces.ITweenData;
import libs.pool.Pool;
import libs.pool.PoolableObject;
	
/**
 * ...
 * @author Tamar Curry
 */
class TweenInt extends PoolableObject implements ITweenData 
{
	private static var _pool:Pool<TweenInt> = new Pool( function():TweenInt { return new TweenInt(); } );
	
	@:allow(libs.tweens.Tween)
	private static function fetch():TweenInt {
		return _pool.get();
	}
	
	
	public var reverse		:Bool;
	
	private var _start		:Int;
	private var _stop		:Int;
	
	private var _onUpdate	:Int->Void;
	
	// ---------------------------------------------------------------------------
	public function TweenNumber() 
	{
		
	}
	
	// ---------------------------------------------------------------------------
	public function init(start:Int, stop:Int, onUpdate:Int->Void):Void
	{
		_start = start;
		_stop = stop;
		_onUpdate = onUpdate;
	}
	
	// ---------------------------------------------------------------------------
	public function isTarget(target:Dynamic):Bool 
	{
		return false;
	}
	
	// ---------------------------------------------------------------------------
	public function invalidate():Void 
	{
		
	}
	
	// ---------------------------------------------------------------------------
	public function update(progress:Float):Void 
	{
		var s:Int = reverse ? _stop : _start;
		var e:Int = reverse ? _start : _stop;
		var v:Int = Std.int( s + ((e - s) * progress) );
		_onUpdate(v);
	}
	
	// ---------------------------------------------------------------------------
	override private function onDeactivate():Void 
	{
		_onUpdate	= null;
		reverse	= false;
	}
	
}

