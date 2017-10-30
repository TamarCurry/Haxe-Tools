package libs;

import libs.queue.Queue;
import libs.tweens.TweenManager;
import openfl.events.EventDispatcher;
import openfl.events.Event;
import openfl.display.Stage;
import openfl.Lib;
import libs.events.GlobalEvent;

/**
 * ...
 * @author Tamar Curry
 */
class Globals
{
	private static var _elapsed:Int;
	public static var gameWidth(default, null):Int;
	public static var gameHeight(default, null):Int;
	public static var time(default, null):Int;
	public static var ms(default, null):Int;
	public static var sec(default, null):Float;
	public static var stage(default, null):Stage;
	public static var dispatcher(default, null):EventDispatcher = new EventDispatcher();
	public static var tweens(default, null):TweenManager = new TweenManager();
	public static var queue(default, null):Queue = new Queue();
	
	// -----------------------------------------------------------------------------------------------
	// -----------------------------------------------------------------------------------------------
	public static function init(s:Stage):Void
	{
		if ( stage != null ) { return; }
		trace("Globals::init");
		stage = s;
		time = 0;
		ms = 0;
		_elapsed = 0;
		gameWidth = stage.stageWidth;
		gameHeight = stage.stageHeight;
		stage.addEventListener(Event.ENTER_FRAME, onUpdate);
		updateTime();
	}
	
	// -----------------------------------------------------------------------------------------------
	private static function updateTime():Void
	{
		var prevTime:Int = time;
		time = Lib.getTimer();
		
		if ( prevTime > 0 ) {
			ms = time - prevTime;
		}
		sec = ms * 0.001;
	}
	
	// -----------------------------------------------------------------------------------------------
	private static function updateElapsed():Void
	{
		_elapsed += ms;
		
		if ( _elapsed >= 1000 )  {
			_elapsed %= 1000;
			dispatcher.dispatchEvent( new Event(GlobalEvent.ONE_SECOND_PASSED) );
		}
	}
	
	// -----------------------------------------------------------------------------------------------
	private static function onUpdate(e:Event):Void
	{
		updateTime();
		
		dispatcher.dispatchEvent( new Event(GlobalEvent.PROCESS_STOWED) );
		dispatcher.dispatchEvent( new Event(TweenManager.UPDATE_TWEENS) );
		dispatcher.dispatchEvent( new Event(Queue.UPDATE_QUEUE) );
		dispatcher.dispatchEvent( new Event(GlobalEvent.UPDATE) );
		
		updateElapsed();
	}
}