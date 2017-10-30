package libs.pool;

import libs.baseClasses.Destroyable;

/**
 * ...
 * @author Tamar Curry
 */

class PoolableObject extends Destroyable
{
	private var _owner		:IPool;
	private var _stowFunc	:Dynamic->Void;
	
	// -----------------------------------------------------------------------------------------------
	// -----------------------------------------------------------------------------------------------
	public var active(default, null):Bool;
	
	// -----------------------------------------------------------------------------------------------
	// -----------------------------------------------------------------------------------------------
	public function new() 
	{
		super();
		_stowFunc = defaultStow;
	}
	
	// -----------------------------------------------------------------------------------------------
	private static function defaultStow(target:Dynamic):Void { }
	
	// -----------------------------------------------------------------------------------------------
	@:allow(libs.pool.IPool)
	private function setOwner(owner:IPool):Void
	{
		_owner = owner;
	}
	
	// -----------------------------------------------------------------------------------------------
	@:allow(libs.pool.IPool)
	private function setStowFunc(func:Dynamic->Void):Void
	{
		_stowFunc = func;
		if ( _stowFunc == null ) { _stowFunc = defaultStow; }
	}
	
	// -----------------------------------------------------------------------------------------------
	@:allow(libs.pool.IPool)
	private function activate():Void
	{
		if ( active ) { return; }
		active = true;
		onActivate();
	}
	
	// -----------------------------------------------------------------------------------------------
	@:allow(libs.pool.IPool)
	private function deactivate():Void
	{
		if ( !active ) { return; }
		active = false;
		_stowFunc(this);
		onDeactivate();
	}
	
	// -----------------------------------------------------------------------------------------------
	@:allow(libs.pool.IPool)
	private function process():Void
	{
		onProcess();
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
	private function onProcess():Void
	{
		
	}
	
	// -----------------------------------------------------------------------------------------------
	private function onDestroy():Void
	{
		
	}
	
	// -----------------------------------------------------------------------------------------------
	override public function destroy():Void 
	{
		if ( this.isExpired || !this.active ) { return; }
		
		if ( active ) {
			deactivate();
		}
		
		if ( _owner != null && !_owner.isExpired) {
			return;
		}
		
		super.destroy();
		
		_owner 		= null;
		_stowFunc 	= null;
		
		onDestroy();
	}
}