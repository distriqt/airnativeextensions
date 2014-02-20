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
	import com.distriqt.extension.facebookutils.FacebookUtils;
	import com.distriqt.extension.facebookutils.events.FacebookUtilsLoginEvent;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	/**	
	 * Sample application for using the FacebookUtils Native Extension
	 * 
	 * @author	Shane Korin 
	 */
	public class TestFacebookUtils extends Sprite
	{
		
		
		/**
		 * Class constructor 
		 */	
		public function TestFacebookUtils()
		{
			super();
			create();
			init(); 
		}
			
		
		//
		//	VARIABLES
		//
		
		private var _text		: TextField;
		private var _test		: int = 0;
		
		
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
			
			addEventListener( Event.ACTIVATE, activateHandler, false, 0, true );
			addEventListener( Event.DEACTIVATE, deactivateHandler, false, 0, true );
		}
		
		
		private function init( ):void
		{
			try
			{
				FacebookUtils.init( "your-developer-key" );
				
				message( "FacebookUtils Supported: "+ String(FacebookUtils.isSupported) );
				message( "FacebookUtils Version: " + FacebookUtils.service.version );
				
				if (FacebookUtils.service.supportsSSO())
				{
					FacebookUtils.service.addEventListener( FacebookUtilsLoginEvent.LOGIN_RESULT, login_resultHandler );
					FacebookUtils.service.addEventListener( FacebookUtilsLoginEvent.LOGIN_ERROR, login_errorHandler );
					FacebookUtils.service.addEventListener( FacebookUtilsLoginEvent.USER_CANCELLED, login_cancelledHandler );
				}
				
				//
				//	Add test inits here
				//
			}
			catch (e:Error)
			{
				
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
			
			if (_test == 0)
			{
				message( "Facebook SSO supported: " + FacebookUtils.service.supportsSSO() );
				message( "Tap again to login." );
				_test = 1;
				return;
			}
			
			if (_test == 1)
			{
				FacebookUtils.service.addEventListener( FacebookUtilsLoginEvent.LOGIN_RESULT, login_resultHandler );
					
				if ( FacebookUtils.service.beginLogin( "your-facebook-application-id", [ "read_stream", "email", "publish_stream" ] ))
				{
					message("Starting login...");
				}
				else
				{
					message("Login attempt failed.");
				}
			}
		}
		
		
		
		protected function login_resultHandler(event:FacebookUtilsLoginEvent):void
		{
			if (FacebookUtils.service.isAndroid())
			{
				message("Login Result: Token:" + event.arguments[0]);
			}
			else
			{
				message("Login Result: " + event.arguments);	
			}
		}
		
		
		protected function login_errorHandler(event:FacebookUtilsLoginEvent):void
		{
			message("Login Error: " + event.arguments[0]);
		}
		
		
		protected function login_cancelledHandler(event:FacebookUtilsLoginEvent):void
		{
			message("Login Cancelled: " + event.arguments[0]);
		}
		
		
		private function activateHandler( event:Event ):void
		{
			
		}
		
		private function deactivateHandler( event:Event ):void
		{
			trace( "deactivateHandler() ");
		}

		
	}
}

