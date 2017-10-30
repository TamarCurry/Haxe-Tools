package libs.queue;

import libs.baseClasses.Destroyable;
import libs.events.GlobalEvent;
import libs.pool.Pool;
import openfl.events.Event;

/**
 * ...
 * @author Tamar Curry
 */
class Queue extends Destroyable
{
	@:allow(libs.Globals)
	private static inline var UPDATE_QUEUE:String = "Queue.updateQueue";
	
	private static var _callPool:Pool<SimpleCall> 	= new Pool<SimpleCall>( function():SimpleCall { return new SimpleCall(); } );
	private static var _queryPool:Pool<QueryCall> 	= new Pool<QueryCall>( function():QueryCall { return new QueryCall(); } );
	private static var _repeatPool:Pool<RepeatCall> = new Pool<RepeatCall>( function():RepeatCall { return new RepeatCall(); } );
	private static var _pausePool:Pool<PauseAction> = new Pool<PauseAction>( function():PauseAction { return new PauseAction(); } );
	
	public var autoRun:Bool;
	private var _lastUpdate:Int;
	private var _actions:Array<QueuedAction>;
	
	// -----------------------------------------------------------------------------------------------
	// -----------------------------------------------------------------------------------------------
	public var length(get, null):Int;
	private function get_length():Int { return _actions.length; }
	
	// -----------------------------------------------------------------------------------------------
	// -----------------------------------------------------------------------------------------------
	public function new(runAutomatically:Bool=true) 
	{
		super();
		_actions = new Array<QueuedAction>();
		this.autoRun = runAutomatically;
		setListeners(true);
	}
	
	// -----------------------------------------------------------------------------------------------
	private function setListeners(active:Bool):Void
	{
		Funcs.setListener( Globals.dispatcher, active, UPDATE_QUEUE, onUpdate );
	}
	
	// -----------------------------------------------------------------------------------------------
	private function onUpdate(e:Event):Void
	{
		if ( !autoRun ) { return; }
		updateQueue();
	}
	
	// -----------------------------------------------------------------------------------------------
	public function update():Void
	{
		if ( autoRun ) { return; }
		updateQueue();
	}
	
	// -----------------------------------------------------------------------------------------------
	private function updateQueue():Void
	{
		if ( _lastUpdate == Globals.time ) { return; }
		_lastUpdate = Globals.time;
		
		var i:Int;
		var a:QueuedAction;
		var numToRemove:Int = 0;
		
		for ( i in 0..._actions.length ) {
			a = _actions[i];
			a.execute();
			if ( !a.isFinished || isExpired ) { break; }
			++numToRemove;
		}
		
		if ( numToRemove > 0 && !isExpired ) {
			for ( i in 0...numToRemove ) {
				_actions[i].destroy();
			}
			_actions.splice(0, numToRemove);
		}
	}
	
	// -----------------------------------------------------------------------------------------------
	public function call( callback:Void->Void ):Void
	{
		var action:SimpleCall = _callPool.get();
		action.setCallback( callback );
		_actions.push(action);
	}
	
	// -----------------------------------------------------------------------------------------------
	public function query( callback:Void->Bool ):Void
	{
		var action:QueryCall = _queryPool.get();
		action.setCallback( callback );
		_actions.push(action);
	}
	
	// -----------------------------------------------------------------------------------------------
	public function repeat( callback:Void->Void, time:Int, useFrames:Bool=false ):Void
	{
		var action:RepeatCall = _repeatPool.get();
		action.setCallback(callback);
		action.setTime(time, useFrames);
		_actions.push(action);
	}
	
	// -----------------------------------------------------------------------------------------------
	public function pause( time:Int, useFrames:Bool=false ):Void
	{
		var action:PauseAction = _pausePool.get();
		action.setTime(time, useFrames);
		_actions.push(action);
	}
	
	// -----------------------------------------------------------------------------------------------
	override public function destroy():Void 
	{
		if ( isExpired ) { return; }
		setListeners(false);
		super.destroy();
		
		_actions = Funcs.destroy(_actions);
	}
}