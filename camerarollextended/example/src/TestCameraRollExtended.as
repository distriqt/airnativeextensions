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
	import com.distriqt.extension.camerarollextended.Asset;
	import com.distriqt.extension.camerarollextended.AssetRepresentation;
	import com.distriqt.extension.camerarollextended.CameraRollExtended;
	import com.distriqt.extension.camerarollextended.CameraRollExtendedBrowseOptions;
	import com.distriqt.extension.camerarollextended.events.CameraRollExtendedEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	
	
	/**	
	 * Sample application for using the CameraRollExtended Native Extension
	 * 
	 * @author	Michael Archbold
	 */
	public class TestCameraRollExtended extends Sprite
	{
		public static const DEV_KEY : String = "YOUR_DEVELOPER_KEY";	
		
		/**
		 * Class constructor 
		 */	
		public function TestCameraRollExtended()
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
				CameraRollExtended.init( DEV_KEY );
				
				message( "CameraRollExtended Supported: " + CameraRollExtended.isSupported );
				message( "CameraRollExtended Version:   " + CameraRollExtended.service.version );
				
				
				CameraRollExtended.service.addEventListener( CameraRollExtendedEvent.CANCEL, cameraRoll_cancelHandler, false, 0, true );
				CameraRollExtended.service.addEventListener( CameraRollExtendedEvent.SELECT, cameraRoll_selectHandler, false, 0, true );
				CameraRollExtended.service.addEventListener( CameraRollExtendedEvent.LOADED, cameraRoll_loadedHandler, false, 0, true );
				
				
				
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
			//	Do something when user clicks screen?
			//	
			
			var options:CameraRollExtendedBrowseOptions = new CameraRollExtendedBrowseOptions();
			options.maximumCount = 3;
			options.type = Asset.IMAGE;
			options.autoLoadBitmapData = true;
			options.autoLoadType = AssetRepresentation.THUMBNAIL;
			
			CameraRollExtended.service.browseForAsset( options );
			
		}
		
		
		//
		//	EXTENSION HANDLERS
		//

		private function cameraRoll_cancelHandler( event:CameraRollExtendedEvent ):void
		{
			message( "camera roll cancelled" );
		}
		
		
		private function cameraRoll_selectHandler( event:CameraRollExtendedEvent ):void
		{
			message( "camera roll select" );
			for each (var asset:Asset in event.assets)
			{
				message( asset.filename +"["+asset.type+"] -> "+ asset.url );
//				CameraRollExtended.service.loadAssetByURL( asset.url, AssetRepresentation.THUMBNAIL );
			}
		}
		
		
		private function cameraRoll_loadedHandler( event:CameraRollExtendedEvent ):void
		{
			message( "camera roll loaded" );
			for each (var asset:Asset in event.assets)
			{
				if (asset.bitmapData != null)
				{
					addChild( new Bitmap( asset.bitmapData ));
				}
			}

			_assets = event.assets;
			
			
			//
			// Say a user clicked on one and load the full bersion
			setTimeout( testUserSelect, 1000 );
			
		}
		
		private var _assets : Array;
		
		private function testUserSelect():void
		{
			message( "start user select" );
			if (_assets != null && _assets.length > 0)
			{
				CameraRollExtended.service.addEventListener( CameraRollExtendedEvent.ASSET_LOADED, cameraRoll_assetLoadedHandler, false, 0, true );
				CameraRollExtended.service.loadAssetByURL( _assets[0].url, AssetRepresentation.FULL_RESOLUTION );
			}
		}
		
		
		private function cameraRoll_assetLoadedHandler( event:CameraRollExtendedEvent ):void
		{
			message( "camera roll asset loaded" );
			var asset:Asset = event.assets[0];
			
			addChild( new Bitmap( asset.bitmapData ));
		}
		
		
	}
}

