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
	import com.distriqt.extension.dialog.Dialog;
	import com.distriqt.extension.dialog.DialogTheme;
	import com.distriqt.extension.dialog.events.DialogDateTimeEvent;
	import com.distriqt.extension.dialog.events.DialogEvent;
	import com.distriqt.extension.dialog.events.PopoverEvent;
	import com.distriqt.extension.dialog.objects.DateTimePickerOptions;
	import com.distriqt.extension.dialog.objects.PopoverOptions;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	
	/**	
	 * @author	Michael Archbold
	 */
	public class TestDialog extends Sprite
	{
		public static const DEV_KEY : String = "YOUR_DEVELOPER_KEY";	
		
		/**
		 * Class constructor 
		 */	
		public function TestDialog( devKey:String = DEV_KEY )
		{
			super();
			_devKey = devKey;
			create();
			init();
		}
		
		
		//
		//	VARIABLES
		//
		private var _devKey		: String = "";
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
			_text.y = 40;
			_text.defaultTextFormat = tf;
			addChild( _text );

			stage.addEventListener( Event.RESIZE, stage_resizeHandler, false, 0, true );
			stage.addEventListener( MouseEvent.CLICK, mouseClickHandler, false, 0, true );
		}
		
		
		private function init( ):void
		{
			try
			{
				Dialog.init( _devKey );
				
				message( "Dialog Supported: "+ String(Dialog.isSupported) );
				message( "Dialog Version: " + Dialog.service.version );
				
				Dialog.service.addEventListener( DialogEvent.DIALOG_CLOSED, dialog_dialogClosedHandler, false, 0, true );
				Dialog.service.addEventListener( DialogEvent.DIALOG_CANCELLED, dialog_dialogCancelledHandler, false, 0, true );
				
				Dialog.service.addEventListener( DialogDateTimeEvent.DATE_CHANGED, dialog_dateChangedHandler, false, 0, true );
				Dialog.service.addEventListener( DialogDateTimeEvent.DATE_SELECTED, dialog_dateSelectedHandler, false, 0, true );
				Dialog.service.addEventListener( DialogDateTimeEvent.TIME_SELECTED, dialog_timeSelectedHandler, false, 0, true );

				Dialog.service.addEventListener( PopoverEvent.POPOVER_CLOSED, popover_closedHandler, false, 0, true );
				Dialog.service.addEventListener( PopoverEvent.POPOVER_CHANGE, popover_changeHandler, false, 0, true );
				
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
		
		private function stage_resizeHandler( event:Event ):void
		{
			_text.width  = stage.stageWidth;
			_text.height = stage.stageHeight - 100;
		}
		
		
		private function mouseClickHandler( event:MouseEvent ):void
		{
//			stage.removeEventListener( MouseEvent.CLICK, mouseClickHandler );
			
//			showAlertDialog();
//			showMultipleChoiceDialog();
//			showProgressDialog();
			showDateTimePicker();
//			showSelectListPopover();
//			showTextInputAlertDialog();
//			setTimeout( dismissAllDialogs, 2000 );
		}
		
		
		//
		//	EXAMPLES
		//
		
		private function showAlertDialog():void
		{
			//
			//	EXAMPLE A
			//		Show an alert dialog
			//	
			
			var titleString:String = "test";
			var messageString:String = "";
			var cancelLabel:String = "cancel";
			var otherLabels:Array = ["other 1", "other 2"];
			
			// Add some random otherLabels
			var extraButtonCount:int = Math.ceil( Math.random()*5 );
			for (var i:int = 0; i < extraButtonCount; i++)
			{
				otherLabels.push( "button " +String(i+1) ); 
			}
			
			message( "showAlertDialog("+titleString+","+messageString+","+cancelLabel+","+otherLabels.join(",")+")");
//			Dialog.service.showAlertDialog( 0, titleString+"0", messageString, cancelLabel, otherLabels );
			Dialog.service.showAlertDialog( 0, titleString, messageString, cancelLabel, ["OK!"] );
		
//			var otherLabels:Array = ["1 Star", "2 Stars", "3 Stars", "4 Stars"];
//			Dialog.service.showMultipleChoiceDialog(0, "How did you like the Coco Loco from Arcadia Breweing?", "",  otherLabels);
			
//			setInterval( dismissDialog, 2000 );
		}
		
		
		private function showMultipleChoiceDialog():void
		{
			//
			//	EXAMPLE 
			//		Show a multiple choice dialog
			//	
			
			var titleString:String = "Dialog Title";
			var messageString:String = "This is the message text";
			var cancelLabel:String = "cancel";
			var otherLabels:Array = ["other 1", "other 2"];
			
			message( "showMultipleChoiceDialog("+titleString+","+messageString+","+otherLabels.join(",")+")");
			Dialog.service.showMultipleChoiceDialog( 1, titleString+"1", messageString, otherLabels );
			
		}
		
		
		private function showProgressDialog():void
		{
			//
			//	EXAMPLE B
			//		Progress Dialog example
			//
			clearInterval( progressInterval );
			Dialog.service.dismissProgressDialog(1);
			if (Dialog.service.showProgressDialog( 1, "Loading\ntest test test test test test test", "Second\n Message", Dialog.DIALOG_PROGRESS_STYLE_DETERMINATE, true, DialogTheme.THEME_LIGHT ))
			{
				progress = 0;
				progressInterval = setInterval( progressDialogIntervalHandler, 2000 );
			}
			else
			{
				message( "Progress Dialog not supported" );
			}
		}
		
		
		private function showDateTimePicker():void
		{
			//
			//	EXAMPLE C
			//		Date / Time picker
			
			var dtOptions:DateTimePickerOptions = new DateTimePickerOptions();
//			dtOptions.acceptLabel = "DO IT";
			
			dtOptions.year = 2014;
			dtOptions.month = 10;
			dtOptions.day = 5;
			dtOptions.hour = 10;
			dtOptions.minute = 0;
			dtOptions.cancelOnTouchOutside = false;
			
			
			Dialog.service.showDateTimePicker( 1, dtOptions );
			
//			dtOptions.title = "Select Date";
//			Dialog.service.showDatePicker( 1, dtOptions );
//			setTimeout( function():void {
//					Dialog.service.setDateTimePickerValue( 1, 2016, 2, 10, true );
//				}, 2000 );
			
//			setTimeout( function():void {
//					Dialog.service.dismissDatePicker( 1 );
//				}
//				, 4000 );
			
//			dtOptions.title = "Select Time";
//			Dialog.service.showTimePicker( 2, dtOptions );
//			setTimeout( function():void {
//					Dialog.service.setDateTimePickerValue( 1, 2030, 2, 10 );
//				}
//				, 3000 );
		}
		
		private function showSelectListPopover():void
		{
			//
			//	EXAMPLE D
			//		Select List Popover
			
			
			var options:PopoverOptions = new PopoverOptions();
//			options.position = new Rectangle( 100, 500, 300, 100 );
//			options.size = new Rectangle( 0, 0, 400, 400 );
			options.position = new Rectangle( 50, 250, 150, 50 );
			options.size = new Rectangle( 0, 0, 300, 350 );
			options.autoScale = false;
			options.showNavigationBar = false;
			options.multiSelect = false;
			options.arrowDirection = PopoverOptions.ARROW_DIRECTION_LEFT;
			
			Dialog.service.showSelectPopover( 1, "Genres", ["All", "Punk", "Rock", "ATTACK OF THE CLONES"], options, [ 1 ] );
			
			graphics.beginFill( 0xFF0000 );
			graphics.drawRect( options.position.x, options.position.y, options.position.width, options.position.height );
			graphics.endFill();
			
		}
		
		
		private function showTextInputAlertDialog():void
		{
			Dialog.service.showTextInputAlertDialog( 999, "Add server", "Please add server url.", false, "Cancel", ["OK"] );
		}
		
		
		
		//
		//	PROGRESS DIALOG EXAMPLE HANDLERS
		//
		
		private var progressInterval:uint;
		private var progress:Number = 0;
		
		private function progressDialogIntervalHandler():void
		{
			// Update the progress dialog
			progress += 0.01;
			Dialog.service.updateProgressDialog( 1, progress );
			
//			clearInterval( progressInterval );
//			Dialog.service.dismissProgressDialog(1);
		}
		
		
		private function dismissDialog():void
		{
			Dialog.service.dismissDialog( 2 );
		}
		
		
		private function dismissAllDialogs():void
		{
			Dialog.service.dismissAllDialogs();
		}
		
		
		//
		//	DIALOG NOTIFICATION HANDLERS
		//
		
		private function dialog_dialogClosedHandler( event:DialogEvent ):void
		{
			message( "Dialog Closed: id="+event.id +" button="+event.data );
			clearInterval( progressInterval );
		}
		
		private function dialog_dialogCancelledHandler( event:DialogEvent ):void
		{
			message( "Dialog Cancelled: id="+event.id +" data="+event.data );
			clearInterval( progressInterval );
		}
	
		
		private function dialog_dateChangedHandler( event:DialogDateTimeEvent ):void
		{
			message( "Dialog date changed: " + event.date.toDateString() + " :: " + event.date.toTimeString() );
		}
		
		private function dialog_dateSelectedHandler( event:DialogDateTimeEvent ):void
		{
			message( "Dialog date selected: " + event.date.toDateString() + " :: " + event.date.toTimeString() );
		}
		
		private function dialog_timeSelectedHandler( event:DialogDateTimeEvent ):void
		{
			message( "Dialog time selected: "+ event.date.toTimeString() ) ;
		}
		
		

		private function popover_changeHandler( event:PopoverEvent ):void
		{
//			Dialog.service.dismissPopover( 1 );
		}
		
		private function popover_closedHandler( event:PopoverEvent ):void
		{
			message( "Popover Closed: "+event.id +" selection: "+event.selection.join(",") );
		}
	}
}

