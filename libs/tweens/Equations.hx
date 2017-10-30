package libs.tweens;

/**
 * Tweening equations.
 * @author Tamar Curry
 */
class Equations 
{
	
	
	// -----------------------------------------------------------------------------------------------
	// Formulas taken from the feffects easing classes for HaXE: 
	// https://code.google.com/p/feffects/
	// Parameters are as follows:
	// * t: current time
	// * b: starting value
	// * c: change in the starting value over time
	// * d: duration of the transform
	// -----------------------------------------------------------------------------------------------
	public static function linear(t:Float, b:Float, c:Float, d:Float):Float {
		return c * t / d + b;
	}
	
	// -----------------------------------------------------------------------------------------------
	public static function backEaseIn(t:Float, b:Float, c:Float, d:Float):Float {
		return c * ( t /= d ) * t * ( ( 1.70158 + 1 ) * t - 1.70158 ) + b;
	}
	
	// -----------------------------------------------------------------------------------------------
	public static function backEaseOut(t:Float, b:Float, c:Float, d:Float):Float {
		return c * ( ( t = t / d - 1 ) * t * ( ( 1.70158 + 1 ) * t + 1.70158 ) + 1 ) + b;
	}
	
	// -----------------------------------------------------------------------------------------------
	public static function backEaseInOut(t:Float, b:Float, c:Float, d:Float):Float {
		var s:Float = 1.70158; 
		if ( ( t /= d * 0.5 ) < 1 ){
			return c * 0.5 * ( t * t * ( ( ( s *= ( 1.525 ) ) + 1 ) * t - s ) ) + b;
		}
		else {
			return c * 0.5 * ( ( t -= 2 ) * t * ( ( ( s *= ( 1.525 ) ) + 1 ) * t + s ) + 2 ) + b;
		}
	}
	
	// -----------------------------------------------------------------------------------------------
	public static function bounceEaseOut ( t : Float, b : Float, c : Float, d : Float ) : Float {
		if ( ( t /= d ) < ( 1 / 2.75 ) ) {
			return c * ( 7.5625 * t * t ) + b;
		}
		else if ( t < ( 2 / 2.75 ) ) {
			return c * ( 7.5625 * ( t -= ( 1.5 / 2.75 ) ) * t + .75 ) + b;
		}
		else if ( t < ( 2.5 / 2.75 ) ) {
			return c * ( 7.5625 * ( t -= ( 2.25 / 2.75 ) ) * t + .9375 ) + b;
		}
		else {
			return c * ( 7.5625 * ( t -= ( 2.625 / 2.75 ) ) * t + .984375 ) + b;
		}
	}
	
	// -----------------------------------------------------------------------------------------------
	public static function bounceEaseIn ( t : Float, b : Float, c : Float, d : Float ) : Float {
		return c - bounceEaseOut ( d - t, 0, c, d ) + b;
	}
	
	// -----------------------------------------------------------------------------------------------
	public static function bounceEaseInOut ( t : Float, b : Float, c : Float, d : Float ) : Float {
		if ( t < d * 0.5 ) {
			return bounceEaseIn ( t * 2, 0, c, d ) * .5 + b;
		}
		else {
			return bounceEaseOut ( t * 2 - d, 0, c, d ) * .5 + c * .5 + b;
		}
	}
	
	// -----------------------------------------------------------------------------------------------
	public static function circEaseIn ( t : Float, b : Float, c : Float, d : Float ) : Float {
		return -c * ( Math.sqrt( 1 - ( t /= d ) * t ) - 1 ) + b;
	}
	
	// -----------------------------------------------------------------------------------------------
	public static function circEaseOut ( t : Float, b : Float, c : Float, d : Float ) : Float {
		return c * Math.sqrt( 1 - ( t = t / d - 1 ) * t ) + b;
	}
	
	// -----------------------------------------------------------------------------------------------
	public static function circEaseInOut ( t : Float, b : Float, c : Float, d : Float ) : Float {
		if ( ( t /= d * 0.5 ) < 1 ) {
			return -c * 0.5 * ( Math.sqrt( 1 - t * t ) - 1 ) + b;
		}
		else {
			return c * 0.5 * ( Math.sqrt( 1 - ( t -= 2 ) * t ) + 1 ) + b;
		}
	}
	
	// -----------------------------------------------------------------------------------------------
	public static function cubicEaseIn ( t : Float, b : Float, c : Float, d : Float ) : Float {
		return c * ( t /= d ) * t * t + b;
	}
	
	// -----------------------------------------------------------------------------------------------
	public static function cubicEaseOut ( t : Float, b : Float, c : Float, d : Float ) : Float {
		return c * ( ( t = t / d - 1 ) * t * t + 1 ) + b;
	}
	
	// -----------------------------------------------------------------------------------------------
	public static function cubicEaseInOut ( t : Float, b : Float, c : Float, d : Float ) : Float {
		if ( ( t /= d * 0.5 ) < 1 ) {
			return c * 0.5 * t * t * t + b;
		}
		else {
			return c * 0.5 * ( ( t -= 2 ) * t * t + 2 ) + b;
		}
	}
	
	// -----------------------------------------------------------------------------------------------
	public static function elasticEaseIn ( t : Float, b : Float, c : Float, d : Float ) : Float {
		if ( t == 0 ) {
			return b;
		} if ( ( t /= d ) == 1 ) {
			return b + c;
		} else {
			var p:Float = d * .3;
			var s:Float = p * 0.25;
			return -( c * Math.pow( 2, 10 * ( t -= 1 ) ) * Math.sin( ( t * d - s ) * ( 2 * Math.PI ) / p ) ) + b;
		}
	}
	
