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
	import com.distriqt.extension.devicemotion.DeviceMotion;
	import com.distriqt.extension.devicemotion.DeviceMotionOptions;
	import com.distriqt.extension.devicemotion.SensorRate;
	import com.distriqt.extension.devicemotion.events.DeviceMotionEvent;
	
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
	import flash.utils.setTimeout;
	
	import away3d.cameras.Camera3D;
	import away3d.containers.View3D;
	import away3d.core.math.Quaternion;
	import away3d.debug.Trident;
	
	[SWF(backgroundColor="#CCCCCC", frameRate="60")]
	/**	
	 * Sample application for using the DeviceMotion Native Extension
	 * 
	 * This example presents a trident in 3D space representing the 
	 * orientation axis, north etc, using both euler angles and quaternions. 
	 * 
	 * 
	 * @author	Michael Archbold
	 */
	public class TestDeviceMotion extends Sprite
	{
		public static const DEV_KEY : String = "YOUR_DEVELOPER_KEY";	
		
		
		/**
		 * Class constructor 
		 */	
		public function TestDeviceMotion( devKey:String=DEV_KEY )
		{
			super();
			_devKey = devKey;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
		}
		
		
		
		//
		//	VARIABLES
		//
		private var _devKey			: String;
		
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
			setTimeout( init, 500 );
		}
		
		private function init():void
		{
			//
			//	Setup the view to show orientation with a trident in 3D
			var tf:TextFormat = new TextFormat();
			tf.size = 24;
			_text = new TextField();
			_text.defaultTextFormat = tf;
			_text.y = 40;
			_text.width  = stage.stageWidth;
			_text.height = stage.stageHeight - 100;
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
			_viewport.camera.x = 0;
			_viewport.camera.y = 0;
			_viewport.camera.z = -1000;
			_viewport.camera.lookAt( new Vector3D(0,0,0) );
			
			addChild( _viewport );
			
			_trident = new Trident( 300 );
			_viewport.scene.addChild( _trident );

			
			//
			//	Setup the extension
			try
			{
				DeviceMotion.init( _devKey );
				
				message( "DeviceMotion Supported: " + DeviceMotion.isSupported );
				message( "DeviceMotion Version:   " + DeviceMotion.service.version );
				
				DeviceMotion.service.addEventListener( DeviceMotionEvent.UPDATE_EULER, deviceMotion_updateHandler );
				DeviceMotion.service.addEventListener( DeviceMotionEvent.UPDATE_QUATERNION, deviceMotion_updateHandler );
			}
			catch (e:Error)
			{
				message( "ERROR::" + e.message );
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
		

		private function printEvent( event:DeviceMotionEvent ):String
		{
			return event.values.join(" : ");
		}
		
		
		private function displayNumber( value:Number, decimalPlaces:int = 2 ):String
		{
			return String(Math.floor(value * Math.pow( 10, decimalPlaces )) / Math.pow( 10, decimalPlaces ));
		}
		
		
		private function DEG( radians:Number ):Number 
		{
			return radians * 180 / Math.PI;
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
			if (!DeviceMotion.service.isRegistered)
			{
				message( "Starting DeviceMotion service..." );

				var options:DeviceMotionOptions = new DeviceMotionOptions();
				options.rate 		= SensorRate.SENSOR_DELAY_NORMAL;
				options.algorithm 	= DeviceMotionOptions.ALGORITHM_NATIVE;
				options.format 		= DeviceMotionOptions.FORMAT_QUATERNION;
				
				
				message( "Algorithm supported: " + DeviceMotion.service.isAlgorithmSupported( options.algorithm, options.format ) );
				
				DeviceMotion.service.register( options );
				_messageTimer.start();
			}
		}
		
		
		private function deactivateHandler( event:Event ):void
		{
			DeviceMotion.service.unregister();
			message( "Stopping DeviceMotion service due to deactivation." );
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
		
		
		
		//
		//	EXTENSION HANDLERS
		//
		
		
		private function deviceMotion_updateHandler( event:DeviceMotionEvent ):void
		{
			if (_printMessage)
			{
				_text.text = printEvent(event);
				_printMessage = false;
			}
			
			// 	Reset to original position then rotate to current position
			var matrix:Matrix3D = new Matrix3D();
			_trident.transform = matrix;
			
			switch (event.type)
			{
				//
				//	EULER ANGLES
				case DeviceMotionEvent.UPDATE_EULER:
				{
					var azimuth:Number 	= event.values[0];
					var pitch:Number 	= event.values[1];
					var roll:Number 	= event.values[2];
					
					matrix.appendRotation( DEG(azimuth), 	_trident.forwardVector );
					matrix.appendRotation( DEG(pitch), 		_trident.rightVector );
					matrix.appendRotation( DEG(roll), 		_trident.upVector );

					_trident.transform = matrix; 
					break;			
				}
				
				//
				//	QUARTERNION
				case DeviceMotionEvent.UPDATE_QUATERNION:
				{
					var q:Quaternion = new Quaternion( event.values[1], event.values[2], event.values[3], event.values[0] );
					_trident.transform = q.toMatrix3D();
					_trident.transform.invert();
					break;
				}
					
				//
				//	ROTATION MATRIX
				case DeviceMotionEvent.UPDATE_ROTATIONMATRIX:
				{
					// incomplete
					break;
				}
						
			}
			
		}
		
		
		private function activateHandler( event:Event ):void
		{
			message( "Click screen to start DeviceMotion activity" );
		}
		
		
		
		
		
	}
}

