package libs.pool;

import libs.baseClasses.Destroyable;
import libs.events.GlobalEvent;
import openfl.events.Event;

/**
 * ...
 * @author Tamar Curry
 */

class Pool<T:PoolableObject> extends Destroyable implements IPool
{
	private var _createFunc	:Void->T;
	private var _inactive	:Array<T>;
	private var _stowed		:Array<T>;
	
	// -----------------------------------------------------------------------------------------------
	// -----------------------------------------------------------------------------------------------
	public function new(create:Void->T) 
	{
		super();
		_createFunc = create;
		_inactive 	= new Array<T>();
		_stowed 	= new Array<T>();
		setListeners(true);
	}
	
	// -----------------------------------------------------------------------------------------------
	private function setListeners(active:Bool):Void
	{
		Funcs.setListener( Globals.dispatcher, active, GlobalEvent.PROCESS_STOWED, onProcessStowed );
	}
	
	// -----------------------------------------------------------------------------------------------
	private function onProcessStowed(e:Event):Void
	{
		var len:Int = _stowed.length;
		for ( i in 0...len ) {
			_stowed[i].process();
			_inactive.push( _stowed[i] );
		}
		_stowed.splice(0, len);
	}
	
	// -----------------------------------------------------------------------------------------------
	public function get():T 
	{
		var object:T = _inactive.pop();
		
		if ( object == null ) {
			object = _createFunc();
			object.setOwner(this);
			object.setStowFunc(stow);
		}
		
		object.activate();
		return object;
	}
	
	// -----------------------------------------------------------------------------------------------
	private function stow(object:Dynamic):Void
	{
		var obj:T = cast object;
		obj.deactivate();
		_stowed.push( obj );
	}
	
	// -----------------------------------------------------------------------------------------------
	override public function destroy():Void 
	{
		if ( this.isExpired ) { return; }
		setListeners(false);
		super.destroy();
		
		_stowed 	= Funcs.destroy(_stowed);
		_inactive 	= Funcs.destroy(_inactive);
	}
}