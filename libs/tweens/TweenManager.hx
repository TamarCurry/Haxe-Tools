package libs.tweens;

import libs.baseClasses.Destroyable;
import libs.events.GlobalEvent;
import openfl.display.DisplayObject;
import openfl.events.Event;

/**
 * ...
 * @author Tamar Curry
 */
class TweenManager extends Destroyable
{
	@:allow(libs.Globals)
	private static inline var UPDATE_TWEENS:String = "Tween.updateTweens";
	
	public var autoRun	:Bool;
	
	private var _tweens	:Array<Tween>;
	
	// -----------------------------------------------------------------------------------------------
	// -----------------------------------------------------------------------------------------------
	public var numTweens(get, null):Int;
	
	// -----------------------------------------------------------------------------------------------
	// -----------------------------------------------------------------------------------------------
	private function get_numTweens():Int {
		var num:Int = 0;
		var i:Int;
		var len:Int = _tweens.length;
		var tween:Tween;
		for ( i in 0...len ) {
			tween = _tweens[i];
			if ( tween != null && !tween.finished ) {
				++num;
			}
		}
		return num;
	}
	
	// -----------------------------------------------------------------------------------------------
	// -----------------------------------------------------------------------------------------------
	public function new(canAutoRun:Bool=true) 
	{
		super();
		autoRun = canAutoRun;
		_tweens = new Array<Tween>();
		setListeners(true);
	}
	
	// -----------------------------------------------------------------------------------------------
	private function setListeners(active:Bool):Void
	{
		Funcs.setListener( Globals.dispatcher, active, UPDATE_TWEENS, onUpdate );
		Funcs.setListener( Globals.dispatcher, active, GlobalEvent.ONE_SECOND_PASSED, onSecondPassed );
	}
	
	// -----------------------------------------------------------------------------------------------
	public function update():Void
	{
		if ( autoRun ) { return; }
		updateTweens();
	}
	
	// -----------------------------------------------------------------------------------------------
	private function onUpdate(e:Event):Void
	{
		if ( !autoRun ) { return; }
		updateTweens();
	}
	
	// -----------------------------------------------------------------------------------------------
	private function onSecondPassed(e:Event):Void {
		cleanUp();
	}
	
	// -------------------------------------------------------------------------
	private function addTween(time:Int, useFrames:Bool):Tween {
		var tween:Tween = Tween.fetch();
		tween.init(time, useFrames);
		_tweens.push(tween);
		return tween;
	}
	
	// -------------------------------------------------------------------------
	public function toInt(time:Int, start:Int, stop:Int, onUpdate:Int->Void, useFrames:Bool = false):Tween {
		return addTween(time, useFrames).toInt(start, stop, onUpdate);
	}
	
	// -------------------------------------------------------------------------
	public function toFloat(time:Int, start:Float, stop:Float, onUpdate:Float->Void, useFrames:Bool = false):Tween {
		return addTween(time, useFrames).toFloat(start, stop, onUpdate);
	}
	
	// -------------------------------------------------------------------------
	public function to(target:Dynamic, time:Int, properties:Dynamic, useFrames:Bool = false):Tween {
		return addTween(time, useFrames).to(target, properties);
	}
	
	// -------------------------------------------------------------------------
	public function from(target:Dynamic, time:Int, properties:Dynamic, useFrames:Bool = false):Tween {
		return addTween(time, useFrames).from(target, properties);
	}
	
	// -------------------------------------------------------------------------
	public function toMatrix( target:DisplayObject, time:Int, a:Float = null, b:Float = null, c:Float = null, d:Float = null, tx:Float = null, ty:Float = null, useFrames:Bool = false ):Tween {
		return addTween(time, useFrames).toMatrix( target, a, b, c, d, tx, ty );
	}
	
	// -------------------------------------------------------------------------
	public function fromMatrix( target:DisplayObject, time:Int, a:Float = null, b:Float = null, c:Float = null, d:Float = null, tx:Float = null, ty:Float = null, useFrames:Bool = false ):Tween {
		return addTween(time, useFrames).fromMatrix( target, a, b, c, d, tx, ty );
	}
	
	// -------------------------------------------------------------------------
	public function delayedCall(callback:Void->Void, time:Int, useFrames:Bool = false):Void {
		addTween(time, useFrames).delayedCall(callback);
	}
	
	// -----------------------------------------------------------------------------------------------
	public function tintTo(target:DisplayObject, time:Int, color:Int, amount:Float = 1, useFrames:Bool = false):Tween {
		return addTween(time, useFrames).tintTo(target, color, amount);
	}
	
	// -----------------------------------------------------------------------------------------------
	public function tintFrom(target:DisplayObject, time:Int, color:Int, amount:Float = 1, useFrames:Bool = false):Tween {
		return addTween(time, useFrames).tintFrom(target, color, amount);
	}
	
	// -----------------------------------------------------------------------------------------------
	public function isTweening(target:Dynamic):Bool
	{
		for ( t in _tweens ) {
			if ( t.isTweening(target) ) {
				return true;
			}
		}
		return false;
	}
	
	// -----------------------------------------------------------------------------------------------
	private function updateTweens():Void
	{
		if ( this.isExpired ) { return; }
		
		var ms:Int = Globals.ms;
		var t:Tween;
		var len:Int = _tweens.length;
		for ( i in 0...len ) {
			if ( this.isExpired ) { return; }
			t = _tweens[i];
			if ( t != null ) {
				t.update(ms);
			}
		}
	}
	
	// -------------------------------------------------------------------------
	public function killTweensOf(target:Dynamic, completeTween:Bool=false, executeCompletionCallback:Bool = false):Void
	{
		for ( t in _tweens ) {
			t.killTweensOf(target, completeTween, executeCompletionCallback);
		}
	}
	
	// -------------------------------------------------------------------------
	public function killAllTweens():Void {
		_tweens = Funcs.destroy(_tweens);
		_tweens = new Array<Tween>();
	}
	
	// -------------------------------------------------------------------------
	private function cleanUp():Void {
		if ( this.isExpired ) { return; }
		var i:Int = _tweens.length - 1;
		while ( i >= 0 ) {
			if ( _tweens[i] == null || _tweens[i].finished ) {
				_tweens.splice(i, 1);
			}
			--i;
		}
	}
	
	// -------------------------------------------------------------------------
	public override function destroy():Void {
		if ( this == Globals.tweens || this.isExpired ) {
			return;
		}
		setListeners(false);
		super.destroy();
		_tweens = Funcs.destroy( _tweens );
	}
}