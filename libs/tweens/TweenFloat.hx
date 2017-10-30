package libs.tweens;

import libs.interfaces.ITweenData;
import libs.pool.Pool;
import libs.pool.PoolableObject;
	
/**
 * ...
 * @author Tamar Curry
 */
class TweenFloat extends PoolableObject implements ITweenData 
{
	private static var _pool:Pool<TweenFloat> = new Pool( function():TweenFloat { return new TweenFloat(); } );
	
	@:allow(libs.tweens.Tween)
	private static function fetch():TweenFloat {
		return _pool.get();
	}
	
	
	public var reverse		:Bool;
	
	private var _start		:Float;
	private var _stop		:Float;
	
	private var _onUpdate	:Float->Void;
	
	// ---------------------------------------------------------------------------
	public function TweenFloat() 
	{
		
	}
	
	// ---------------------------------------------------------------------------
	public function init(start:Float, stop:Float, onUpdate:Float->Void):Void
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
		var s:Float = reverse ? _stop : _start;
		var e:Float = reverse ? _start : _stop;
		var v:Float = s + ((e - s) * progress);
		_onUpdate(v);
	}
	
	// ---------------------------------------------------------------------------
	override private function onDeactivate():Void 
	{
		_onUpdate	= null;
		reverse	= false;
	}
	
}

