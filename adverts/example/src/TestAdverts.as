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
	import com.distriqt.extension.adverts.AdvertPlatform;
	import com.distriqt.extension.adverts.AdvertPosition;
	import com.distriqt.extension.adverts.Adverts;
	import com.distriqt.extension.adverts.events.AdvertEvent;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	
	/**	
	 * Sample application for using the Adverts Native Extension
	 * 
	 * @author	Michael Archbold
	 */
	public class TestAdverts extends Sprite
	{
		public static const DEV_KEY : String = "YOUR_DEVELOPER_KEY";
		

		public static const ADMOB_ACCOUNT_ID	: String = "YOUR_ADMOB_ACCOUNT_ID";
		public static const IAD_ACCOUNT_ID		: String = "";
		
		/**
		 * Class constructor 
		 */	
		public function TestAdverts( devKey:String=DEV_KEY )
		{
			super();
			_devKey = devKey;
			create();
			init();
		}
		
		
		//
		//	VARIABLES
		//
		
		private var _devKey			: String;
		private var _text			: TextField;
		
		
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
			stage.addEventListener( MouseEvent.CLICK, stage_clickHandler, false, 0, true );
		}
		
		
		private function init( ):void
		{
			try
			{
				var time:int = getTimer();
				Adverts.init( _devKey );
				message( "Adverts.init() : " + String((getTimer() - time)/1000) + " seconds" ); 
				
				
				message( "Adverts Supported: " + Adverts.isSupported );
				message( "Adverts Version:   " + Adverts.service.version );
				message( "ADMOB Support = " + Adverts.service.isPlatformSupported( AdvertPlatform.PLATFORM_ADMOB ) );
				message( "IAD Support = " + Adverts.service.isPlatformSupported( AdvertPlatform.PLATFORM_IAD ) );
				
				if (Adverts.isSupported)
				{
					Adverts.service.addEventListener( AdvertEvent.RECEIVED_AD, 				adverts_receivedAdHandler, false, 0, true );
					Adverts.service.addEventListener( AdvertEvent.ERROR, 					adverts_errorHandler, false, 0, true );
					Adverts.service.addEventListener( AdvertEvent.USER_EVENT_DISMISSED, 	adverts_userDismissedHandler, false, 0, true );
					Adverts.service.addEventListener( AdvertEvent.USER_EVENT_LEAVE,			adverts_userLeaveHandler, false, 0, true );
					Adverts.service.addEventListener( AdvertEvent.USER_EVENT_SHOW_AD, 		adverts_userShowAdHandler, false, 0, true );
					
					if (Adverts.service.isPlatformSupported( AdvertPlatform.PLATFORM_IAD ))
//						if (Adverts.service.isPlatformSupported( AdvertPlatform.PLATFORM_ADMOB ))
					{
						Adverts.service.initialisePlatform( AdvertPlatform.PLATFORM_IAD, IAD_ACCOUNT_ID );
	//					Adverts.service.initialisePlatform( AdvertPlatform.PLATFORM_ADMOB, ADMOB_ACCOUNT_ID );
						
						
						var size:AdvertPosition = new AdvertPosition();
						size.verticalAlign = AdvertPosition.ALIGN_BOTTOM;
						size.horizontalAlign = AdvertPosition.ALIGN_RIGHT;
	
						message("Adverts.showAdvert(" + size.toString() + ")");
						Adverts.service.showAdvert( size );
					}
					else
					{
						message( "iAd not supported" );
					}
				}
				else
				{
					message( "Not supported..." );
				}
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
		
		
		private function refresh():void
		{
			message( "refresh" );
			if (Adverts.isSupported)
			{
				Adverts.service.refreshAdvert();
			}
		}
		

		private function adverts_receivedAdHandler( event:AdvertEvent ):void
		{
			message( "adverts_receivedAdHandler" );
		}
		
		private function adverts_errorHandler( event:AdvertEvent ):void
		{
			message( "adverts_errorHandler:: " + event.details.message );
			//
			//	If you wish you can force a reload attempt here by setting a delayed call to refreshAdvert
			setTimeout( refresh, 10000 );
		}
		
		private function adverts_userDismissedHandler( event:AdvertEvent ):void
		{
			message( "adverts_userDismissedHandler" );
		}
		
		private function adverts_userLeaveHandler( event:AdvertEvent ):void
		{
			message( "adverts_userLeaveHandler" );
		}
		
		private function adverts_userShowAdHandler( event:AdvertEvent ):void
		{
			message( "adverts_userShowAdHandler" );
		}
		
		
		private function stage_clickHandler( event:MouseEvent ):void
		{
			try
			{
				Adverts.service.hideAdvert();
				setTimeout( refresh, 4000 );
			}
			catch (e:Error)
			{
				message( "ERROR::"+e.message );
			}
		}
	}
}

