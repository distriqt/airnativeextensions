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
 * @file   		TestBumpService.as
 * @brief  		
 * @author 		Shane Korin
 * @created		Jan 4, 2012
 * @updated		$Date:$
 * @copyright	http://distriqt.com/copyright/license.txt
 */
package
{
	import com.bit101.components.PushButton;
	import com.distriqt.extension.base.DistriqtANETestBase;
	import com.distriqt.extension.bumpservice.BumpService;
	import com.distriqt.extension.bumpservice.events.BumpServiceEvent;
	import com.distriqt.extension.dialog.Dialog;
	import com.distriqt.extension.dialog.events.DialogEvent;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class TestBumpService extends DistriqtANETestBase
	{ 
	
		static public const NO_MATCH_DLG	: int = 0;
		static public const MATCH_DLG		: int = 1;		
		
		private var _bump			: BumpService;
		private var _running		: Boolean = false;
		private var _testId			: String = "";
		private var _channelOpened	: Boolean = false; 
		private var _autoMatch		: Boolean = false;
		
		
		
		
		
		public function TestBumpService()	
		{ 
			super();
			
			
		}
		
		
		override protected function init():void
		{
			
			addButton( "connect", "Service > Connect", btn_connectHandler );
			addButton( "disconnect", "Service > Disconnect", btn_disconnectHandler );
			addButton( "enableBump", "Service > Enable Bumping", btn_enableBumpHandler );
			addButton( "disableBump", "Service > Disable Bumping", btn_disableBumpHandler );
			addButton( "sendMessage", "Service > Change Auto Match", btn_changeAutoMatchHandler );
			addButton( "sendMessage", "Service > Send Message", btn_sendMessageHandler );
			
			message( "TestBumpService::init()" +"\n");
			
			
			BumpService.init( "your-developer-key" );
			Dialog.init( "your-developer-key" );
			
			Dialog.service.addEventListener( DialogEvent.DIALOG_CLOSED, dialog_closedHandler );
			
			try
			{				
				message("Creating extension...");
				
				BumpService.service.addEventListener( BumpServiceEvent.BUMP_CONNECTED, bump_sessionEventHandler );
				BumpService.service.addEventListener( BumpServiceEvent.BUMP_DISCONNECTED, bump_sessionEventHandler );
				BumpService.service.addEventListener( BumpServiceEvent.BUMP_CHANNEL_CONFIRMED, bump_sessionEventHandler );
				BumpService.service.addEventListener( BumpServiceEvent.BUMP_MATCHED, bump_sessionEventHandler );
				BumpService.service.addEventListener( BumpServiceEvent.BUMP_DATA_RECEIVED, bump_sessionEventHandler );
				BumpService.service.addEventListener( BumpServiceEvent.BUMP_BUMP_DETECTED, bump_sessionEventHandler );
				BumpService.service.addEventListener( BumpServiceEvent.BUMP_NO_MATCH, bump_sessionEventHandler );
				
				
				_testId = String( "-- " + int(Math.random() * 9999) + " --");
				message("Your test key is: " + _testId);
				
			}
			catch (e:Error)
			{
				_text.appendText( e.message );
			}
		}
		
		
		
		
		
		////////////////////////////////////////////////////////
		//	EVENT HANDLERS
		//
		
		protected function dialog_closedHandler(event:DialogEvent):void
		{
			if (event.id == MATCH_DLG)
			{
				BumpService.service.confirmMatch();
			}
		}	
		
		
		////////////////////////////////////////////////////////
		//	BUTTON FUNTION HANDLERS
		//
		
		protected function btn_connectHandler( event:MouseEvent ):void
		{
			message("Connecting...");
			BumpService.service.connect( "bump-api-key" );
		}
		
		protected function btn_disconnectHandler( event:MouseEvent ):void
		{
			message("Disconnecting...");
			BumpService.service.disconnect();
		}
		
		protected function btn_enableBumpHandler( event:MouseEvent ):void
		{
			message("Enable bumping...");
			BumpService.service.enableBumping( true );
		}
		
		protected function btn_disableBumpHandler( event:MouseEvent ):void
		{
			message("Disable bumping...");
			BumpService.service.enableBumping( false );
		}
		
		protected function btn_sendMessageHandler( event:MouseEvent ):void
		{
			var msg:String = "Message from " + _testId + " : " + new Date().time;
			message("Sending message: '" + msg + "'");
			BumpService.service.sendData( msg );
		}
		
		protected function btn_changeAutoMatchHandler( event:MouseEvent ):void
		{
			_autoMatch = (_autoMatch == true) ? false : true;
			message("Set auto match: " + _autoMatch );
			BumpService.service.setAutoMatch( _autoMatch );
		}
		
		
		
		////////////////////////////////////////////////////////
		//	NOTIFICATION HANDLERS
		//
		
		
		protected function bump_sessionEventHandler(event:BumpServiceEvent):void
		{
			switch (event.type)
			{
				case BumpServiceEvent.BUMP_CONNECTED:
					message("Bump Connected : " + event.data);
					break;
				
				case BumpServiceEvent.BUMP_DISCONNECTED:
					message("Bump Disconnected : " + event.data);
					_channelOpened = false;
					_running = true;
					break;
				
				case BumpServiceEvent.BUMP_CHANNEL_CONFIRMED:
					message("Bump Channel Confirmed : " + event.data);
					_channelOpened = true;
					break;
				
				case BumpServiceEvent.BUMP_MATCHED:
					message("Bump Matched : " + event.data);
					if (!_autoMatch)
					{
						Dialog.service.showAlertDialog( MATCH_DLG, "Confirm match", "Confirm match with " + event.data, "YES" );
					}
					break;
				
				case BumpServiceEvent.BUMP_DATA_RECEIVED:
					message("Bump Data Received : " + event.data);
					break;
				
				case BumpServiceEvent.BUMP_BUMP_DETECTED:
					message("Bump Detected : " + event.data);
					break;
				
				case BumpServiceEvent.BUMP_NO_MATCH:
					message("Bump Match Failed : " + event.data);
					Dialog.service.showAlertDialog( NO_MATCH_DLG, "Status", "No match found!", "OK" );
					_channelOpened = false;
					break;
			}
		}
	}
}
