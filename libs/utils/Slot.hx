package libs.utils;
import libs.baseClasses.Destroyable;

/**
 * ...
 * @author Tamar Curry
 */
class Slot extends Destroyable
{
	public static inline var NORTH	:Int = 1;
	public static inline var SOUTH	:Int = 2;
	public static inline var EAST	:Int = 4;
	public static inline var WEST	:Int = 8;
	
	private var _size		:Float;
	private var _neighbors	:Map<Int, Slot>;
	
	public var x(default, null):Float;
	public var y(default, null):Float;
	public var col(default, null):Int;
	public var row(default, null):Int;
	
	public function new(col:Int, row:Int, size:Float) 
	{
		super();
		this.col = col;
		this.row = row;
		_size = size;
		x = col * size;
		y = row * size;
		
		_neighbors = new Map<Int, Slot>();
	}
	
	public function addNeighbor(slot:Slot):Void
	{
		if ( slot == null ) { return; }
		
		var dir:Int = 0;
		
		if ( slot.row - this.row == 1 ) { dir |= SOUTH; }
		else if ( slot.row - this.row == -1 ) { dir |= NORTH; }
		
		if ( slot.col - this.col == 1 ) { dir |= EAST; }
		else if ( slot.col - this.col == -1 ) { dir |= WEST; }
		
		if ( dir > 0 ) {
			_neighbors.set( dir, slot );
		}
	}
}