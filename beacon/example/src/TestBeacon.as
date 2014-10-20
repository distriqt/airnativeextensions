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
	import com.distriqt.extension.beacon.Beacon;
	import com.distriqt.extension.beacon.events.BeaconEvent;
	import com.distriqt.extension.beacon.objects.BeaconObject;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	/**	
	 * Sample application for using the Beacon Native Extension
	 * 
	 * @author	Michael Archbold
	 */
	public class TestBeacon extends Sprite
	{
		public static const DEV_KEY : String = "YOUR_DEVELOPER_KEY";
		
		
		/**
		 * Class constructor 
		 */	
		public function TestBeacon( devKey:String = DEV_KEY )
		{
			super();
			_devKey = devKey;
			create();
			init();
		}
		
		
		//
		//	VARIABLES
		//
		
		private var _devKey		: String;
		
		private var _text		: TextField;
		
		public static const UUID_1	: String = "D57092AC-DFAA-446C-8EF3-C81AA22815B5";
		public static const UUID_2	: String = "D57092AC-DFAA-446C-8EF3-C81AA22815B6";
		
		
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
				Beacon.init( _devKey );
				
				message( "Beacon Supported: "+ String(Beacon.isSupported) );
				message( "Beacon Version: " + Beacon.service.version );
				
				//
				//	Add test inits here
				//
				
				Beacon.service.addEventListener( BeaconEvent.REGION_MONITORING_START, beacon_monitoringStartHandler, false, 0, true );
				Beacon.service.addEventListener( BeaconEvent.REGION_ENTER, beacon_regionEnterHandler, false, 0, true );
				Beacon.service.addEventListener( BeaconEvent.REGION_EXIT, beacon_regionExitHandler, false, 0, true );
				Beacon.service.addEventListener( BeaconEvent.BEACON_UPDATE, beacon_beaconUpdateHandler, false, 0, true );
				
				
			}
			catch (e:Error)
			{
				message( e.message );
			}
		}
		
		
		//
		//	FUNCTIONALITY
		//
		
		private function message( str:String ):void
		{
			trace( str );

			if (_text.numLines > 100) _text.text = "";
			_text.text = str+"\n" + _text.text;
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
			//	When the screen is clicked just toggle the monitoring state
			//	
			toggleRegionMonitoring( UUID_1, "region_1_identifier" );
			toggleRegionMonitoring( UUID_2, "region_2_identifier" );
			
		}
		
		
		private function toggleRegionMonitoring( uuid:String, identifier:String = "" ):void
		{
			if (Beacon.service.isMonitoringRegionWithUUID( uuid ))
				Beacon.service.stopMonitoringRegionWithUUID( uuid, identifier );
			else
				Beacon.service.startMonitoringRegionWithUUID( uuid, identifier );
		}
		
		
		
		//
		//	EXTENSION HANDLERS
		//
		
		
		private function beacon_monitoringStartHandler( event:BeaconEvent ):void
		{
			message( "beacon_monitoringStartHandler(): " + event.region.identifier + "::" + event.region.uuid );
		}
		
		
		private function beacon_regionEnterHandler( event:BeaconEvent ):void
		{
			message( "Entered region: " + event.region.uuid );
		}
		
		
		private function beacon_regionExitHandler( event:BeaconEvent ):void
		{
			message( "Exit region: " + event.region.uuid );
		}
		
		
		private function beacon_beaconUpdateHandler( event:BeaconEvent ):void
		{
			message( "Beacon update for region: "+event.region.uuid );
			for each (var beacon:BeaconObject in event.beacons)
			{
				message( "Beacon: "+beacon.major+"."+beacon.minor +"::"+beacon.proximity +"["+beacon.accuracy +"]");
			}
		}
		
		
	}
}

