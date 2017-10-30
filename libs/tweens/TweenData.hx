package libs.tweens;
import libs.interfaces.ITweenData;
import libs.pool.Pool;
import libs.pool.PoolableObject;

/**
 * ...
 * @author Tamar Curry
 */
class TweenData extends PoolableObject implements ITweenData
{
	private static var _pool:Pool<TweenData> = new Pool( function():TweenData { return new TweenData(); } );
	
	@:allow(libs.tweens.Tween)
	private static function fetch():TweenData {
		return _pool.get();
	}
	
	public var reverse					:Bool;
	
	private var _property				:String;
	private var _start					:Dynamic;
	private var _stop					:Dynamic;
	private var _target					:Dynamic;
	
	// -------------------------------------------------------------------------
	public function new() 
	{
		super();
	}
	
	// -------------------------------------------------------------------------
	public function init(target:Dynamic, property:String, start:Dynamic, stop:Dynamic):Void
	{
		_target 	= target;
		_property 	= property;
		_start 		= start;
		_stop 		= stop;
	}
	
	// -------------------------------------------------------------------------
	public function isTarget(target:Dynamic):Bool {
		return _target == target;
	}
	
	// -------------------------------------------------------------------------
	public function update(progress:Float):Void {
		var s:Float 		= cast( (reverse ? _stop : _start), Float );
		var e:Float 		= cast( (reverse ? _start : _stop), Float );
		var value:Float		= s + ( (e - s) * progress );
		var prop:Dynamic	= Reflect.getProperty(_target, _property);
		
		if ( Std.is( prop, Float ) ) {
			Reflect.setProperty( _target, _property, value );
		}
		else if ( Std.is( prop, Int ) ) {
			Reflect.setProperty( _target, _property, Std.int(value) );
		}
	}
	
	// -------------------------------------------------------------------------
	public function invalidate():Void {
		
	}
	
	// -------------------------------------------------------------------------
	override function onDeactivate():Void 
	{
		reverse = false;
		_target = null;
		_start	= null;
		_stop	= null;
	}
}