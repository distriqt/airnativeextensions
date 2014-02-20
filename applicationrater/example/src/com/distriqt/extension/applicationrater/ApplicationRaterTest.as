package com.distriqt.extension.applicationrater
{
	import com.distriqt.extension.applicationrater.ApplicationRater;
	import com.distriqt.extension.applicationrater.events.ApplicationRaterEvent;

	public class ApplicationRaterTest
	{
		
		public function ApplicationRaterTest( DEV_KEY:String )
		{
			try
			{
				//
				//	Initialise the extension
				ApplicationRater.init( DEV_KEY );
				
				//
				//	Print out version, supported and state
				trace( "ApplicationRater Supported: "+ String(ApplicationRater.isSupported) );
				trace( "ApplicationRater Version: " + ApplicationRater.service.version );
				trace( "ApplicationRater State: " + ApplicationRater.service.state );
				
				//
				//	Add rater event listeners
				ApplicationRater.service.addEventListener( ApplicationRaterEvent.DIALOG_DISPLAYED, applicationRater_dialogDisplayedHandler, false, 0, true );
				ApplicationRater.service.addEventListener( ApplicationRaterEvent.DIALOG_CANCELLED, applicationRater_dialogCancelledHandler, false, 0, true );
				ApplicationRater.service.addEventListener( ApplicationRaterEvent.SELECTED_RATE, applicationRater_selectedRateHandler, false, 0, true );
				ApplicationRater.service.addEventListener( ApplicationRaterEvent.SELECTED_LATER, applicationRater_selectedLaterHandler, false, 0, true );
				ApplicationRater.service.addEventListener( ApplicationRaterEvent.SELECTED_DECLINE, applicationRater_selectedDeclineHandler, false, 0, true );
				
				
				//
				//	Set some options
				ApplicationRater.service.setSignificantEventsUntilPrompt( 5 );
				ApplicationRater.service.setApplicationId( "air.com.distriqt.test" );

				
				//
				//	Update the application launch count
				ApplicationRater.service.applicationLaunched();
				
			}
			catch (e:Error)
			{
				trace( "ERROR::"+e.message );
			}	
			
		}
		
		
		
		
		private function applicationRater_dialogDisplayedHandler( event:ApplicationRaterEvent ):void
		{
			trace( event.type );
		}
		
		private function applicationRater_dialogCancelledHandler( event:ApplicationRaterEvent ):void
		{
			trace( event.type );
		}
		
		private function applicationRater_selectedRateHandler( event:ApplicationRaterEvent ):void
		{
			trace( event.type );
		}
		
		private function applicationRater_selectedLaterHandler( event:ApplicationRaterEvent ):void
		{
			trace( event.type );
		}
		
		private function applicationRater_selectedDeclineHandler( event:ApplicationRaterEvent ):void
		{
			trace( event.type );
		}
		
		
	}
}