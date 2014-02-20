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
	import com.distriqt.extension.testflightsdk.TestFlightSDK;
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	/**	
	 * <p>
	 * Sample application for using the TestFlightSDK Native Extension
	 * </p>
	 * 
	 * @author	Michael Archbold
	 */
	public class TestTestFlightSDK extends Sprite
	{
		public static const DEV_KEY : String = "your_dev_key";
		
		public static const TESTFLIGHT_APPTOKEN_ANDROID : String = "android_app_token";
		public static const TESTFLIGHT_APPTOKEN_IOS 	: String = "ios_app_token";
		
		
		/**
		 * Class constructor 
		 */	
		public function TestTestFlightSDK()
		{
			super();
			create();
			init();
		}
		
		
		//
		//	VARIABLES
		//
		
		private var _text		: TextField;
		private var _count		: int = 0;
		
		
		
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
			
			addEventListener( Event.ACTIVATE, activateHandler, false, 0, true );
			addEventListener( Event.DEACTIVATE, deactivateHandler, false, 0, true );
		}
		
		private function init( ):void
		{
			try
			{
				TestFlightSDK.init( DEV_KEY );
								
				var ns:Namespace = NativeApplication.nativeApplication.applicationDescriptor.namespace();
				var version:String = NativeApplication.nativeApplication.applicationDescriptor.ns::versionNumber;
				message( "Starting application: " + NativeApplication.nativeApplication.applicationID +" ["+version+"]" );
				
				message( "TestFlightSDK Supported: "+ TestFlightSDK.isSupported );
				message( "TestFlightSDK Version: "  + TestFlightSDK.service.version );
				
				//
				//	Call startTestFlight with the appToken for the correct platform 
				if (TestFlightSDK.service.version.indexOf( "Android" ) != -1)
				{					
					message( "Starting TestFlight for Android...");
					message( "app token = " + TESTFLIGHT_APPTOKEN_ANDROID );
					
					TestFlightSDK.service.startTestFlight( TESTFLIGHT_APPTOKEN_ANDROID );
				}
				else	
				{
					message( "Starting TestFlight for iOS...");
					message( "app token = " + TESTFLIGHT_APPTOKEN_IOS );
					
					TestFlightSDK.service.startTestFlight( TESTFLIGHT_APPTOKEN_IOS );
				}
				
				message( "TestFlightSDK sdkVersion: " + TestFlightSDK.service.sdkVersion() );
				
				stage.addEventListener( MouseEvent.CLICK, testFlightActionHandler, false, 0, true );
			}
			catch (e:Error)
			{
				message( "ERROR:: " +e.message );
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
		
		
		private function testFlightActionHandler( event:MouseEvent ):void
		{
			//
			//	Do something when user clicks screen?
			//	
			try
			{
				if (_count == 0)
				{
					message( "Starting session" );
					TestFlightSDK.service.startSession();
					_count++;
				}
				else
				if (_count == 1)
				{ 
					message("Testing CHECKPOINT 1");
					TestFlightSDK.service.passCheckpoint( "TEST_CHECKPOINT_1" );
					_count++;
				}
				else
				if (_count == 2)
				{
					message("Testing CHECKPOINT 2");
					TestFlightSDK.service.passCheckpoint( "TEST_CHECKPOINT_2" );
					_count++;
				}
				else
				if (_count == 3)
				{
					message("Testing feedback view");
//					TestFlightSDK.service.openFeedbackView();
					_count++;
				}
				else
				if (_count == 4)
				{
					message("Testing custom feedback");
					TestFlightSDK.service.submitFeedback("My custom feedback");
					_count++;
				}
				else
				if (_count == 5)
				{
					message("Sending a TFLog message");
					var success:Boolean = TestFlightSDK.service.log( "Testing a log message..."+Math.random().toString() );
					message( "success="+success );
					_count++;
				}
				else
				{
					message("We're done.");
					TestFlightSDK.service.endSession();
					_count = 0;
				}
			}
			catch (e:Error)
			{
				message( "ERROR:: "+e.message );
			}
		}

		
		private function activateHandler( event:Event ):void
		{
//			TestFlightSDK.service.startTestFlight( TESTFLIGHT_APPTOKEN );
		}
		
		
		private function deactivateHandler( event:Event ):void
		{
//			trace( "deactivateHandler() ");
		}

		
	}
}

