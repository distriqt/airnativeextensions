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
 * @file   		TestCompass.as
 * @brief  		
 * @author 		Michael Archbold (ma@distriqt.com)
 * @created		Jan 19, 2012
 * @updated		$Date:$
 * @copyright	http://distriqt.com/copyright/license.txt
 */
package
{
	import com.distriqt.extension.compass.Compass;
	import com.distriqt.extension.compass.events.CompassEvent;
	import com.distriqt.extension.compass.events.MagneticFieldEvent;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	/**	
	 * Sample application for using the Compass Native Extension
	 * 
	 * @author	Michael Archbold (ma@distriqt.com)
	 */
	public class TestCompass extends Sprite
	{
		public static const DEV_KEY : String = "YOUR_DEVELOPER_KEY";	
		
		/**
		 *  Constructor
		 */
		public function TestCompass()
		{
			super();
			create();
			message( "TestCompass" );
			
			try
			{
				Compass.init( DEV_KEY );
				
				message( "Compass.isSupported: "+Compass.isSupported );
				message( "Compass.version: "+Compass.service.version );
				
				Compass.service.addEventListener( CompassEvent.HEADING_UPDATED, compass_headingUpdatedHandler, false, 0, true );
				Compass.service.addEventListener( CompassEvent.HEADING_RAW_UPDATED, compass_headingRawUpdatedHandler, false, 0, true );
				
				Compass.service.addEventListener( MagneticFieldEvent.MAGNETIC_FIELD_AVAILABLE, 		compass_magneticFieldAvailableHandler, 		false, 0, true );
				Compass.service.addEventListener( MagneticFieldEvent.MAGNETIC_FIELD_UNAVAILABLE, 	compass_magneticFieldUnavailableHandler, 	false, 0, true );
				Compass.service.addEventListener( MagneticFieldEvent.MAGNETIC_FIELD_UPDATED, 		compass_magneticFieldUpdatedHandler, 		false, 0, true );
				
			}
			catch (e:Error)
			{
				message( "ERROR:"+e.message );
			}

			addEventListener( Event.ACTIVATE, activateHandler, false, 0, true );
			addEventListener( Event.DEACTIVATE, deactivateHandler, false, 0, true );
		}
		
		
		////////////////////////////////////////////////////////
		//	VARIABLES
		//
		
		private var _registered	: Boolean = false;
		private var _text		: TextField;

		private var _heading	: TextField;
		private var _headingRaw	: TextField;
		private var _magnetic	: TextField;
		
		
		////////////////////////////////////////////////////////
		//	FUNCTIONALITY
		//
		
		
		////////////////////////////////////////////////////////
		//	INTERNALS
		//
		
		private function create():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var tf:TextFormat = new TextFormat();
			tf.size = 24;
			_text = new TextField();
			_text.defaultTextFormat = tf;
			addChild( _text );
			
			tf.color = 0x00FF00;
			tf.size = 36;
			_heading = new TextField();
			_heading.defaultTextFormat = tf;
			addChild( _heading );
			
			_headingRaw = new TextField();
			_headingRaw.defaultTextFormat = tf;
			addChild( _headingRaw );
			
			_magnetic = new TextField();
			tf.size = 24;
			_magnetic.defaultTextFormat = tf;
			addChild( _magnetic );
			
			stage.addEventListener( Event.RESIZE, stage_resizeHandler, false, 0, true );
			stage.addEventListener( MouseEvent.CLICK, mouseClickHandler, false, 0, true );
			
		}
		
		private function message( str:String ):void
		{
			trace( str );
//			_text.appendText(str+"\n");
			_text.text = str + "\n" + _text.text;
		}
		
		
		////////////////////////////////////////////////////////
		//	EVENT HANDLERS
		//
		
		private function stage_resizeHandler( event:Event ):void
		{
			_text.width  = stage.stageWidth;
			_text.height = stage.stageHeight - 150;
			
			_heading.y = 400;//stage.stageHeight - 85;
			_heading.width = stage.stageWidth;
			_heading.height = 50;
			
			_headingRaw.y = 400 - 50;//stage.stageHeight - 85 - 50;
			_headingRaw.width = stage.stageWidth;
			_headingRaw.height = 50;
			
			_magnetic.y = 400 - 50 - 120;//stage.stageHeight - 85 - 50 - 80;
			_magnetic.width = stage.stageWidth;
			_magnetic.height = 120;
		}
		
		
		private function mouseClickHandler( event:MouseEvent ):void
		{
			register(!_registered) 	
		}
		
		
		private function register( reg:Boolean ):void
		{
			try
			{
				if (Compass.isSupported)
				{
					if (reg && !_registered)
					{
						message("registering" );
						Compass.service.register( Compass.SENSOR_DELAY_NORMAL, 0.4 );
					}
					
					if (!reg && _registered)
					{
						message("unregistering");
						Compass.service.unregister();
					}
					_registered = reg;
				}
				else
				{
					message("not supported");
				}
			}
			catch (e:Error)
			{
				message( "ERROR:"+e.message );
			}
		}
		
		
		private function compass_headingUpdatedHandler( event:CompassEvent ):void
		{
//			message( event.type +":"+ event.magneticHeading+":"+ event.trueHeading+":"+ event.headingAccuracy );
			_heading.text = String(event.magneticHeading) +"   ["+event.headingAccuracy+"]";
		}
		
		
		private function compass_headingRawUpdatedHandler( event:CompassEvent ):void
		{
//			message( event.type +":"+ event.magneticHeading+":"+ event.trueHeading+":"+ event.headingAccuracy );
			_headingRaw.text = String(event.magneticHeading) +"   ["+event.headingAccuracy+"]";
		}
		
		
		private function activateHandler( event:Event ):void
		{
			register(true) 	
		}
		
		
		private function deactivateHandler( event:Event ):void
		{
			register(false) 	
		}

		
		private function compass_magneticFieldUpdatedHandler( event:MagneticFieldEvent ):void
		{
			_magnetic.text = "x:"+ event.fieldX + "\ny:"+event.fieldY  +"\nz:"+ event.fieldZ ;
		}
		
		
		private function compass_magneticFieldAvailableHandler( event:MagneticFieldEvent ):void
		{
			message( "magnetic field available" );
		}
		
		
		private function compass_magneticFieldUnavailableHandler( event:MagneticFieldEvent ):void
		{
			message( "magnetic field unavailable" );
		}
		
	}
}