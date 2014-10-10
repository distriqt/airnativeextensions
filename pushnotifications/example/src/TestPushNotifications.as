package
{
	import com.distriqt.extension.pushnotifications.PushNotifications;
	import com.distriqt.extension.pushnotifications.events.PushNotificationEvent;
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * This is a test application for the distriqt push notifications native extension service
	 * 
	 * 
	 * @author Michael Archbold (ma@distriqt.com)
	 * 
	 */	
	public class TestPushNotifications extends Sprite
	{
		public static const DEV_KEY			: String = "YOUR_DEVELOPER_KEY";
		public static const GCM_SENDER_ID 	: String = "YOUR_GCM_SENDER_ID";
		
		
		/**
		 * Class constructor 
		 */		
		public function TestPushNotifications( devKey:String = DEV_KEY, gcmSenderId:String = GCM_SENDER_ID )
		{
			super();
			_devKey = devKey;
			_gcmSenderId = gcmSenderId;
			create();
			init();	
		}
		
		
		////////////////////////////////////////////////////////
		//	VARIABLES
		//
		
		private var _devKey			: String;
		private var _gcmSenderId	: String;
		private var _idField		: TextField;
		private var _messageField	: TextField;
		
		
		////////////////////////////////////////////////////////
		//	HELPERS
		//	
		
		private function create():void
		{
			var tf:TextFormat = new TextFormat();
			tf.size = 24;
			
			_idField = new TextField();
			_idField.defaultTextFormat = tf;
			_idField.wordWrap = true;
			
			_messageField = new TextField();
			_messageField.border = true;
			_messageField.defaultTextFormat = tf;
			
			addChild( _messageField );
			addChild( _idField );
			
			_messageField.y = _idField.height;	
			
			stage.align     = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener( Event.RESIZE, stage_resizeHandler, false, 0, true );
			stage.addEventListener( MouseEvent.CLICK, mouseClickHandler, false, 0, true );
			
			NativeApplication.nativeApplication.addEventListener( Event.ACTIVATE, activateHandler );
		}
		
		private function message( str:String ):void
		{
			trace( str );
			_messageField.appendText( str + "\n" );
		}
		
		
		////////////////////////////////////////////////////////
		//	EVENT HANDLERS
		//
		
		private function stage_resizeHandler( event:Event ):void
		{
			_idField.width = stage.stageWidth;
			_messageField.width  = stage.stageWidth;
			_messageField.height = stage.stageHeight - _messageField.y;
		}
		
		
		private function mouseClickHandler( event:MouseEvent ):void
		{
			doSomething();
		}
		
		

		
		////////////////////////////////////////////////////////
		//	PUSH NOTIFICATIONS EXAMPLE
		//	

		private function init():void
		{
			try
			{
				PushNotifications.init( _devKey );

				message( "PN Supported: "+ String(PushNotifications.isSupported) );
				message( "PN Version: " + PushNotifications.service.version );

				PushNotifications.service.addEventListener( PushNotificationEvent.REGISTER_SUCCESS, 		pn_registerSuccessHandler );
				PushNotifications.service.addEventListener( PushNotificationEvent.UNREGISTERED, 			pn_unregisterSuccessHandler );
				PushNotifications.service.addEventListener( PushNotificationEvent.NOTIFICATION, 			pn_notificationHandler );
				PushNotifications.service.addEventListener( PushNotificationEvent.BACKGROUND_NOTIFICATION, 	pn_backgroundNotificationHandler );
				PushNotifications.service.addEventListener( PushNotificationEvent.FOREGROUND_NOTIFICATION, 	pn_foregroundNotificationHandler );
				
				PushNotifications.service.addEventListener( PushNotificationEvent.ERROR,					pn_errorHandler );
				
				PushNotifications.service.register( _gcmSenderId );
			}
			catch (e:Error)
			{
				message( e.message );
			}
		}
		
		
		private function doSomething():void
		{
			try
			{
				//
				//	Just switch registration state on press
				if (PushNotifications.service.getDeviceToken() == "")
				{
					PushNotifications.service.register( _gcmSenderId );
				}
				else
				{
					PushNotifications.service.unregister();
				}
			}
			catch (e:Error)
			{
				message( "ERROR:"+e.message );
			}
		}
		
		
		////////////////////////////////////////////////////////
		//	NOTIFICATION HANDLERS
		//
		
		
		private function pn_registerSuccessHandler( event:PushNotificationEvent ):void
		{
			message( "PN registration succeeded with reg ID: \n" + event.data  );
			_idField.text = event.data;
		}
		
		private function pn_unregisterSuccessHandler( event:PushNotificationEvent ):void
		{
			message( "PN unregistration succeeded"  );
			_idField.text = event.data;
		}
		
		private function pn_notificationHandler( event:PushNotificationEvent ):void
		{
			message("Remote notification received!" );
			message( event.data );
			
			try
			{
				JSON.parse( event.data );
			}
			catch (e:Error)
			{
				message( "ERROR::"+e.message );
			}
		}
		
		private function pn_foregroundNotificationHandler( event:PushNotificationEvent ):void
		{
			message( "FOREGROUND" );
		}
		
		private function pn_backgroundNotificationHandler( event:PushNotificationEvent ):void
		{
			message( "BACKGROUND" );
		}
		
		private function pn_errorHandler( event:PushNotificationEvent ):void
		{
			message( "ERROR::"+event.data );
		}
		
		
		
		private function activateHandler( event:Event ):void
		{
			message( "ACTIVATE" );
		}
		
		
		
	}
}
