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
	import com.distriqt.extension.image.Image;
	import com.distriqt.extension.image.ImageFormat;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	
	/**	
	 * Sample application for using the Image Native Extension
	 * 
	 * @author	Michael Archbold
	 */
	public class TestImage extends Sprite
	{
		public static const DEV_KEY : String = "your_dev_key";
		
		[Embed("test.png")]
		public var Icon:Class;
		
		/**
		 * Class constructor 
		 */	
		public function TestImage()
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
				Image.init( DEV_KEY );
				
				message( "Image Supported: " + Image.isSupported );
				message( "Image Version:   " + Image.service.version );
				
				//
				//	Add test inits here
				
				var icon:Bitmap = new Icon() as Bitmap;
				
				var encodedData:ByteArray = new ByteArray();

//				Image.service.encode( icon.bitmapData, encodedData, ImageFormat.PNG ); 
				Image.service.encode( icon.bitmapData, encodedData, ImageFormat.JPG, 0.2 ); 
				
				message( "encoded length: "+encodedData.length );
				
				var loader:Loader = new Loader();
				loader.loadBytes( encodedData );
				addChild( loader );
			}
			catch (e:Error)
			{
				message( e.message );
			}
		}

		
		private function doTest():void
		{
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
			doTest();
		}
		
		
		private function activateHandler( event:Event ):void
		{
		}
		
		private function deactivateHandler( event:Event ):void
		{
		}
		
		
		//
		//	EXTENSION HANDLERS
		//
		
		
	}
}

