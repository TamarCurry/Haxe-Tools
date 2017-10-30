package libs.utils;

/**
 * ...
 * @author Tamar Curry
 */
lass RandomSequence 
{
	// PRIMITIVES
	private var _len		:Int;
	private var _index		:Int;
	
	// NULLABLES
	private var _sequence	:Array<Float>;
	
	// ---------------------------------------------------------------------------
	// METHODS
	// ---------------------------------------------------------------------------
	public function RandomSequence(num:Int) 
	{
		_sequence = new Array<Float>();
		
		for ( i in 0...num ) {
			_sequence.push( i / num );
		}
		_index = 0;
		_len = num;
		_sequence.sort( randSort );
	}
	
	// ---------------------------------------------------------------------------
	private function randSort(a:Float, b:Float):Float
	{
		if ( Math.random() < 0.5 ) { return -1; }
		return 1;
	}
	
	// ---------------------------------------------------------------------------
	public function next():Float
	{
		var n:Float = _sequence[_index];
		++_index;
		if ( _index >= _len ) {
			_index = 0;
		}
		return n;
	}
}

