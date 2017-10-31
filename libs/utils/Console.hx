package libs.utils;
import haxe.io.Input;

/**
 * ...
 * @author Tamar Curry
 */
class Console
{
	public static function sleep(seconds:Float):Void {
		Sys.sleep(seconds);
	}
	
	public static function clear():Void {
		Sys.command("cls");
	}
	
	public static function print(message:String):Void {
		Sys.print(message);
	}
	
	public static function printLn(message:String):Void {
		Sys.println(message);
	}
	
	public static function getInput(message:String=null):String {
		var input:Input = Sys.stdin();
		if ( message != null )
		{
			Sys.print(message);
		}
		return input.readLine();
	}
}