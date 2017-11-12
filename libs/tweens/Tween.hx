package libs.tweens;

import libs.interfaces.ITweenData;
import libs.pool.Pool;
import libs.pool.PoolableObject;
import libs.utils.Callback;
import libs.utils.Duration;
import openfl.display.DisplayObject;

/**
 * ...
 * @author Tamar Curry
 */
class Tween extends PoolableObject
{
	private static var _pool:Pool<Tween> = new Pool( function():Tween { return new Tween(); } );
	
	@:allow(libs.tweens.TweenManager)
	private static function fetch():Tween {
		return _pool.get();
	}
	// This easing type can't be overridden!
	private static inline var DELAYED_CALL			:String = "delayed_call";
	
	// These can
	public static inline var LINEAR					:String = "linear";
	
	public static inline var BACK_EASE_IN			:String = "back_ease_in";
	public static inline var BACK_EASE_OUT			:String = "back_ease_out";
	public static inline var BACK_EASE_IN_OUT		:String = "back_ease_in_out";
	
	public static inline var BOUNCE_EASE_IN			:String = "bounce_ease_in";
	public static inline var BOUNCE_EASE_OUT		:String = "bounce_ease_out";
	public static inline var BOUNCE_EASE_IN_OUT		:String = "bounce_ease_in_out";
	
	public static inline var CIRC_EASE_IN			:String = "circ_ease_in";
	public static inline var CIRC_EASE_OUT			:String = "circ_ease_out";
	public static inline var CIRC_EASE_IN_OUT		:String = "circ_ease_in_out";
	
	public static inline var CUBIC_EASE_IN			:String = "cubic_ease_in";
	public static inline var CUBIC_EASE_OUT			:String = "cubic_ease_out";
	public static inline var CUBIC_EASE_IN_OUT		:String = "cubic_ease_in_out";
	
	public static inline var ELASTIC_EASE_IN		:String = "elastic_ease_in";
	public static inline var ELASTIC_EASE_OUT		:String = "elastic_ease_out";
	public static inline var ELASTIC_EASE_IN_OUT	:String = "elastic_ease_in_out";
	
	public static inline var EXPO_EASE_IN			:String = "expo_ease_in";
	public static inline var EXPO_EASE_OUT			:String = "expo_ease_out";
	public static inline var EXPO_EASE_IN_OUT		:String = "expo_ease_in_out";
	
	public static inline var QUAD_EASE_IN			:String = "quad_ease_in";
	public static inline var QUAD_EASE_OUT			:String = "quad_ease_out";
	public static inline var QUAD_EASE_IN_OUT		:String = "quad_ease_in_out";
	
	public static inline var QUART_EASE_IN			:String = "quart_ease_in";
	public static inline var QUART_EASE_OUT			:String = "quart_ease_out";
	public static inline var QUART_EASE_IN_OUT		:String = "quart_ease_in_out";
	
	public static inline var QUINT_EASE_IN			:String = "quint_ease_in";
	public static inline var QUINT_EASE_OUT			:String = "quint_ease_out";
	public static inline var QUINT_EASE_IN_OUT		:String = "quint_ease_in_out";
	
	public static inline var SINE_EASE_IN			:String = "sine_ease_in";
	public static inline var SINE_EASE_OUT			:String = "sine_ease_out";
	public static inline var SINE_EASE_IN_OUT		:String = "sine_ease_in_out";
	
	private static var EMPTY						:TweenGhost = new TweenGhost();
	
	private var _lastUpdate	:Int;
	private var _repeat		:Int;
	private var _paused		:Bool;
	private var _yoyo		:Bool;
	private var _easeType	:String;
	private var _name		:String;
	
	private var _onStart	:Callback;
	private var _onUpdate	:Callback;
	private var _onComplete	:Callback;
	private var _onRepeat	:Callback;
	private var _tweenData	:Array<ITweenData>;
	
	private var _duration	:Duration;
	private var _delay		:Duration;
	private var _easing		:Float->Float->Float->Float->Float;
	
	// -----------------------------------------------------------------------------------------------
	// -----------------------------------------------------------------------------------------------
	public var finished(default, null):Bool;
	
	// -----------------------------------------------------------------------------------------------
	// -----------------------------------------------------------------------------------------------
	public function new() 
	{
		super();
		_tweenData = new Array<ITweenData>();
		
		_onStart 	= new Callback();
		_onUpdate	= new Callback();
		_onComplete	= new Callback();
		_onRepeat	= new Callback();
		
		_duration	= new Duration();
		_delay		= new Duration();
	}
	
