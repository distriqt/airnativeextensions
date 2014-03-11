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
 * @file   		TestNotifications.as
 * @brief  		
 * @author 		Michael Archbold
 * @created		Jan 17, 2012
 * @updated		$Date:$
 * @copyright	http://distriqt.com/copyright/license.txt
 */
package
{
	import com.distriqt.extension.notifications.Notification;
	import com.distriqt.extension.notifications.NotificationIconType;
	import com.distriqt.extension.notifications.NotificationRepeatInterval;
	import com.distriqt.extension.notifications.Notifications;
	import com.distriqt.extension.notifications.events.NotificationEvent;
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	
	/**	
	 * Test application for the com.distriqt.Notifications Native Extension
	 * 
	 * @author	Michael Archbold (ma@distriqt.com)
	 */
	public class TestNotifications extends Sprite
	{
		public static const DEV_KEY : String = "YOUR_DEVELOPER_KEY";		
		
		
		/**
		 *  Constructor
		 */
		public function TestNotifications()
		{
			super();
			create();
			
			try
			{
				Notifications.init( DEV_KEY );
				message( "Press to send a notification" );
				message( String(Notifications.isSupported) );
				message( Notifications.service.version );
				
				Notifications.service.addEventListener( NotificationEvent.NOTIFICATION_DISPLAYED, notifications_notificationDisplayedHandler, false, 0, true );
				Notifications.service.addEventListener( NotificationEvent.NOTIFICATION_SELECTED,  notifications_notificationSelectedHandler,  false, 0, true );
			}
			catch (e:Error)
			{
				message( "ERROR:"+e.message );
			}
		}
		
		
		////////////////////////////////////////////////////////
		//	VARIABLES
		//

		private var _text		: TextField;
		private var _count		: int = 0;
		

		////////////////////////////////////////////////////////
		//	FUNCTIONALITY
		//
		
		
		private function sendNotification():void
		{
			var notification:Notification = new Notification();
			
			notification.id 		= int(Math.random()*100);
			notification.tickerText = "Hello "+notification.id;
			notification.title 		= "My Notification "+notification.id;
			notification.body		= "Hello World!";
//			notification.iconType	= NotificationIconType.DOCUMENT;
			notification.count		= 0;
			notification.vibrate	= false;
			notification.playSound  = true;
			notification.soundName  = "fx05.caf";
			notification.delay		= 1;
			
			// use Notifications.service.cancelAll() to cancel repeat notifications like the following:
//			notification.repeatInterval = NotificationRepeatInterval.REPEAT_MINUTE;
			
//			var fireDate:Date = new Date(2012,05,13, 1,1,1);
//			var current:Date = new Date();
//			var seconds:int = int((fireDate.time - current.time)/ 1000);
//			
//			notification.delay = seconds;
			
			notification.data		= "Some notification data to attach "+notification.id;
			
			try
			{
				Notifications.service.notify( notification.id, notification );
				
				_count ++;
				Notifications.service.setBadgeNumber( _count );
				message( "sendNotification():sent:"+notification.id );
			}
			catch (e:Error)
			{
				message( "ERROR:"+e.message );
			}
			
		}
		
		
		////////////////////////////////////////////////////////
		//	INTERNALS
		//
		
		private function create():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener( Event.RESIZE, stage_resizeHandler, false, 0, true );
			stage.addEventListener( MouseEvent.CLICK, mouseClickHandler, false, 0, true );
			
			var tf:TextFormat = new TextFormat();
			tf.size = 24;
			_text = new TextField();
			_text.defaultTextFormat = tf;
			_text.width = 480;
			_text.height = 800;
			_text.selectable = false;
			addChild( _text );
			
//			var closeButton:Sprite = new Sprite();
//			closeButton.graphics.beginFill( 0xFF0000 );
//			closeButton.graphics.drawRect(0,0,200,200);
//			closeButton.addEventListener( MouseEvent.CLICK, closeButton_clickHandler, false, 0, true );
//			
//			addChild( closeButton );
		}
		
		
		private function message( m:String ):void
		{
			trace( m );
			_text.appendText( m + "\n" );
		}
		
		
		////////////////////////////////////////////////////////
		//	EVENT HANDLERS
		//
		
		private function stage_resizeHandler( event:Event ):void
		{
			_text.width  = stage.stageWidth;
			_text.height = stage.stageHeight;
		}
		
		
		private function mouseClickHandler( event:MouseEvent ):void
		{
			sendNotification();
		}
		
		
		private function notifications_notificationDisplayedHandler( event:NotificationEvent ):void
		{
			message( event.type + "::["+event.id+"]::"+event.data );
		}
		
		
		private function notifications_notificationSelectedHandler( event:NotificationEvent ):void
		{
			message( event.type + "::["+event.id+"]::"+event.data );
			try
			{
				_count --;
				Notifications.service.cancel( event.id );
				Notifications.service.setBadgeNumber( _count );
//				Notifications.service.cancelAll();
			}
			catch (e:Error)
			{
			}
		}
		
		private function closeButton_clickHandler( event:MouseEvent ):void
		{
			NativeApplication.nativeApplication.exit();
			event.stopImmediatePropagation();
		}
		
	}
}