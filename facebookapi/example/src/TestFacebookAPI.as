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
	import com.distriqt.extension.facebookapi.FacebookAPI;
	import com.distriqt.extension.facebookapi.events.FacebookAPIEvent;
	import com.distriqt.extension.facebookapi.events.FacebookAppRequestEvent;
	import com.distriqt.extension.facebookapi.events.FacebookOpenGraphActionEvent;
	import com.distriqt.extension.facebookapi.objects.FacebookAppRequestInfo;
	import com.distriqt.extension.facebookapi.objects.FacebookDialogType;
	import com.distriqt.extension.facebookapi.objects.FacebookShareParams;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.setTimeout;
	
	
	/**	
	 * Sample application for using the FacebookAPI Native Extension
	 * 
	 * @author	Michael Archbold
	 */
	public class TestFacebookAPI extends Sprite
	{
		public static const DEV_KEY : String = "your-dev-key";
		
		/**
		 * Class constructor 
		 */	
		public function TestFacebookAPI()
		{
			super();
			create();
			init();
		}
		
		
		//
		//	VARIABLES
		//
		
		private var _buttons	: Array;
		private var _text		: TextField;
		private var _dialogType	: String = FacebookDialogType.NATIVE;
		
		
		//
		//	INITIALISATION
		//	
		
		private function create( ):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_buttons = [];
			
			var tf:TextFormat = new TextFormat();
			tf.size = 24;
			_text = new TextField();
			_text.defaultTextFormat = tf;
			addChild( _text );
			
			stage.addEventListener( Event.RESIZE, stage_resizeHandler, false, 0, true );
			stage.addEventListener( MouseEvent.CLICK, mouseClickHandler, false, 0, true );
		}
		
		
		//
		//	FUNCTIONALITY
		//
		
		private function init( ):void
		{
			try
			{
				FacebookAPI.init( DEV_KEY );
				
				message( "FacebookAPI Supported: "+ String(FacebookAPI.isSupported) );
				message( "FacebookAPI Version: " + FacebookAPI.service.version );
				
				FacebookAPI.service.addEventListener( FacebookAPIEvent.SESSION_OPENED, session_openedHandler );
				FacebookAPI.service.addEventListener( FacebookAPIEvent.SESSION_CLOSED, session_closedHandler );
				FacebookAPI.service.addEventListener( FacebookAPIEvent.SESSION_OPEN_DISABLED, session_openDisabledHandler );
				FacebookAPI.service.addEventListener( FacebookAPIEvent.SESSION_OPEN_ERROR, session_openErrorHandler );
				FacebookAPI.service.addEventListener( FacebookAPIEvent.GET_PERMISSIONS_COMPLETED, permissionsResultHandler );
				FacebookAPI.service.addEventListener( FacebookAPIEvent.APP_INVOKED, appInvokedHandler );
				FacebookAPI.service.addEventListener( FacebookAppRequestEvent.APP_REQUESTS_FOUND, appRequestsFoundHandler );
				FacebookAPI.service.addEventListener( FacebookAppRequestEvent.APP_REQUEST_DATA_LOADED, appRequestsDataHandler );
				FacebookAPI.service.addEventListener( FacebookOpenGraphActionEvent.ACTION_IDS_FOUND, actionIdsFoundHandler );
				FacebookAPI.service.addEventListener( FacebookAPIEvent.DIALOG_COMPLETED, dialog_completedHandler );
				FacebookAPI.service.addEventListener( FacebookAPIEvent.DIALOG_CANCELLED, dialog_completedHandler );
				FacebookAPI.service.addEventListener( FacebookAPIEvent.DIALOG_ERROR, dialog_completedHandler );
				
				message("Initialising...");
				setTimeout( createUI, 500 );
			}
			catch (e:Error)
			{
				message("ERROR!");
			}
		}
		
		
		
		//
		//	EVENT HANDLERS
		//
		
		private function stage_resizeHandler( event:Event ):void
		{
			_text.width  = stage.stageWidth;
			_text.height = stage.stageHeight * 0.5;
			
		}
		
		
		private function mouseClickHandler( event:MouseEvent ):void
		{
			if (!FacebookAPI.isSupported)
			{
				message("Facebook API not supported on this platform!");
				return;
			}
			
			switch (event.currentTarget)
			{
				
				// Init Facebook and create session
				case _buttons[0]:
					message("Initialising FacebookAPI...\n");
					FacebookAPI.service.initialiseApp( "YOUR_FACEBOOK_APP_ID" );
					break;
				
				// Log in
				case _buttons[1]:
					FacebookAPI.service.createSession( [ "basic_info" ], true, true );
					break;
				
				// Check session
				case _buttons[2]:
					message( "Session open: " + FacebookAPI.service.isSessionOpen().toString() );
					message( "Token: " + FacebookAPI.service.getAccessToken() );
					break;
				
				// Request publish permissions
				case _buttons[3]:
					FacebookAPI.service.requestPermissions( [ "publish_actions", "photo_upload" ], false );
					break;
				
				// Load the current permissions for the user
				case _buttons[4]:
					FacebookAPI.service.getCurrentPermissions();
					break;
				
				// Share dialog to share a link
				case _buttons[5]:
					var params:FacebookShareParams = new FacebookShareParams();
					params.title = "This is the title";
					params.caption = "This is the caption";
					params.description = "This is the description";
					//params.link = "http://bolleloz.herokuapp.com/test";
					FacebookAPI.service.openShareDialog( params, dialogResultHandler );
					break;

				// Change the preferred dialog type
				case _buttons[6]:
					
					switch (_dialogType)
					{
						case FacebookDialogType.NATIVE:
							_dialogType = FacebookDialogType.OS_INTEGRATED;
							break;
						
						case FacebookDialogType.OS_INTEGRATED:
							_dialogType = FacebookDialogType.WEB;
							break;
						
						case FacebookDialogType.WEB:
							_dialogType = FacebookDialogType.NATIVE;
							break;
						
					}
					
					trace( "Preferred dialog type: " + _dialogType); 
					FacebookAPI.service.setPreferredDialogType( _dialogType );
					break;
				
				// Logout
				case _buttons[7]:
					FacebookAPI.service.closeSession( true );
					break;
				
			}
		}
		
		private function dialogResultHandler( data:Object, error:String ):void
		{
			if (data)
			{
				trace("Dialog completed");
			}
			else
			{
				trace("Dialog error: " + error);
			}
		}
		
		private function permissionsResultHandler( event:FacebookAPIEvent ):void
		{
			trace("Loaded permissions: " + event.data.permissions.join(","));
		}
		
		
		private function session_openedHandler( event:FacebookAPIEvent ):void
		{
			trace("Session Opened!");
			if (event.data)
			{
				trace("> " + event.data.accessToken);
				trace("> " + event.data.userId);
				trace("> " + event.data.userName);
				trace("> " + event.data.firstName);
				trace("> " + event.data.lastName);
				trace("> " + event.data.expiry);
			}
		}
		
		private function session_closedHandler( event:FacebookAPIEvent ):void
		{
			trace("Session Closed!");	
		}
		
		private function session_openDisabledHandler( event:FacebookAPIEvent ):void
		{
			trace("Session Open failed - application is disabled!");
		}
		
		private function session_openErrorHandler( event:FacebookAPIEvent ):void
		{
			trace("Session Open error - " + event.error);
		}
		
		private function appRequestsFoundHandler( event:FacebookAppRequestEvent ):void
		{
			trace("Found app requests: " + event.requestIds.join(", "));
		}
		
		private function appRequestsDataHandler( event:FacebookAppRequestEvent ):void
		{
			trace("Found app request data!");
			for each (var r:FacebookAppRequestInfo in event.requests)
			{
				trace("R id: " + r.requestId);
				trace("From: " + r.fromUserName);
				trace("Data: " + r.data);
			}
		}
		
		private function dialog_completedHandler( event:FacebookAPIEvent ):void
		{
			// Dialog completed
		}
		
		private function dialog_cancelledHandler( event:FacebookAPIEvent ):void
		{
			// The user cancelled the dialog
		}
		
		private function dialog_errorHandler( event:FacebookAPIEvent ):void
		{
			// An error occurred
			trace(" Dialog error: " + event.error );
		}
		
		private function actionIdsFoundHandler( event:FacebookOpenGraphActionEvent ):void
		{
			trace("Action IDs: " + event.actionIds.join(","));
		}
		
		private function appInvokedHandler( event:FacebookAPIEvent ):void
		{
			message( "App invoked: " + event.data.targetUrl + ", " + event.data.sourceApplication);
		}
		
		
		
		//
		//	INTERNALS
		//
		
		private function message( str:String ):void
		{
			trace( str );
			_text.appendText(str+"\n");
		}
		
		
		private function createUI( ):void
		{
			_text.text = "Ready";
			
			for each (var b:Sprite in _buttons)
			{
				b.removeEventListener( MouseEvent.CLICK, mouseClickHandler, false );
				if (contains(b)) removeChild(b);
				b = null;
			}
			
			_buttons = [];
			
			_buttons.push( createButton("Init Facebook") );
			_buttons.push( createButton("Open Session") );
			_buttons.push( createButton("Session Check") );
			_buttons.push( createButton("Request Perms") );
			_buttons.push( createButton("Get Perms") );
			_buttons.push( createButton("Share Dialog") );
			_buttons.push( createButton("Change Dlg Type") );
			_buttons.push( createButton("Logout") );
			
			for each (var b:Sprite in _buttons)
			{	
				addChild( b );
				b.addEventListener( MouseEvent.CLICK, mouseClickHandler, false, 0, true );
			}
			
			layout();
		}
		
		
		private function onStageResize(event:Event):void
		{
			createUI();
		}	
		
		
		private function layout():void
		{
			var xp:Number = 10;
			var yp:Number = stage.stageHeight * 0.5;
			
			for (var i:int = 0; i < _buttons.length; i++)
			{
				_buttons[i].x = xp;
				_buttons[i].y = yp;
				
				xp += _buttons[i].width * 1.1;
				if (xp > (stage.stageWidth - (_buttons[i].width * 1.1)))
				{
					yp += _buttons[i].height * 1.25;
					xp = 10;
				}
			}
		}
		
		
		private function createButton( label:String ):Sprite
		{
			var s:Sprite = new Sprite();
			
			s.graphics.lineStyle( 1, 0x0000FF );
			s.graphics.beginFill(0x222222, 1);
			s.graphics.drawRoundRect(0, 0, stage.stageWidth*0.22, stage.stageHeight*0.075, 7, 7);
			s.graphics.endFill();
			
			var t:TextField = new TextField();
			t.text = label;
			
			var tf:TextFormat = t.defaultTextFormat;
			tf.size = int(stage.stageWidth/42);
			tf.font = "Helvetica";
			tf.align = TextFormatAlign.CENTER;
			t.setTextFormat(tf);
			
			t.textColor = 0xFFFFFF;
			t.selectable = false;
			t.mouseEnabled = false;
			t.width = s.width*0.95;
			t.height = s.height;
			t.x = (s.width * 0.025);
			t.y = (s.height * 0.5) - (t.textHeight*0.5);
			
			s.addChild( t );
			return s;
		}
		
		
	}
}