	// -----------------------------------------------------------------------------------------------
	@:allow(libs.tweens.TweenManager)
	private function init(time:Int, useFrames:Bool = false):Void
	{
		if ( time <= 0 ) {
			throw "Time must be greater than zero";
		}
		_repeat = 0;
		_name = null;
		setEasing(QUAD_EASE_OUT);
		_duration.init(time, useFrames);
		delay(0, false);
	}
	
	// -------------------------------------------------------------------------
	public function delay(time:Int, useFrames:Bool=false):Tween {
		_delay.init(time, useFrames);
		return this;
	}
	
	// -------------------------------------------------------------------------
	public function repeat(numRepeats:Int, yoyo:Bool = false):Tween {
		_repeat = numRepeats;
		_yoyo = yoyo;
		return this;
	}
	
	// -------------------------------------------------------------------------
	public function onStart(callback:Void->Void):Tween {
		_onStart.setCallback(callback);
		return this;
	}
	
	// -------------------------------------------------------------------------
	public function onRepeat(callback:Void->Void):Tween {
		_onRepeat.setCallback(callback);
		return this;
	}
	
	// -------------------------------------------------------------------------
	public function onUpdate(callback:Void->Void):Tween {
		_onUpdate.setCallback(callback);
		return this;
	}
	
	// -------------------------------------------------------------------------
	public function onComplete(callback:Void->Void):Tween {
		_onComplete.setCallback(callback);
		return this;
	}
	
	// -----------------------------------------------------------------------------------------------
	public function setEasing(easing:String):Tween {
		if ( _easeType != DELAYED_CALL ) {
			_easeType 	= easing;
			_easing 	= getEasing(easing);
		}
		return this;
	}
	
	// -------------------------------------------------------------------------
	private function setTweenData(target:Dynamic, properties:Dynamic, reverse:Bool):Void {
		var fields:Array<String> = Reflect.fields(properties);
		
		var s:String;
		var t:TweenData;
		for ( s in fields ) {
			if ( Reflect.getProperty(target, s) == null ) {
				throw "Object " + Std.string(target) + " has no property " + s;
			}
			
			t = TweenData.fetch();
			t.init(target, s, Reflect.getProperty(target, s), Reflect.getProperty(properties, s) );
			t.reverse 	= reverse;
			t.update(0);
			_tweenData.push(t);
		}
	}

	// -------------------------------------------------------------------------
	public function toFloat(start:Float, stop:Float, onNumberUpdate:Float->Void):Tween
	{
		var t:TweenFloat = TweenFloat.fetch();
		t.init(start, stop, onNumberUpdate);
		_tweenData.push(t);
		return this;
	}
	
	// -------------------------------------------------------------------------
	public function toInt(start:Int, stop:Int, onIntUpdate:Int->Void):Tween
	{
		var t:TweenInt = TweenInt.fetch();
		t.init(start, stop, onIntUpdate);
		_tweenData.push(t);
		return this;
	}
	
	// -------------------------------------------------------------------------
	public function to(target:Dynamic, properties:Dynamic):Tween {
		setTweenData(target, properties, false);
		return this;
	}
	
	// -------------------------------------------------------------------------
	public function from(target:Dynamic, properties:Dynamic):Tween {
		setTweenData(target, properties, true);
		return this;
	}
	
	// -------------------------------------------------------------------------
	private function getMatrix(target:DisplayObject, reverse:Bool, a:Float = null, b:Float = null, c:Float = null, d:Float = null, tx:Float = null, ty:Float = null):TweenMatrix {
		var tweenMatrix:TweenMatrix = TweenMatrix.fetch();
		tweenMatrix.init(target);
		if ( a != null ) { tweenMatrix.a = a; }
		if ( b != null ) { tweenMatrix.b = b; }
		if ( c != null ) { tweenMatrix.c = c; }
		if ( d != null ) { tweenMatrix.d = d; }
		if ( tx != null) { tweenMatrix.tx = tx; }
		if ( ty != null ) { tweenMatrix.ty = ty; }
		tweenMatrix.reverse = reverse;
		tweenMatrix.update(0);
		return tweenMatrix;
	}
	
	// -------------------------------------------------------------------------
	public function toMatrix( target:DisplayObject, a:Float = null, b:Float = null, c:Float = null, d:Float = null, tx:Float = null, ty:Float = null ):Tween {
		_tweenData.push( getMatrix(target, false, a, b, c, d, tx, ty) );
		return this;
	}
	
	// -------------------------------------------------------------------------
	public function fromMatrix( target:DisplayObject, a:Float = null, b:Float = null, c:Float = null, d:Float = null, tx:Float = null, ty:Float = null ):Tween {
		_tweenData.push( getMatrix(target, true, a, b, c, d, tx, ty) );
		return this;
	}
	
