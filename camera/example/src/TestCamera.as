package
{
	import com.distriqt.extension.camera.Camera;
	import com.distriqt.extension.camera.CameraMode;
	import com.distriqt.extension.camera.CameraParameters;
	import com.distriqt.extension.camera.CaptureDevice;
	import com.distriqt.extension.camera.events.CameraDataEvent;
	import com.distriqt.extension.camera.events.CameraEvent;
	
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	/**
	 * This is the main implementation class of the TestCamera application
	 * 
	 * The application demonstrates the usage of the Camera Native Extension
	 *  
	 * @author Michael Archbold (ma@distriqt.com)
	 * 
	 */
	public class TestCamera extends Sprite
	{
		public static const DEV_KEY : String = "YOUR_DEVELOPER_KEY";		
		
		public function TestCamera(devKey:String=DEV_KEY)
		{
			super();
			_devKey = devKey;
			create();
			init();
			test();
		}
		
		////////////////////////////////////////////////////////
		//	VARIABLES
		//
		
		private var _devKey		: String;
		
		private var _text		: TextField;
		
		private var _mode		: String = CameraParameters.FLASH_MODE_OFF;
		
		private var _bitmapData	: BitmapData;
		private var _bitmap		: Bitmap;
		
		private var _captureBitmapData	: BitmapData;
		private var _captureBitmap		: Bitmap;
		
		private var _options	: CameraParameters
		
		
		////////////////////////////////////////////////////////
		//	FUNCTIONALITY
		//
		
		private function create( ):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			
			var tf:TextFormat = new TextFormat();
			tf.size = 16;
			_text = new TextField();
			_text.defaultTextFormat = tf;
			_text.width = stage.stageWidth;
			_text.height = stage.stageHeight;
			_text.multiline = true;
			
			_videoData  = new ByteArray();
			
			_bitmapData = new BitmapData( 640, 480, false );
			_bitmap = new Bitmap( _bitmapData );
			_bitmap.y = 20;
//			_bitmap.scaleX = _bitmap.scaleY = 0.4;
			
			_captureBitmapData = new BitmapData( 640, 480, false );
			_captureBitmap = new Bitmap( _captureBitmapData );
			_captureBitmap.y = 250;
			
			_captureBitmap.scaleX = _captureBitmap.scaleY = 0.4;
			
			
			addChild( _bitmap );
			addChild( _captureBitmap );
			addChild( _text );
		}
		
		public function init():void
		{
			try
			{
				Camera.init( _devKey );
				
			}
			catch (e:Error)
			{
				message( e.message );
			}
		}
		
		public function test():void
		{
			try
			{
				message( "Camera.isSupported:      " + Camera.isSupported );
				message( "Camera.version:          " + Camera.instance.version );
				
				message( "isFlashSupported:        " + Camera.instance.isFlashSupported() );
				message( "isTorchSupported:        " + Camera.instance.isTorchSupported() );
				
				message( "isFocusSupported:        " + Camera.instance.isFocusSupported( CameraParameters.FOCUS_MODE_AUTO ) );
				message( "isExposureSupported:     " + Camera.instance.isExposureSupported( CameraParameters.EXPOSURE_MODE_LOCKED ) );
				message( "isWhiteBalanceSupported: " + Camera.instance.isWhiteBalanceSupported( CameraParameters.WHITE_BALANCE_MODE_AUTO ) );
				
				
				
				if (Camera.isSupported)
				{
				
					_options = new CameraParameters();
					_options.enableFrameBuffer = true;
					_options.frameBufferWidth = 800;
					_options.frameBufferHeight = 600;
					_options.cameraMode = new CameraMode( CameraMode.PRESET_HIGH );

					
					// List the available devices
					message( "=============================== DEVICES ===================================" );
					var devices:Array = Camera.instance.getAvailableDevices();
					for each (var device:CaptureDevice in devices)
					{
						message( "device:[" + device.id + "]::" + device.name + "@" + device.position + "\tflash=" + device.hasFlash +"\ttorch=" + device.hasTorch );
						if (device.position == CaptureDevice.POSITION_BACK)
						{
							_options.deviceId = device.id;
						}
					}
					message( "===============================\n" );
					
					
					// List the available camera modes
					message( "=============================== GET MODES ===================================" );
					var modes:Array = Camera.instance.getModes();
					for each (var mode:CameraMode in modes)
					{
						message( "mode: "+mode.mode+" ["+mode.width+"x"+mode.height+"]" );
					}
					message( "===============================\n" );
//					if (modes.length > 0)
//					{
//						message( "setting mode: " + modes[0].width + "x" +modes[0].height );
//						_options.cameraMode = modes[0];
//					}
					
					
					
					Camera.instance.addEventListener( CameraEvent.VIDEO_FRAME, camera_videoFrameHandler, false, 0, true );
					Camera.instance.addEventListener( CameraDataEvent.CAPTURED_IMAGE, camera_capturedImageHandler, false, 0, true );
					Camera.instance.addEventListener( CameraEvent.CAPTURE_ERROR, camera_captureErrorHandler, false, 0, true ); 
					Camera.instance.addEventListener( CameraEvent.IMAGE_SAVE_COMPLETE, camera_imageSaveCompleteHandler, false, 0, true );
					Camera.instance.addEventListener( CameraEvent.IMAGE_SAVE_ERROR, camera_imageSaveErrorHandler, false, 0, true );
				}
			}
			catch (e:Error)
			{
				message( e.message );
			}
			
			stage.addEventListener( Event.RESIZE, stage_resizeHandler, false, 0, true );
			stage.addEventListener( MouseEvent.CLICK, clickHandler, false, 0, true );
			
			initialiseCamera();
			
			NativeApplication.nativeApplication.addEventListener( Event.ACTIVATE, 	activateHandler );
			NativeApplication.nativeApplication.addEventListener( Event.DEACTIVATE, deactivateHandler );
			
		}
		
		
		
		private var _inited: Boolean = false;
		private function initialiseCamera():void
		{
			try
			{
				message( "=============================== INITIALISE ===================================" );
				if (Camera.isSupported && !_inited)
				{
					Camera.instance.initialise( _options );
//					Camera.instance.setFlashMode( CameraParameters.FLASH_MODE_ON );
					
					
//					var modes:Array = Camera.instance.getModes();
//					for each (var mode:CameraMode in modes)
//					{
//						message( "mode: "+mode.mode+" ["+mode.width+"x"+mode.height+"]" );
//					}
//					
//					Camera.instance.setMode( new CameraMode( CameraMode.PRESET_PHOTO ));
				}
				message( "===============================\n" );
				_inited = true;
			}
			catch (e:Error)
			{
				message( e.message );
			}
		}
		
		private function release():void
		{
			try
			{
				// Release the camera
				if (Camera.isSupported)
				{
					Camera.instance.release();
				}
				_inited = false;
			}
			catch (e:Error)
			{
				message( e.message );
			}
		}
		
		private function finish():void
		{
			try
			{
				Camera.instance.release();
				message( "finished" );
			}
			catch (e:Error)
			{
				message( e.message );
			}
			
		}
		
		
		
		
		
		////////////////////////////////////////////////////////
		//	INTERNALS
		//
		
		private function message( str:String ):void
		{
			trace( str );
			_text.text = str + "\n" + _text.text;
		}
		
		
		////////////////////////////////////////////////////////
		//	EVENT HANDLERS
		//
		
		private var _time : Number;
		
		private function clickHandler( event:MouseEvent ):void
		{
			message( "click" );
			_time = getTimer();
			
			Camera.instance.removeEventListener( CameraEvent.VIDEO_FRAME, camera_videoFrameHandler );
			Camera.instance.setMode( new CameraMode( CameraMode.PRESET_PHOTO ));

			var success:Boolean = Camera.instance.captureImage( true /* Change to true to save to camera roll */  );
			message( "captureImage() = " + success );
		}
		
		
		//
		//	VIDEO FRAME DATA EXAMPLE
		//
		
		private var _lastFrameProcessed	: Number = -1;
		
		private var _videoData			: ByteArray = null;
		
		private function camera_videoFrameHandler( event:CameraEvent ):void
		{
			var frame:Number = Camera.instance.receivedFrames;
//			message( "received frame: "+frame );
			if (frame != _lastFrameProcessed)
			{
				if (-1 != Camera.instance.getFrameBuffer( _videoData ))
				{
//					message( Camera.instance.width +"x"+ Camera.instance.height );
					var rect:Rectangle = new Rectangle( 0, 0, Camera.instance.width, Camera.instance.height );
					if (_bitmapData.width != Camera.instance.width || _bitmapData.height != Camera.instance.height)
					{
						_bitmapData = new BitmapData( Camera.instance.width, Camera.instance.height, false );
						_bitmap.bitmapData.dispose();
						_bitmap.bitmapData = _bitmapData;
					}
					
					try
					{
						_bitmapData.setPixels( rect, _videoData );
					}
					catch (e:Error)
					{
						message( "ERROR::setPixels: " + e.message );
					}
					
					_videoData.clear();
					_lastFrameProcessed = frame;
				}
			}
			
		}
		
		
		//
		//	CAPTURE IMAGE EXAMPLE
		//
		
		private function camera_capturedImageHandler( event:CameraDataEvent ):void
		{
			Camera.instance.setMode( new CameraMode( CameraMode.PRESET_HIGH ));
			Camera.instance.addEventListener( CameraEvent.VIDEO_FRAME, camera_videoFrameHandler, false, 0, true );

			message( "capture complete: " + String(Math.floor(getTimer() - _time) / 1000) );
			
			if (_captureBitmapData.width != event.data.width || _captureBitmapData.height != event.data.height)
			{
				_captureBitmapData = new BitmapData( event.data.width, event.data.height, false );
				_captureBitmap.bitmapData.dispose();
				_captureBitmap.bitmapData = _captureBitmapData;
			}
			
			try
			{
				_captureBitmapData.draw( event.data );
			}
			catch (e:Error)
			{
				trace( e.message );
			}
		}
		
		
		private function camera_captureErrorHandler( event:CameraEvent ):void
		{
			Camera.instance.setMode( new CameraMode( CameraMode.PRESET_HIGH ));
			Camera.instance.addEventListener( CameraEvent.VIDEO_FRAME, camera_videoFrameHandler, false, 0, true );

			message( "image capture error: " + event.data );
		}
		
		
		private function camera_imageSaveCompleteHandler( event:CameraEvent ):void
		{
			message( "image save complete: " +event.data );
		}
		
		
		private function camera_imageSaveErrorHandler( event:CameraEvent ):void
		{
			message("image save ERROR: "+event.data );
		}
		
		
		//
		//	GENERAL
		//
		
		private function activateHandler( event:Event ):void
		{
			//	Reinitialise the camera when application is activated again.
			message( "activate" );
			initialiseCamera();
		}
		
		private function deactivateHandler( event:Event ):void
		{
			// Release the camera when the application is deactivated.
			message( "deactivate" );
			release();
		}
		
		private function stage_resizeHandler( event:Event ):void
		{
			_text.width  = stage.stageWidth;
			_text.height = stage.stageHeight;
		}
	}
}
