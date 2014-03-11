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
	import com.distriqt.extension.calendar.Calendar;
	import com.distriqt.extension.calendar.Recurrence;
	import com.distriqt.extension.calendar.events.CalendarStatusEvent;
	import com.distriqt.extension.calendar.objects.*;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	/**	
	 * Sample application for using the Calendar Native Extension
	 * 
	 * @author	Michael Archbold
	 */
	public class TestCalendar extends Sprite
	{
		public static const DEV_KEY : String = "YOUR_DEVELOPER_KEY";
		
		/**
		 * Class constructor 
		 */	
		public function TestCalendar()
		{
			super();
			create();
			init();
		}
		
		
		//
		//	VARIABLES
		//
		
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

			stage.addEventListener( Event.RESIZE, stage_resizeHandler, false, 0, true );
			stage.addEventListener( MouseEvent.CLICK, mouseClickHandler, false, 0, true );
		}
		
		
		private function init( ):void
		{
			try
			{
				Calendar.init( DEV_KEY );
				
				Calendar.service.addEventListener( CalendarStatusEvent.ACCESS_GRANTED, calendar_accessGrantedHandler, false, 0, true );
				Calendar.service.addEventListener( CalendarStatusEvent.ACCESS_DENIED,  calendar_accessDeniedHandler, false, 0, true );
				
				Calendar.service.addEventListener( CalendarStatusEvent.UI_SAVE, 	calendar_uiHandler, false, 0, true );
				Calendar.service.addEventListener( CalendarStatusEvent.UI_CANCEL,  	calendar_uiHandler, false, 0, true );
				Calendar.service.addEventListener( CalendarStatusEvent.UI_DELETE,  	calendar_uiHandler, false, 0, true );
				
				message( "Calendar Supported: "+ String(Calendar.isSupported) );
				message( "Calendar Version: " + Calendar.service.version );
			}
			catch (e:Error)
			{
				
			}
		}
		
		
		//
		//	FUNCTIONALITY 
		//
		
		
		private function testCalendar():void
		{
			//
			//	GET LIST OF CALENDARS
			
			var calendarId:String = "";
			var calendars:Array = Calendar.service.getCalendars();
			
			for each (var cal:CalendarObject in calendars)
			{
				message( "CALENDAR: ["+cal.id+"] "+cal.displayName + "("+cal.name+")");
				if (cal.displayName.toLowerCase() == "test")
				{
					calendarId = cal.id;
					message( "USING : "+calendarId );
				}
			}

			
			//
			//	CREATE AN EVENT
			var e:EventObject = new EventObject();
			e.title = "Test title now";
			e.startDate = new Date() ;
			e.endDate = new Date();
			e.startDate.minutes = e.startDate.minutes + 6;
			e.endDate.hours = e.endDate.hours+1;
//			e.allDay = true;
			e.calendarId = calendarId;
			
//			var a:EventAlarmObject = new EventAlarmObject();
//			a.offset = -300;
//			e.alarms.push( a );

//			var r:Recurrence = new Recurrence();
//			r.endCount = 5;
//			r.interval = 1;
//			r.frequency = Recurrence.FREQUENCY_DAILY;
//			
//			e.recurrenceRules.push( r );

			
			
			//
			//	ADD EVENT
			message( "ADDING: "+e.startDateString + " :: " + e.title );
//			Calendar.service.addEventWithUI( e );
			Calendar.service.addEvent( e );
			
			
			//
			// 	GET EVENTS
			var startDate:Date = new Date();
			startDate.date -= 1;
			var endDate:Date = new Date();
			endDate.date += 1;
			
			var events:Array = Calendar.service.getEvents( startDate, endDate  );
			
			for each (var evt:EventObject in events)
			{
				message( "["+evt.id+"] in "+evt.calendarId+" @ "+ evt.startDateString + " :: " + evt.title );
				for each (var alarm:EventAlarmObject in evt.alarms)
				{
//					message( "\tALARM: "+alarm.offset );
				}
				for each (var rule:Recurrence in evt.recurrenceRules)
				{
//					message( "\tRRULE: "+rule.notes );
				}
				
				if (evt.title == "Test title now")
				{
					message( "REMOVING" );
					Calendar.service.removeEvent( evt );
				}
			}
			
		}
		
		
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
			//	First lets request access to the calendar and make sure the user has allowed us to use it
			Calendar.service.requestAccess();
		}
		
		
		
		
		private function calendar_accessGrantedHandler( event:CalendarStatusEvent ):void
		{
			message( "GRANTED" );
			
			//
			//	Now lets try to create an event
			testCalendar();
		}
		
		
		private function calendar_accessDeniedHandler( event:CalendarStatusEvent ):void
		{
			message( "DENIED" );
			
			//
			//	See what happens if you add an event with a denied calendar access under iOS
			//	You should see a message along the lines of "This app does not have access to your calendars"
			//	and the user will be forced to press "Cancel"
			testCalendar();
		}
		
		
		private function calendar_uiHandler( event:CalendarStatusEvent ):void
		{
			switch (event.type)
			{
//				case CalendarStatusEvent.UI_SAVE:
//				case CalendarStatusEvent.UI_CANCEL:
//				case CalendarStatusEvent.UI_DELETE:
//					break;
				
				default:
					message( event.type );
			}
		}
		
		
		
		
	}
}