	// -----------------------------------------------------------------------------------------------
	public static function elasticEaseOut ( t : Float, b : Float, c : Float, d : Float ) : Float {
		if ( t == 0 ) {
			return b;
		} else if ( ( t /= d ) == 1 ) {
			return b + c;
		} else {
			var p:Float = d * .3;
			var	s:Float = p * 0.25;
			return ( c * Math.pow( 2, -10 * t ) * Math.sin( ( t * d - s ) * ( 2 * Math.PI ) / p ) + c + b );
		}
	}
	
	// -----------------------------------------------------------------------------------------------
	public static function elasticEaseInOut ( t : Float, b : Float, c : Float, d : Float ) : Float	{
		if ( t == 0 ){
			return b;
		} else if ( ( t /= d / 2 ) == 2 ) {
			return b + c;
		} else {
			var p:Float = d * ( .3 * 1.5 );
			var	s:Float = p * 0.25;
			if ( t < 1 )
				return -.5 * ( c * Math.pow( 2, 10 * ( t -= 1 ) ) * Math.sin( ( t * d - s ) * ( 2 * Math.PI ) / p ) ) + b;
			else
				return c * Math.pow( 2, -10 * ( t -= 1 ) ) * Math.sin( ( t * d - s ) * ( 2 * Math.PI ) / p ) * .5 + c + b;
		}
	}
	
	// -----------------------------------------------------------------------------------------------
	public static function expoEaseIn ( t : Float, b : Float, c : Float, d : Float ) : Float {
		return ( t == 0 ) ? b : c * Math.pow( 2, 10 * ( t / d - 1 ) ) + b;
	}
	
	// -----------------------------------------------------------------------------------------------
	public static function expoEaseOut ( t : Float, b : Float, c : Float, d : Float ) : Float {
		return ( t == d ) ? b + c : c * ( -Math.pow( 2, -10 * t / d ) + 1 ) + b;
	}
	
	// -----------------------------------------------------------------------------------------------
	public static function expoEaseInOut ( t : Float, b : Float, c : Float, d : Float) : Float {
		if ( t == 0 ) {
			return b;
		}
		else if ( t == d ) {
			return b + c;
		}
		else if ( ( t /= d / 2 ) < 1 ) {
			return c * 0.5 * Math.pow( 2, 10 * ( t - 1 ) ) + b;
		}
		else {
			return c * 0.5 * ( -Math.pow( 2, -10 * --t ) + 2 ) + b;
		}
	}
	
	// -----------------------------------------------------------------------------------------------
	public static function quadEaseIn ( t : Float, b : Float, c : Float, d : Float ) : Float {
		return c * ( t /= d ) * t + b;
	}
	
	// -----------------------------------------------------------------------------------------------
	public static function quadEaseOut ( t : Float, b : Float, c : Float, d : Float ) : Float {
		return -c * ( t /= d ) * ( t - 2 ) + b;
	}
	
	// -----------------------------------------------------------------------------------------------
	public static function quadEaseInOut ( t : Float, b : Float, c : Float, d : Float ) : Float {
		if ( ( t /= d * 0.5 ) < 1 ) {
			return c * 0.5 * t * t + b;
		}
		else {
			return -c * 0.5 * ( ( --t ) * ( t - 2 ) - 1 ) + b;
		}
	}
	
	// -----------------------------------------------------------------------------------------------
	public static function quartEaseIn ( t : Float, b : Float, c : Float, d : Float ) : Float {
		return c * ( t /= d ) * t * t * t + b;
	}
	
	// -----------------------------------------------------------------------------------------------
	public static function quartEaseOut ( t : Float, b : Float, c : Float, d : Float ) : Float {
		return -c * ( ( t = t / d - 1 ) * t * t * t - 1 ) + b;
	}
	
	// -----------------------------------------------------------------------------------------------
	public static function quartEaseInOut ( t : Float, b : Float, c : Float, d : Float ) : Float {
		if ( ( t /= d * 0.5 ) < 1 ) {
			return c * 0.5 * t * t * t * t + b;
		}
		else {
			return -c * 0.5 * ( ( t -= 2 ) * t * t * t - 2) + b;
		}
	}
	
	// -----------------------------------------------------------------------------------------------
	public static function quintEaseIn ( t : Float, b : Float, c : Float, d : Float ) : Float {
		return c * ( t /= d ) * t * t * t * t + b;
	}
	
	// -----------------------------------------------------------------------------------------------
	public static function quintEaseOut ( t : Float, b : Float, c : Float, d : Float ) : Float {
		return c * ( ( t = t / d - 1 ) * t * t * t * t + 1 ) + b;
	}
	
	// -----------------------------------------------------------------------------------------------
	public static function quintEaseInOut ( t : Float, b : Float, c : Float, d : Float ) : Float {
		if ( ( t /= d * 0.5 ) < 1 ) {
			return c * 0.5 * t * t * t * t * t + b;
		}
		else {
			return c * 0.5 * ( ( t -= 2 ) * t * t * t * t + 2 ) + b;
		}
	}
	
	// -----------------------------------------------------------------------------------------------
	public static function sineEaseIn ( t : Float, b : Float, c : Float, d : Float ) : Float {
		return -c * Math.cos ( t / d * ( Math.PI * 0.5 ) ) + c + b;
	}
	
	// -----------------------------------------------------------------------------------------------
	public static function sineEaseOut ( t : Float, b : Float, c : Float, d : Float ) : Float {
		return c * Math.sin( t / d * ( Math.PI * 0.5 ) ) + b;
	}
	
	// -----------------------------------------------------------------------------------------------
	public static function sineEaseInOut ( t : Float, b : Float, c : Float, d : Float ) : Float {
		return -c * 0.5 * ( Math.cos( Math.PI * t / d ) - 1 ) + b;
	}
}