/**
 *        __       __               __ 
 *   ____/ /_ ____/ /______ _ ___  / /_
 *  / __  / / ___/ __/ ___/ / __ `/ __/
 * / /_/ / (__  ) / / /  / / /_/ / / 
 * \__,_/_/____/_/ /_/  /_/\__, /_/ 
 *                           / / 
 *                           \/ 
 * http://distriqt.com
 *
 * This is a test application for the distriqt extension
 * 
 * @author Michael Archbold & Shane Korin
 * 	
 */
package
{
	import com.distriqt.extension.vibration.Vibration;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	
	/**	
	 * Sample application for using the Vibration Native Extension
	 * 
	 * @author	Michael Archbold
	 */
	public class TestVibration extends Sprite
	{
		public static const DEV_KEY : String = "your_dev_key";
		
		
		/**
		 * Class constructor 
		 */	
		public function TestVibration()
		{
			super();
			create();
			init();
		}
		
		
		//
		//	VARIABLES
		//
		
		private var _text		: TextField;
		
		
		//
		//	INITIALISATION
		//	
		
		private function create( ):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			

			var tf:TextFormat = new TextFormat();
			tf.size = 24;
			_text = new TextField();
			_text.defaultTextFormat = tf;
			addChild( _text );

			stage.addEventListener( Event.RESIZE, stage_resizeHandler, false, 0, true );
			stage.addEventListener( MouseEvent.CLICK, mouseClickHandler, false, 0, true );
		}
		
		
		private function init( ):void
		{
			try
			{
				Vibration.init( DEV_KEY );
				
				message( "Vibration Supported: "+ String(Vibration.isSupported) );
				message( "Vibration Version: " + Vibration.service.version );
				
				//
				//	Add test inits here
				//
			}
			catch (e:Error)
			{
				message(e.message);
			}
		}
		
		
		//
		//	FUNCTIONALITY
		//
		
		private function message( str:String ):void
		{
			trace( str );
			_text.appendText(str+"\n");
		}
		
		
		//
		//	EVENT HANDLERS
		//
		
		private function stage_resizeHandler( event:Event ):void
		{
			_text.width  = stage.stageWidth;
			_text.height = stage.stageHeight - 100;
		}
		
		
		private function mouseClickHandler( event:MouseEvent ):void
		{
			//
			//	Do something when user clicks screen?
			//	
			try
			{
				message("Sending vibrate command...");
				
				// Example: Vibrate for duration
//				Vibration.service.vibrate( 1000 );
				
				// Example: Vibrate with pattern, continuously (until cancel is called)
				Vibration.service.vibrate( 0, [0, 200, 500, 200, 500], 0 );
				
				cancelVibrationsInterval = setInterval( cancelVibrations, 5000 );
			}
			catch (e:Error)
			{
				message(e.message);
			}
		}
		
		private var cancelVibrationsInterval : int;
		
		private function cancelVibrations():void
		{
			message( "cancelling" );
			clearInterval( cancelVibrationsInterval );
			Vibration.service.cancel();
		}
		
	}
}

