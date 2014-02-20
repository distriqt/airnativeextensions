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
	import com.distriqt.extension.gyroscope.Gyroscope;
	import com.distriqt.extension.gyroscope.events.GyroscopeEvent;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import away3d.cameras.Camera3D;
	import away3d.containers.View3D;
	import away3d.debug.Trident;
	
	[SWF(backgroundColor="#CCCCCC", frameRate="60")]
	/**	
	 * Sample application for using the Gyroscope Native Extension
	 * 
	 * @author	Michael Archbold
	 */
	public class TestGyroscope extends Sprite
	{
		public static const DEV_KEY : String = "your_dev_key";
		

		/**
		 * Class constructor 
		 */	
		public function TestGyroscope()
		{
			super();
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
		}
		
		
		
		//
		//	VARIABLES
		//
		
		private var _text			: TextField;
		private var _messageTimer	: Timer;
		private var _printMessage	: Boolean = false;
		
		private var _viewport		: View3D;
		private var _trident		: Trident;
		
		
		//
		//	INITIALISATION
		//	

		private function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			init();
		}
		
		private function init():void
		{
			var tf:TextFormat = new TextFormat();
			tf.size = 24;
			_text = new TextField();
			_text.defaultTextFormat = tf;
			addChild( _text );

			
			stage.addEventListener( Event.RESIZE, stage_resizeHandler, false, 0, true );
			stage.addEventListener( MouseEvent.CLICK, mouseClickHandler, false, 0, true );
			
			addEventListener( Event.ACTIVATE, activateHandler, false, 0, true );
			addEventListener( Event.DEACTIVATE, deactivateHandler, false, 0, true );
			
			_messageTimer = new Timer( 500 );
			_messageTimer.addEventListener( TimerEvent.TIMER, messageTimer_timerHandler, false, 0, true );

		
			_viewport = new View3D()
			_viewport.backgroundColor = 0xCCCCCC;
			
			_viewport.camera = new Camera3D();
			_viewport.camera.y = 1000;
			_viewport.camera.z = 0;
			_viewport.camera.x = 0;
			_viewport.camera.lookAt( new Vector3D(0,0,0) );
			
			addChild( _viewport );
			
			_trident = new Trident( 300 );
			_viewport.scene.addChild( _trident );

			
			//
			//	Setup the extension
			try
			{
				Gyroscope.init( DEV_KEY );
				
				message( "Gyroscope Supported: "+ String(Gyroscope.isSupported) );
				message( "Gyroscope Version: " + Gyroscope.service.version );
				
				Gyroscope.service.addEventListener( GyroscopeEvent.UPDATE, gyro_updateHandler );
			}
			catch (e:Error)
			{
				trace(" >> " +e);
			}
			
			//
			//	Start the render loop
			addEventListener( Event.ENTER_FRAME, loop );
		}
		

		
		//
		//	FUNCTIONALITY
		//
		
		private function message( m:String ):void
		{
			trace( m );
			if (_text.numLines > 100) _text.text = "";
			_text.text = m + "\n" + _text.text;
		}
		

		private function printEvent( event:GyroscopeEvent ):String
		{
			return	"Pitch: " + displayNumber(event.pitch) +"\n"
				+	"Roll:  " + displayNumber(event.roll) + "\n"
				+ 	"Yaw:   " + displayNumber(event.yaw) +"\n"
				+ " ("+displayNumber(event.x,3)+","+displayNumber(event.y,3)+","+displayNumber(event.z,3)+")"
				;
		}
		
		
		private function displayNumber( value:Number, decimalPlaces:int = 2 ):String
		{
			return String(Math.floor(value * Math.pow( 10, decimalPlaces )) / Math.pow( 10, decimalPlaces ));
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
			message( "Starting Gyroscope service..." );
			Gyroscope.service.register( Gyroscope.SENSOR_DELAY_GAME );
			_messageTimer.start();
		}
		
		
		private function DEG( radians:Number ):Number 
		{
			return radians * 180 / Math.PI;
		}
		
		
		private function gyro_updateHandler(event:GyroscopeEvent):void
		{
			if (_printMessage)
			{
				_text.text = printEvent(event);
				_printMessage = false;
			}
			
			//
			// Reset to original position then rotate to current position
			var matrix:Matrix3D = new Matrix3D();
			_trident.transform = matrix;
			
			matrix.appendRotation( (-1) * DEG(event.yaw), 		_trident.upVector );
			matrix.appendRotation( (-1) * DEG(event.pitch), 	_trident.rightVector );
			matrix.appendRotation( DEG(event.roll), 			_trident.forwardVector );
			_trident.transform = matrix; 
			
		}
		
		
		private function activateHandler( event:Event ):void
		{
			message( "Click screen to start gyroscope activity" );
		}
		
		
		private function deactivateHandler( event:Event ):void
		{
			Gyroscope.service.unregister();
			message( "Stopping Gyroscope service due to deactivation." );
			_messageTimer.stop();
		}

		
		private function messageTimer_timerHandler( event:TimerEvent ):void
		{
			_printMessage = true;
		}
		
		
		private function loop( event:Event ):void
		{
			_viewport.render();
		}
		
		
	}
}

