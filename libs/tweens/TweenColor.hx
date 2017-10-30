package libs.tweens;

import libs.interfaces.ITweenData;
import libs.pool.Pool;
import libs.pool.PoolableObject;
import openfl.display.DisplayObject;
import openfl.geom.ColorTransform;

/**
 * Class for handling color shifts when tinting a display object.
 * @author Tamar Curry
 */
class TweenColor extends PoolableObject implements ITweenData
{
	private static var _pool:Pool<TweenColor> = new Pool( function():TweenColor { return new TweenColor(); } );
	
	@:allow(libs.tweens.Tween)
	private static function fetch():TweenColor {
		return _pool.get();
	}
	
	private static var _currentColorTransform :ColorTransform = new ColorTransform();
	
	// -----------------------------------------------------------------------------------------------
	// MEMBERS
	// -----------------------------------------------------------------------------------------------
	
	private var _color						:Int;
	private var _amount						:Float;
	private var _target						:DisplayObject;
	private var _originalColorTransform		:ColorTransform;
	private var _colorTransform				:ColorTransform;
	
	public var reverse						:Bool;
	
	// -----------------------------------------------------------------------------------------------
	// METHODS
	// -----------------------------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 * @param	color
	 * @param	amount
	 */
	public function new() 
	{
		super();
		_colorTransform 			= new ColorTransform();
		_originalColorTransform		= new ColorTransform();
	}
	
	// -------------------------------------------------------------------------
	public function init(target:DisplayObject, color:Int, amount:Float = 1) :Void
	{
		
		_target									= target;
		_color									= color;
		_amount									= amount;
		
		_colorTransform.redOffset				= ( color >> 16 ) * _amount;
		_colorTransform.greenOffset				= ( (color >> 8) & 0xff) * _amount;
		_colorTransform.blueOffset				= (color & 0xff) * _amount;
		
		_colorTransform.redMultiplier			= 1 - _amount;
		_colorTransform.greenMultiplier			= 1 - _amount;
		_colorTransform.blueMultiplier			= 1 - _amount;
		
		_originalColorTransform.color			= _target.transform.colorTransform.color;
		_originalColorTransform.redOffset		= _target.transform.colorTransform.redOffset;
		_originalColorTransform.greenOffset		= _target.transform.colorTransform.greenOffset;
		_originalColorTransform.blueOffset		= _target.transform.colorTransform.blueOffset;
		
		_originalColorTransform.redMultiplier	= _target.transform.colorTransform.redMultiplier;
		_originalColorTransform.greenMultiplier	= _target.transform.colorTransform.greenMultiplier;
		_originalColorTransform.blueMultiplier	= _target.transform.colorTransform.blueMultiplier;
	}
	
	// -------------------------------------------------------------------------
	public function isTarget(target:Dynamic):Bool {
		return _target == target;
	}
	
	// -----------------------------------------------------------------------------------------------
	public function invalidate():Void {
		
	}
	
	// -----------------------------------------------------------------------------------------------
	/**
	 * Updates the color transform on the specified target.
	 * @param	target
	 * @param	progress
	 */
	public function update(progress:Float):Void {
		_currentColorTransform.redOffset		= getTransform( _originalColorTransform.redOffset, 		_colorTransform.redOffset,	progress);
		_currentColorTransform.greenOffset		= getTransform( _originalColorTransform.greenOffset,	_colorTransform.greenOffset,	progress);
		_currentColorTransform.blueOffset		= getTransform( _originalColorTransform.blueOffset,		_colorTransform.blueOffset,	progress);
		
		_currentColorTransform.redMultiplier	= getTransform( _originalColorTransform.redMultiplier, 		_colorTransform.redMultiplier,		progress);
		_currentColorTransform.greenMultiplier	= getTransform( _originalColorTransform.greenMultiplier,	_colorTransform.greenMultiplier,	progress);
		_currentColorTransform.blueMultiplier	= getTransform( _originalColorTransform.blueMultiplier,		_colorTransform.blueMultiplier,	progress);
		
		_target.transform.colorTransform 		= _currentColorTransform;
	}
	
	// -----------------------------------------------------------------------------------------------
	/**
	 * Takes to values and interpolates the value between them using the given progress.
	 * @param	originalValue
	 * @param	newValue
	 * @param	progress
	 * @return
	 */
	private function getTransform(originalValue:Float, newValue:Float, progress:Float):Float {
		var value:Float = originalValue;
		var n:Float = reverse ? originalValue : newValue;
		var o:Float = reverse ? newValue : originalValue;
		if ( !Math.isNaN(n) ) {
			value = o + ( (n - o) * progress );
		}
		return value;
	}
	
	// -----------------------------------------------------------------------------------------------
	override function onDeactivate():Void 
	{
		_target						= null;
		_originalColorTransform		= null;
		_colorTransform				= null;
	}
}