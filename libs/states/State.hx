package libs.states;

import libs.baseClasses.Destroyable;
import libs.states.StateManager;

/**
 * ...
 * @author Tamar Curry
 */
class State extends Destroyable
{
	private var _active			:Bool;
	private var _initialized	:Bool;
	private var _stateManager	:StateManager;
	
	// -----------------------------------------------------------------------------------------------
	// -----------------------------------------------------------------------------------------------
	public function new() 
	{
		super();
		
	}
	
	// -----------------------------------------------------------------------------------------------
	public function init(manager:StateManager):Void
	{
		if ( _initialized ) { return; }
		_stateManager = manager;
		_initialized = true;
		onInit();
	}
	
	// -----------------------------------------------------------------------------------------------
	public function activate():Void
	{
		if ( _active ) { return; }
		_active = true;
		onActivate();
	}
	
	// -----------------------------------------------------------------------------------------------
	public function deactivate():Void
	{
		if ( !_active ) { return; }
		_active = false;
		onDeactivate();
	}
	
	// -----------------------------------------------------------------------------------------------
	public function update():Void
	{
		if ( !_active ) { return; }
		onUpdate();
	}
	
	// -----------------------------------------------------------------------------------------------
	private function onInit():Void
	{
		
	}
	
	// -----------------------------------------------------------------------------------------------
	private function onUpdate():Void
	{
		
	}
	
	// -----------------------------------------------------------------------------------------------
	private function onActivate():Void
	{
		
	}
	
	// -----------------------------------------------------------------------------------------------
	private function onDeactivate():Void
	{
		
	}
	
	// -----------------------------------------------------------------------------------------------
	private function setNextState(stateClass:Class<State>):Void
	{
		_stateManager.setNextState(stateClass);
	}
	
	// -----------------------------------------------------------------------------------------------
	override function destroy():Void 
	{
		if ( isExpired ) { return; }
		super.destroy();
		deactivate();
		_stateManager = null;
	}
}