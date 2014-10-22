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
	import com.distriqt.extension.applicationrater.ApplicationRater;
	import com.distriqt.extension.applicationrater.events.ApplicationRaterEvent;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	/**	
	 * Sample application for using the ApplicationRater Native Extension
	 * 
	 * @author	Michael Archbold
	 */
	public class TestApplicationRater extends Sprite
	{
		public static const DEV_KEY : String = "YOUR_DEVELOPER_KEY";

		
		/**
		 * Class constructor 
		 */	
		public function TestApplicationRater( devKey:String = DEV_KEY )
		{
			super();
			_devKey = devKey;
			create();
			init();
		}
		
		
		//
		//	VARIABLES
		//
		
		private var _devKey		: String;
		
		private var _text		: TextField;
		
		
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

			if (stage) 	addedToStageHandler(null);
			else 		stage.addEventListener( Event.RESIZE, addedToStageHandler, false, 0, true );
			stage.addEventListener( MouseEvent.CLICK, mouseClickHandler, false, 0, true );
			
		}
		
		
		private function init( ):void
		{
			try
			{
				ApplicationRater.init( _devKey );
				
				message( "ApplicationRater Supported: "+ String(ApplicationRater.isSupported) );
				message( "ApplicationRater Version: " + ApplicationRater.service.version );
				message( "ApplicationRater State: " + ApplicationRater.service.state );
				
//				ApplicationRater.service.reset();

				//
				//	Setup the app rater service, listeners and register the app launch
				//
				ApplicationRater.service.setLaunchesUntilPrompt( 2 );
				ApplicationRater.service.setSignificantEventsUntilPrompt( 5 );
				
				ApplicationRater.service.addEventListener( ApplicationRaterEvent.DIALOG_DISPLAYED, applicationRater_dialogDisplayedHandler, false, 0, true );
				ApplicationRater.service.addEventListener( ApplicationRaterEvent.DIALOG_CANCELLED, applicationRater_dialogCancelledHandler, false, 0, true );
				ApplicationRater.service.addEventListener( ApplicationRaterEvent.SELECTED_RATE, applicationRater_selectedRateHandler, false, 0, true );
				ApplicationRater.service.addEventListener( ApplicationRaterEvent.SELECTED_LATER, applicationRater_selectedLaterHandler, false, 0, true );
				ApplicationRater.service.addEventListener( ApplicationRaterEvent.SELECTED_DECLINE, applicationRater_selectedDeclineHandler, false, 0, true );
				
				ApplicationRater.service.setApplicationId( "air.com.distriqt.test", ApplicationRater.IMPLEMENTATION_ANDROID );
				ApplicationRater.service.setApplicationId( "552872162", ApplicationRater.IMPLEMENTATION_IOS );
//				ApplicationRater.service.debugMode = true;
				ApplicationRater.service.applicationLaunched();
			}
			catch (e:Error)
			{
				message( "ERROR::"+e.message );
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
		
		private function addedToStageHandler( event:Event ):void
		{
			_text.width  = stage.stageWidth;
			_text.height = stage.stageHeight - 100;
		}
		
		
		private function mouseClickHandler( event:MouseEvent ):void
		{
			//
			//	Do something when user clicks screen?
			//	
			try
			{
				ApplicationRater.service.userDidSignificantEvent();
			}
			catch (e:Error)
			{
				message( "ERROR::"+e.message );
			}
		}
		
		
		
		//
		//	APPLICATION RATER NOTIFICATION HANDLERS
		//
		
		private function applicationRater_dialogDisplayedHandler( event:ApplicationRaterEvent ):void
		{
			message( event.type );
		}

		private function applicationRater_dialogCancelledHandler( event:ApplicationRaterEvent ):void
		{
			message( event.type );
		}

		private function applicationRater_selectedRateHandler( event:ApplicationRaterEvent ):void
		{
			message( event.type );
		}

		private function applicationRater_selectedLaterHandler( event:ApplicationRaterEvent ):void
		{
			message( event.type );
		}

		private function applicationRater_selectedDeclineHandler( event:ApplicationRaterEvent ):void
		{
			message( event.type );
		}

	}
}

