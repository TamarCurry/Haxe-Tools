package libs.utils;

import libs.display.GameSprite;

/**
 * ...
 * @author Tamar Curry
 */
class Board<T:Slot> extends GameSprite
{
	private var _slots:Array<T>;
	
	// -----------------------------------------------------------------------------------------------
	public var boardWidth(default, null):Float;
	public var boardHeight(default, null):Float;
	public var slotWidth(default, null):Float;
	public var slotHeight(default, null):Float;
	public var numCols(default, null):Int;
	public var numRows(default, null):Int;
	
	// -----------------------------------------------------------------------------------------------
	// -----------------------------------------------------------------------------------------------
	public function new(slotWidth:Float, slotHeight:Float, numCols:Int, numRows:Int) 
	{
		super();
		_slots = new Array<T>();
		this.numCols = numCols;
		this.numRows = numRows;
		
		this.boardWidth = slotWidth * numCols;
		this.boardHeight = slotHeight * numRows;
		
		this.slotWidth = slotWidth;
		this.slotHeight = slotHeight;
		for ( i in 0...(numCols * numRows) ) {
			_slots.push( makeSlot(i % numCols, Std.int(i / numCols) ) );
		}
		
		var s:T;
		for ( i in 0..._slots.length ) {
			s = _slots[i];
			s.addNeighbor( getSlot( s.col - 1, s.row ) );
			s.addNeighbor( getSlot( s.col + 1, s.row ) );
			s.addNeighbor( getSlot( s.col, s.row - 1) );
			s.addNeighbor( getSlot( s.col, s.row + 1) );
			
			s.addNeighbor( getSlot( s.col - 1, s.row - 1 ) );
			s.addNeighbor( getSlot( s.col - 1, s.row + 1) );
			s.addNeighbor( getSlot( s.col + 1, s.row - 1 ) );
			s.addNeighbor( getSlot( s.col + 1, s.row + 1 ) );
		}
	}
	
	// -----------------------------------------------------------------------------------------------
	private function drawBackground(padding:Float, color:Int):Void
	{
		this.graphics.clear();
		this.graphics.beginFill(color);
		this.graphics.drawRoundRect( -padding, -padding, boardWidth + padding + padding, boardHeight + padding + padding, 8, 8);
		this.graphics.endFill();
	}
	
	// -----------------------------------------------------------------------------------------------
	private function makeSlot(col:Int, row:Int):T {
		throw "Override makeSlot function";
	}
	
	// -----------------------------------------------------------------------------------------------
	public function getSlot(col:Int, row:Int):T {
		if ( col >= 0 && col < numCols && row >= 0 && row < numRows ) {
			return _slots[ (row * numCols) + col ];
		}
		return null;
	}
	
	// -----------------------------------------------------------------------------------------------
	public function getSlotAt(index:Int):T {
		if ( index >= 0 && index < _slots.length ) {
			return _slots[index];
		}
		return null;
	}
	
	// -----------------------------------------------------------------------------------------------
	public function getIndex(xPos:Float, yPos:Float):Int {
		if ( xPos >= 0 && xPos < boardWidth && yPos >= 0 && yPos < boardHeight ) {
			return (Std.int(yPos / slotHeight) * numCols) + Std.int(xPos / slotWidth);
		}
		return -1;
	}
	
	// -----------------------------------------------------------------------------------------------
	public function getSlotUnderPoint(xPos:Float, yPos:Float):T {
		var i:Int = getIndex(xPos, yPos);
		return i > -1 ? _slots[i] : null;
	}
	
	// -----------------------------------------------------------------------------------------------
	override function cleanupVars():Void 
	{
		_slots = Funcs.destroy(_slots);
	}
}