	// -------------------------------------------------------------------------
	private function getColorTween(target:DisplayObject, color:Int, amount:Float, reverse:Bool):TweenColor {
		var tweenColor:TweenColor = TweenColor.fetch();
		tweenColor.init(target, color, amount);
		tweenColor.reverse = reverse;
		tweenColor.update(0);
		return tweenColor;
	}
	
	// -------------------------------------------------------------------------
	public function tintTo(target:DisplayObject, color:Int, amount:Float = 1):Tween {
		_tweenData.push( getColorTween(target, color, amount, false) );
		return this;
	}
	
	// -------------------------------------------------------------------------
	public function tintFrom(target:DisplayObject, color:Int, amount:Float = 1):Tween {
		_tweenData.push( getColorTween(target, color, amount, true) );
		return this;
	}
	
	// -------------------------------------------------------------------------
	public function pause():Tween {
		_paused = true;
		return this;
	}
	
	// -------------------------------------------------------------------------
	public function unpause():Tween {
		_paused = false;
		return this;
	}
	
	// -------------------------------------------------------------------------
	public function delayedCall(callback:Void->Void):Void {
		_tweenData.push( EMPTY );
		onComplete(callback);
		setEasing(DELAYED_CALL);
	}
	
	// -----------------------------------------------------------------------------------------------
	private function getEasing( easing:String ):Float->Float->Float->Float->Float {
		var func:Float->Float->Float->Float->Float;
		switch(easing) {
			case LINEAR					: func = Equations.linear;
			case DELAYED_CALL			: func = Equations.linear;
			case BACK_EASE_IN 			: func = Equations.backEaseIn;
			case BACK_EASE_OUT 			: func = Equations.backEaseOut;
			case BACK_EASE_IN_OUT 		: func = Equations.backEaseInOut;
			case BOUNCE_EASE_IN 		: func = Equations.bounceEaseIn;
			case BOUNCE_EASE_OUT 		: func = Equations.bounceEaseOut;
			case BOUNCE_EASE_IN_OUT 	: func = Equations.bounceEaseInOut;
			case CIRC_EASE_IN 			: func = Equations.circEaseIn;
			case CIRC_EASE_OUT 			: func = Equations.circEaseOut;
			case CIRC_EASE_IN_OUT 		: func = Equations.circEaseInOut;
			case CUBIC_EASE_IN 			: func = Equations.cubicEaseIn;
			case CUBIC_EASE_OUT 		: func = Equations.cubicEaseOut;
			case CUBIC_EASE_IN_OUT 		: func = Equations.cubicEaseInOut;
			case ELASTIC_EASE_IN 		: func = Equations.elasticEaseIn;
			case ELASTIC_EASE_OUT 		: func = Equations.elasticEaseOut;
			case ELASTIC_EASE_IN_OUT	: func = Equations.elasticEaseInOut;
			case EXPO_EASE_IN 			: func = Equations.expoEaseIn;
			case EXPO_EASE_OUT 			: func = Equations.expoEaseOut;
			case EXPO_EASE_IN_OUT 		: func = Equations.expoEaseInOut;
			case QUAD_EASE_IN 			: func = Equations.quadEaseIn;
			case QUAD_EASE_OUT 			: func = Equations.quadEaseOut;
			case QUAD_EASE_IN_OUT 		: func = Equations.quadEaseInOut;
			case QUART_EASE_IN 			: func = Equations.quartEaseIn;
			case QUART_EASE_OUT 		: func = Equations.quartEaseOut;
			case QUART_EASE_IN_OUT 		: func = Equations.quartEaseInOut;
			case QUINT_EASE_IN 			: func = Equations.quintEaseIn;
			case QUINT_EASE_OUT 		: func = Equations.quintEaseOut;
			case QUINT_EASE_IN_OUT 		: func = Equations.quintEaseInOut;
			case SINE_EASE_IN 			: func = Equations.sineEaseIn;
			case SINE_EASE_OUT 			: func = Equations.sineEaseOut;
			case SINE_EASE_IN_OUT 		: func = Equations.sineEaseInOut;
			default						: func = Equations.quadEaseOut;
		}
		
		return func;
	}
	
