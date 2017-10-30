package libs.queue;

import libs.pool.PoolableObject;
import libs.utils.BoolCallback;
import libs.utils.Callback;

/**
 * ...
 * @author Tamar Curry
 */
class QueuedAction extends PoolableObject
{
	public var isFinished(default, null):Bool;
	
	public function new() 
	{
		super();
	}
	
	public function execute():Void
	{
		
	}
	
	override function onProcess():Void 
	{
		isFinished = false;
	}
	
}