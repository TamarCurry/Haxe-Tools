package libs.states;

import haxe.ds.StringMap;
import libs.states.State;
import libs.baseClasses.Destroyable;

/**
 * ...
 * @author Tamar Curry
 */
class StateManager extends Destroyable
{
	
	private var _currentState	:State;
	private var _nextState		:State;
	private var _stateMap		:StringMap<State>;
	
	// -----------------------------------------------------------------------------------------------
	// -----------------------------------------------------------------------------------------------
	public function new() 
	{
		super();
		_stateMap 		= new StringMap<State>();
		_currentState 	= getState(State);
		_nextState 		= null;
	}
	
	// -----------------------------------------------------------------------------------------------
	public function getState(stateClass:Class<State>):State
	{
		var className:String = Type.getClassName( stateClass );
		var state:State = _stateMap.get( className );
		if ( state == null ) {
			state = Type.createInstance( stateClass, [] );
			state.init(this);
			_stateMap.set( className, state );
		}
		return state;
	}
	
	// -----------------------------------------------------------------------------------------------
	public function setNextState(stateClass:Class<State>):Void
	{
		_nextState = getState(stateClass);
	}
	
	// -----------------------------------------------------------------------------------------------
	public function update():Void
	{
		if ( _nextState != null ) {
			_currentState.deactivate();
			_currentState 	= _nextState;
			_nextState 		= null;
			_currentState.activate();
		}
		_currentState.update();
	}
	
	// -----------------------------------------------------------------------------------------------
	override function destroy():Void 
	{
		if ( isExpired ) { return; }
		super.destroy();
		for ( s in _stateMap.keys() ) {
			Funcs.destroy(_stateMap.get(s));
			_stateMap.remove(s);
		}
		_stateMap = null;
	}
}