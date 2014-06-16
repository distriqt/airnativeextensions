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
	import com.distriqt.extension.scanner.Scanner;
	import com.distriqt.extension.scanner.ScannerInfo;
	import com.distriqt.extension.scanner.ScannerOptions;
	import com.distriqt.extension.scanner.Symbology;
	import com.distriqt.extension.scanner.events.ScannerEvent;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	
	/**	
	 * Sample application for using the Scanner Native Extension
	 * 
	 * @author	Michael Archbold
	 */
	public class TestScanner extends Sprite
	{
		public static const DEV_KEY : String = "YOUR_DEVELOPER_KEY";		
		
		/**
		 * Class constructor 
		 */	
		public function TestScanner( devKey:String = DEV_KEY)
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
			stage.addEventListener( MouseEvent.CLICK, mouseClickHandler, false, 0, true );
			
			addEventListener( Event.ACTIVATE, activateHandler, false, 0, true );
			addEventListener( Event.DEACTIVATE, deactivateHandler, false, 0, true );
		}
		
		
		private function init( ):void
		{
			try
			{
				Scanner.init( _devKey );
				
				message( "Scanner Supported: " + Scanner.isSupported );
				message( "Scanner Version:   " + Scanner.service.version );
				
				//
				//	Add test inits here
				//
				
				Scanner.service.addEventListener( ScannerEvent.CODE_FOUND, scanner_codeFoundHandler, false, 0, true );
				Scanner.service.addEventListener( ScannerEvent.SCAN_START, scanner_startHandler, false, 0, true );
				Scanner.service.addEventListener( ScannerEvent.SCAN_STOPPED, scanner_stopHandler, false, 0, true );
				Scanner.service.addEventListener( ScannerEvent.CANCELLED, scanner_cancelledHandler, false, 0, true );
				
				var info:ScannerInfo  = Scanner.service.getScannerInfo();
				message( "info: "+info.algorithm + " ["+info.version+"]" );
				
			}
			catch (e:Error)
			{
				message( "ERROR::" + e.message );
			}
		}
		
		
		//
		//	FUNCTIONALITY
		//
		
		private function message( str:String ):void
		{
			trace( str );
			_text.text = (str+"\n") + _text.text;
		}
		
		
		private function stopScan():void
		{
			Scanner.service.stopScan();
		}
		
		
		private var _timeout:int = 0;
		
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
			message( "click" );
			
			init();
			
			//
			//	Do something when user clicks screen?
			//
			
			var options:ScannerOptions = new ScannerOptions();
			options.singleResult = false;
			options.heading = "Scan a barcode";
//			options.message = "A big message";
//			options.cancelLabel = "FINISH";
			
			options.colour = 0x4863A0;
			options.textColour = 0xFFFFFF;
			
			options.x_density = 1;
			options.y_density = 1;
			
			options.symbologies = [ Symbology.QRCODE ];
			
			options.refocusInterval = 0;
			
			var success:Boolean = Scanner.service.startScan( options );
			
			message( "scan started = " + success );
			
//			_timeout = setTimeout( stopScan, 10000 );
		}
		
		
		private function activateHandler( event:Event ):void
		{
			trace( "activateHandler() ");
		}
		
		private function deactivateHandler( event:Event ):void
		{
			trace( "deactivateHandler() ");
		}

		
		//
		//	EXTENSION HANDLERS
		//
		
		
		private function scanner_startHandler( event:ScannerEvent ):void
		{
			message( event.type );
		}
		

		private function scanner_stopHandler( event:ScannerEvent ):void
		{
			message( event.type );

			clearTimeout(_timeout);
			
			//
			//	Clean up 
			Scanner.service.removeEventListener( ScannerEvent.CODE_FOUND, scanner_codeFoundHandler );
			Scanner.service.removeEventListener( ScannerEvent.SCAN_START, scanner_startHandler );
			Scanner.service.removeEventListener( ScannerEvent.SCAN_STOPPED, scanner_stopHandler );
			Scanner.service.removeEventListener( ScannerEvent.CANCELLED, scanner_cancelledHandler );
			Scanner.service.dispose();
		}

		
		private function scanner_cancelledHandler( event:ScannerEvent ):void
		{
			message( event.type );
		}

		
		private function scanner_codeFoundHandler( event:ScannerEvent ):void
		{
			message( "code found: " + event.data );
		}

		
	}
}

