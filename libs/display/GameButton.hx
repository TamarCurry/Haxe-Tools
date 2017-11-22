package libs.display;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;

/**
 * ...
 * @author Tamar Curry
 */
class GameButton extends GameSprite
{
	private var _btnWidth:Int;
	private var _btnHeight:Int;
	private var _btnColor:Int;
	private var _isEnabled:Bool;
	
	private var _holder:Sprite;
	private var _shape:Shape;
	
	public var tf(default, null):TextField;
	public var isEnabled(get, set):Bool;
	
	private function get_isEnabled():Bool { return _isEnabled; }
	private function set_isEnabled(v:Bool):Bool {
		if ( _isEnabled != v ) {
			_isEnabled = v;
			if ( _isEnabled ) { Funcs.untint(this); }
			else { Funcs.tint(this, 0x999999, 0.7); resetScale(); }
			this.buttonMode = _isEnabled;
		}
		return _isEnabled;
	}
	
	public function new() 
	{
		super();
		tf = new TextField();
		_shape = new Shape();
		_holder = new Sprite();
		
		tf.selectable = false;
		tf.mouseEnabled = false;
		tf.mouseWheelEnabled = false;
		tf.multiline = true;
		
		_btnWidth = 0;
		_btnHeight = 0;
		_btnColor = 0;
		
		setButton("", 100, 60, 0xcccccc );
		
		addChild(_holder);
		_holder.addChild(_shape);
		_holder.addChild(tf);
		
		this.mouseChildren = false;
		isEnabled = true;
		setListeners(true);
	}
	
	private function setListeners(active:Bool):Void
	{
		Funcs.setListener( this, active, MouseEvent.MOUSE_DOWN, onMouseEvent );
		Funcs.setListener( this, active, MouseEvent.MOUSE_UP, onMouseEvent );
		Funcs.setListener( this, active, MouseEvent.MOUSE_OUT, onMouseEvent );
		Funcs.setListener( this, active, MouseEvent.CLICK, onMouseEvent, false, 1000000 );
	}
	
	private function onMouseEvent(e:MouseEvent):Void
	{
		switch(e.type)
		{
			case MouseEvent.MOUSE_DOWN:
				if ( _isEnabled ) { scaleDown(); }
			case MouseEvent.MOUSE_UP, MouseEvent.MOUSE_OUT:
				resetScale();
			case MouseEvent.CLICK:
				if ( !_isEnabled ) {
					e.stopPropagation();
					e.stopImmediatePropagation();
				}
		}
	}
	
	private function resetScale():Void
	{
		_holder.scaleX = 1;
		_holder.scaleY = 1;
	}
	
	private function scaleDown():Void
	{
		_holder.scaleX = 0.9;
		_holder.scaleY = 0.9;
	}
	
	public function setButton(text:String, ?buttonWidth:Int, ?buttonHeight:Int, ?buttonColor:Int, isHtml:Bool=false):Void
	{
		tf.text = "";
		tf.autoSize = TextFieldAutoSize.NONE;
		tf.width = 1;
		tf.height = 1;
		if ( isHtml ) {
			tf.htmlText = text;
		}
		else {
			tf.text = text;
		}
		
		tf.autoSize = TextFieldAutoSize.LEFT;
		
		tf.x = -tf.width / 2;
		tf.y = -tf.height / 2;
		
		drawButton(buttonWidth, buttonHeight, buttonColor);
	}
	
	private function drawButton(buttonWidth:Null<Int>, buttonHeight:Null<Int>, buttonColor:Null<Int>):Void
	{
		var redraw:Bool = false;
		if ( buttonWidth != null && _btnWidth != buttonWidth ) {
			_btnWidth = buttonWidth;
			redraw = true;
		}
		
		if ( buttonHeight != null && _btnHeight != buttonHeight ) {
			_btnHeight = buttonHeight;
			redraw = true;
		}
		
		if ( buttonColor != null && _btnColor != buttonColor ) {
			_btnColor = buttonColor;
			redraw = true;
		}
		
		if ( redraw ) {
			_shape.graphics.clear();
			_shape.graphics.lineStyle(2);
			_shape.graphics.beginFill( _btnColor );
			_shape.graphics.drawRoundRect( 0, 0, _btnWidth, _btnHeight, 8, 8 );
			_shape.graphics.endFill();
			
			_shape.x = -_btnWidth / 2;
			_shape.y = -_btnHeight / 2;
			_holder.x = _btnWidth / 2;
			_holder.y = _btnHeight / 2;
		}
	}
	
	override public function destroy():Void 
	{
		if ( this.isExpired ) { return; }
		setListeners(false);
		super.destroy();
	}
	
}