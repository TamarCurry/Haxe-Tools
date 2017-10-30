package libs.tweens;

import libs.interfaces.ITweenData;
import libs.pool.Pool;
import libs.pool.PoolableObject;
import openfl.display.DisplayObject;
import openfl.geom.Matrix;
	
/**
 * Allows for tweening dictated by a transformation matrix.
 * @author Tamar Curry
 */
class TweenMatrix extends PoolableObject implements ITweenData
{
	private static var _pool:Pool<TweenMatrix> = new Pool( function():TweenMatrix { return new TweenMatrix(); } );
	
	@:allow(libs.tweens.Tween)
	private static function fetch():TweenMatrix {
		return _pool.get();
	}
	
	public var a						:Float;
	public var b						:Float;
	public var c						:Float;
	public var d						:Float;
	public var tx						:Float;
	public var ty						:Float;
	
	public var reverse					:Bool;
	
	private var _target					:DisplayObject;
	private var _startMatrix			:Matrix;
	
	// -----------------------------------------------------------------------------------------------
	/**
	 * Constructor
	 */
	public function new() 
	{
		super();
		_startMatrix = new Matrix();
	}
	
	// -----------------------------------------------------------------------------------------------
	public function init(target:DisplayObject):Void
	{
		_target = target;
		_startMatrix.copyFrom( _target.transform.matrix );
	}
	
	// -----------------------------------------------------------------------------------------------
	/**
	 * Invalidates any data retrieved from the target.
	 */
	public function invalidate():Void {
		//_startMatrix = null;
	}
	
	// -------------------------------------------------------------------------
	public function isTarget(target:Dynamic):Bool {
		return _target == target;
	}
	
	// -----------------------------------------------------------------------------------------------
	/**
	 * Uses the progress to determine what the current value is.
	 * @param	start
	 * @param	end
	 * @param	progress
	 * @return
	 */
	private function getUpdatedValue(start:Float, end:Float, progress:Float):Float {
		var a:Float = reverse ? end : start;
		var b:Float = reverse ? start : end;
		var v:Float = a + ( (b - a) * progress );
		return v;
	}
	
	// -----------------------------------------------------------------------------------------------
	/**
	 * Updates the target's transformation matrix.
	 * @param	target
	 * @param	progress
	 */
	public function update(progress:Float):Void {
		
		var matrix:Matrix = _target.transform.matrix;
		if ( !Math.isNaN(a) ) {
			matrix.a = getUpdatedValue(_startMatrix.a, a, progress);
		}
		
		if ( !Math.isNaN(b) ) {
			matrix.b = getUpdatedValue(_startMatrix.b, b, progress);
		}
		
		if ( !Math.isNaN(c) ) {
			matrix.c = getUpdatedValue(_startMatrix.c, c, progress);
		}
		
		if ( !Math.isNaN(d) ) {
			matrix.d = getUpdatedValue(_startMatrix.d, d, progress);
		}
		
		if ( !Math.isNaN(tx) ) {
			matrix.tx = getUpdatedValue(_startMatrix.tx, tx, progress);
		}
		
		if ( !Math.isNaN(ty) ) {
			matrix.ty = getUpdatedValue(_startMatrix.ty, ty, progress);
		}
		
		_target.transform.matrix = matrix;
	}
	
	
	// -----------------------------------------------------------------------------------------------
	override function onDeactivate():Void 
	{
		_target = null;
	}
}