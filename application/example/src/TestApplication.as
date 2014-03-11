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
 * This is a test application for the distriqt Application extension
 * 
 * @author Michael Archbold & Shane Korin
 * 	
 */
package
{
	import com.distriqt.extension.application.Application;
	import com.distriqt.extension.application.ApplicationDisplayModes;
	import com.distriqt.extension.application.Device;
	import com.distriqt.extension.application.IOSStatusBarStyles;
	import com.distriqt.extension.application.events.ApplicationEvent;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	/**	
	 * Sample application for using the Application Native Extension
	 * 
	 * @author	Michael Archbold
	 */
	public class TestApplication extends Sprite
	{
		public static const DEV_KEY : String = "YOUR_DEVELOPER_KEY";
		
		
		/**
		 * Class constructor 
		 */	
		public function TestApplication()
		{
			super();
			create();
			init();
		}
		
		
		//
		//	VARIABLES
		//
		
		private var _text		: TextField;
		
		private var _autoStartEnabled 	: Boolean = false;
		private var _displayMode		: String = ApplicationDisplayModes.NORMAL;
		
		//
		//	INITIALISATION
		//	
		
		private function create():void
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
		
		
		private function init():void
		{
			try
			{
				Application.init( DEV_KEY );
				
				message( "Application Supported: "+ String(Application.isSupported) );
				message( "Application Version: " + Application.service.version );
				
				message( "Device Unique ID: " + Application.service.device.uniqueId() );
				
				//
				//	SET APPLICATION TO AUTOSTART
				//
				Application.service.addEventListener( ApplicationEvent.UI_NAVIGATION_CHANGED, application_uiNavigationChangedHandler, false, 0, true );
//				Application.service.setAutoStart( _autoStartEnabled );
				
//				Application.service.setStatusBarHidden( false );
//				Application.service.setStatusBarStyle( IOSStatusBarStyles.IOS_STATUS_BAR_LIGHT );
				
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
			
			graphics.clear();
			graphics.lineStyle( 2, 0xFF0000 );
			graphics.drawRect( 0, 0, stage.stageWidth, stage.stageHeight );
		}
		
		
		
		
		private function mouseClickHandler( event:MouseEvent ):void
		{
			//
			//	Change the Auto Start state
			//	
			
//			_autoStartEnabled = !_autoStartEnabled;
//			Application.service.setAutoStart( _autoStartEnabled );
			
			message( "auto start enabled : "+ Application.service.isAutoStartEnabled() );
			
			
			//
			//	Switch the display mode
			//
			
			switch (_displayMode)
			{
				
				case ApplicationDisplayModes.UI_NAVIGATION_HIDE:
					_displayMode = ApplicationDisplayModes.UI_NAVIGATION_LOW_PROFILE;
					break;
				
				case ApplicationDisplayModes.UI_NAVIGATION_LOW_PROFILE:
					_displayMode = ApplicationDisplayModes.UI_NAVIGATION_VISIBLE;
					break;

				case ApplicationDisplayModes.UI_NAVIGATION_VISIBLE:
					_displayMode = ApplicationDisplayModes.FULLSCREEN;
					break;
				
				case ApplicationDisplayModes.FULLSCREEN:
					_displayMode = ApplicationDisplayModes.NORMAL;
					break;
				
				case ApplicationDisplayModes.NORMAL:
					_displayMode = ApplicationDisplayModes.UI_NAVIGATION_HIDE;
					break;
				
			}
			
			message( "displayMode : "+_displayMode );
			Application.service.setDisplayMode( _displayMode );
		
		}
		
		
		
		//
		//	NOTIFICATION HANDLERS
		//
		
		private function activateHandler( event:Event ):void
		{
			trace( "activateHandler() ");
		}
		
		private function deactivateHandler( event:Event ):void
		{
			trace( "deactivateHandler() ");
		}
		
		
		private function application_uiNavigationChangedHandler( event:ApplicationEvent ):void
		{
			message( event.type + "::"+event.option );
		}

		
	}
}