	// -------------------------------------------------------------------------
	private function getReverseEasing(easing:String):String {
		var result:String = easing;
		
		switch(easing) {
			case BACK_EASE_IN:
				result = BACK_EASE_OUT;
			case BACK_EASE_OUT:
				result = BACK_EASE_IN;
			case BOUNCE_EASE_IN:
				result = BOUNCE_EASE_OUT;
			case BOUNCE_EASE_OUT:
				result = BOUNCE_EASE_IN;
			case CIRC_EASE_IN:
				result = CIRC_EASE_OUT;
			case CIRC_EASE_OUT:
				result = CIRC_EASE_IN;
			case CUBIC_EASE_IN:
				result = CUBIC_EASE_OUT;
			case CUBIC_EASE_OUT:
				result = CUBIC_EASE_IN;
			case ELASTIC_EASE_IN:
				result = ELASTIC_EASE_OUT;
			case ELASTIC_EASE_OUT:
				result = ELASTIC_EASE_IN;
			case EXPO_EASE_IN:
				result = EXPO_EASE_OUT;
			case EXPO_EASE_OUT:
				result = EXPO_EASE_IN;
			case QUAD_EASE_IN:
				result = QUAD_EASE_OUT;
			case QUAD_EASE_OUT:
				result = QUAD_EASE_IN;
			case QUART_EASE_IN:
				result = QUART_EASE_OUT;
			case QUART_EASE_OUT:
				result = QUART_EASE_IN;
			case QUINT_EASE_IN:
				result = QUINT_EASE_OUT;
			case QUINT_EASE_OUT:
				result = QUINT_EASE_IN;
			case SINE_EASE_IN:
				result = SINE_EASE_OUT;
			case SINE_EASE_OUT:
				result = SINE_EASE_IN;
		}
		
		return result;
	}
	
	// -------------------------------------------------------------------------
	private function canRepeat():Bool {
		if ( _repeat > 0 ) {
			--_repeat;
			if ( _yoyo ) {
				var tweenData:ITweenData;
				for ( tweenData in _tweenData ) {
					tweenData.invalidate();
					tweenData.reverse = !tweenData.reverse;
				}
				setEasing( getReverseEasing(_easeType) );
			}
			return true;
		}
		
		return false;
	}
	
	// -------------------------------------------------------------------------
	private function updateAllTweenData():Void {
		var progress:Float = 0;
		
		if ( _duration.time > 0 ) {
			progress = _easing(_duration.elapsed, 0, 1, _duration.time);
		}
		else {
			progress = 1;
		}
		
		var tweenData:ITweenData;
		for ( tweenData in _tweenData ) {
			tweenData.update(progress);
		}
	}
	
	// -------------------------------------------------------------------------
	public function isTweening(target:Dynamic):Bool
	{
		for ( t in _tweenData ) {
			if ( t.isTarget(target) ) {
				return true;
			}
		}
		return false;
	}
	
	// -------------------------------------------------------------------------
	public function update(ms:Int):Void {
		if ( _lastUpdate == Globals.time || finished ) {
			return;
		}
		
		_lastUpdate = Globals.time;
		
		if ( _paused ) {
			return;
		}
		
		_delay.update(ms, 1);
		
		if ( _delay.elapsed < _delay.time ) {
			return;
		}
		
		if ( _duration.elapsed == 0 ) {
			_onStart.invoke();
		}
		
		_duration.update(ms, 1);
		updateAllTweenData();
		_onUpdate.invoke();
		
		if ( _duration.elapsed == _duration.time ) {
			if ( canRepeat() ) {
				_onRepeat.invoke();
				_duration.reset();
			}
			else {
				finished = true;
				_onComplete.invoke();
			}
		}
	}
	
	// -------------------------------------------------------------------------
	public function end(completeTween:Bool = false, executeCompletionCallback:Bool = false):Void {
		if ( finished ) {
			return;
		}
		
		_duration.setElapsed( _duration.time );
		finished = true;
		
		if ( completeTween ) {
			updateAllTweenData();
		}
		
		if ( executeCompletionCallback ) {
			_onComplete.invoke();
		}
	}
	
	// -------------------------------------------------------------------------
	public function killTweensOf(target:Dynamic, completeTween:Bool=false, executeCompletionCallback:Bool = false):Void {
		var t:ITweenData;
		var i:Int = _tweenData.length - 1;
		while ( i > 0 ) {
			t = _tweenData[i];
			if ( t.isTarget(target) ) {
				if ( completeTween ) {
					_tweenData[i].update(1);
				}
				_tweenData.splice(i, 1);
				t.destroy();
			}
			--i;
		}
		
		if ( _tweenData.length == 0 && executeCompletionCallback ) {
			end(false, true);
		}
	}
	
	// -------------------------------------------------------------------------
	override function onDeactivate():Void 
	{
		Funcs.destroy(_tweenData);
		_tweenData.splice(0, _tweenData.length);
	}
}