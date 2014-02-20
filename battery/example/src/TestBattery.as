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
	import com.distriqt.extension.battery.Battery;
	import com.distriqt.extension.battery.BatteryState;
	import com.distriqt.extension.battery.events.BatteryEvent;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	/**	
	 * Sample application for using the battery Native Extension
	 * 
	 * @author	Michael Archbold
	 */
	public class TestBattery extends Sprite
	{
		public static const DEV_KEY 		: String = "your_dev_key";
		
		/**
		 * Class constructor 
		 */	
		public function TestBattery()
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
				Battery.init( DEV_KEY );
				
				message( "Battery Supported: "+ String(Battery.isSupported) );
				message( "Battery Version: " + Battery.service.version );
				
				Battery.service.addEventListener( BatteryEvent.BATTERY_INFO, battery_infoHandler );
				
				//
				//	Add test inits here
				//
			}
			catch (e:Error)
			{
				trace(e);
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
			
			Battery.service.getBatteryInfo();
		}
		
		
		
		//
		//	BATTERY NOTIFICATION HANDLERS
		//
		
		
		
		private function battery_infoHandler( event:BatteryEvent ):void
		{
			switch( int(event.batteryState) )
			{
				case BatteryState.CHARGING:
					message("Battery state: CHARGING");
					break;
				case BatteryState.FULL:
					message("Battery state: FULL");
					break;
				case BatteryState.NOT_CHARGING:
					message("Battery state: NOT CHARGING");
					break;
				case BatteryState.NOT_SUPPORTED:
					message("Battery state: NOT SUPPORTED");
					break;
				case BatteryState.UNKNOWN:
				default:
					message("Battery state: UNKNOWN");
					break;
			}
			
			message("Battery level: " + event.batteryLevel );
		}

		
	}
}

