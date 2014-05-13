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
	import com.distriqt.extension.pdfreader.PDFReader;
	import com.distriqt.extension.pdfreader.events.PDFReaderEvent;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	/**	
	 * Sample application for using the PDFReader Native Extension
	 * 
	 * @author	Michael Archbold
	 */
	public class TestPDFReader extends Sprite
	{
		public static const DEV_KEY : String = "YOUR_DEVELOPER_KEY";
		
		/**
		 * Class constructor 
		 */	
		public function TestPDFReader(devKey:String=DEV_KEY)
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

			stage.addEventListener( Event.RESIZE, stage_resizeHandler, false, 0, true );
		}
		
		
		private function init( ):void
		{
			try
			{
				PDFReader.init( _devKey );
				
				message( "PDFReader Supported: " + PDFReader.isSupported );
				message( "PDFReader Version:   " + PDFReader.service.version );
				
				if (PDFReader.isSupported)
				{
					PDFReader.service.addEventListener( PDFReaderEvent.OPENED, pdfreader_openedHandler, false, 0, true );
					PDFReader.service.addEventListener( PDFReaderEvent.CLOSED, pdfreader_closedHandler, false, 0, true );
				
					stage.addEventListener( MouseEvent.CLICK, mouseClickHandler, false, 0, true );
				}
				
				//
				//	Add test inits here
				//
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
		}
		
		
		private function mouseClickHandler( event:MouseEvent ):void
		{
			//
			// Show a PDF
			
			var path:String = File.applicationDirectory.nativePath + File.separator + "TestDocument.pdf";
			
			PDFReader.service.setToolbarOptions( false, false, false );
			PDFReader.service.setEmailContent( "Test Subject", "Some simple content" );
			PDFReader.service.showPDF( path );
		}
		
		
		
		//
		//	EXTENSION HANDLERS
		//
		

		private function pdfreader_openedHandler( event:PDFReaderEvent ):void
		{
			message( "opened" );
		}
		
		
		private function pdfreader_closedHandler( event:PDFReaderEvent ):void
		{
			message( "closed" );
		}
		
	}
}

