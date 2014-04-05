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
	import com.distriqt.extension.mediaplayer.MediaPlayer;
	import com.distriqt.extension.mediaplayer.events.MediaErrorEvent;
	import com.distriqt.extension.mediaplayer.events.MediaPlayerEvent;
	import com.distriqt.extension.mediaplayer.events.MediaProgressEvent;
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	/**	
	 * Sample application for using the MediaPlayer Native Extension
	 * 
	 * @author	Michael Archbold
	 */
	public class TestMediaPlayer extends Sprite
	{
		public static const DEV_KEY : String = "YOUR_DEVELOPER_KEY";	
		
		/**
		 * Class constructor 
		 */	
		public function TestMediaPlayer( devKey:String=DEV_KEY )
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
		
		private function create():void
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
			
			addEventListener( Event.ACTIVATE, activateHandler, false, 0, true );
			addEventListener( Event.DEACTIVATE, deactivateHandler, false, 0, true );
		
			//
			//	This is just drawing a background to demo the autoscale option
			graphics.beginFill( 0xFF0000 );
			graphics.drawRect( 50, 50, 320, 180 );
			graphics.endFill();
		}
		
		
		private function init():void
		{
			try
			{
				MediaPlayer.init( _devKey );
				
				message( "MediaPlayer Supported: " + MediaPlayer.isSupported );
				message( "MediaPlayer Version:   " + MediaPlayer.service.version );
				
				//
				//	Add test here
				//
				MediaPlayer.service.addEventListener( MediaPlayerEvent.READY, 		mediaPlayer_readyHandler, false, 0, true );
				MediaPlayer.service.addEventListener( MediaPlayerEvent.COMPLETE, 	mediaPlayer_completeHandler, false, 0, true );
				MediaPlayer.service.addEventListener( MediaProgressEvent.PROGRESS,	mediaPlayer_progressHandler, false, 0, true );
				MediaPlayer.service.addEventListener( MediaErrorEvent.ERROR, 		mediaPlayer_errorHandler, false, 0, true );
				
			}
			catch (e:Error)
			{
				message( e.message );
			}
		}
		
		
		
		private function doTest():void
		{
			//
			//	SEEK TEST
//			var time:Number = Math.random() * MediaPlayer.service.duration;
//			message( "Seek to: " + time );
//			MediaPlayer.service.seek( time );
			
			//
			//	RESIZE TEST
//			MediaPlayer.service.resize( 30*Math.random(), 30*Math.random(), stage.stageWidth * Math.random(), stage.stageHeight * Math.random() );

			
			//
			//	LOAD TEST
//			var path:String = "assets/5.mp4";
//			MediaPlayer.service.load( path );
			
			
			//
			//	CREATE PLAYER
			var path:String = File.applicationDirectory.nativePath + File.separator + "assets/big_buck_bunny.mp4";
			MediaPlayer.service.createPlayer( path, 50, 50, 320, 180, false, MediaPlayer.CONTROLS_NONE ); 
			
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
			
			message( stage.stageWidth +"x"+stage.stageHeight );
			
			//
			//	Example resize to stage width
//			MediaPlayer.service.resize( 0, 0, stage.stageWidth, stage.stageWidth * 9 / 16 );
			
		}
		
		
		private function mouseClickHandler( event:MouseEvent ):void
		{
			//
			//	Do something when user clicks screen?
			//	
			doTest();
		}
		
		private function activateHandler( event:Event ):void
		{
//			MediaPlayer.service.play();
//			MediaPlayer.service.addEventListener( MediaPlayerEvent.READY, mediaPlayer_readyHandler );
		}
		
		
		private function deactivateHandler( event:Event ):void
		{
			MediaPlayer.service.removeEventListener( MediaPlayerEvent.READY, mediaPlayer_readyHandler );
			MediaPlayer.service.pause();
		}
		
		
		//
		//	EXTENSION HANDLERS
		//
		
		private function mediaPlayer_readyHandler( event:MediaPlayerEvent ):void
		{
			message( "MediaPlayer ready" );
			message( "MediaPlayer duration: " + MediaPlayer.service.duration );
			
			MediaPlayer.service.play();
		}

		
		private function mediaPlayer_completeHandler( event:MediaPlayerEvent ):void
		{
			message( "complete:" + event.details );
			MediaPlayer.service.removePlayer();
			
			//
			//	Play again?
//			var path:String = File.applicationDirectory.nativePath + File.separator + "assets/big_buck_bunny.mp4";
//			MediaPlayer.service.createPlayer( path, 50, 50, 320, 180, false, MediaPlayer.CONTROLS_NONE ); 
		}

		
		private function mediaPlayer_progressHandler( event:MediaProgressEvent ):void
		{
//			message( "progress: " + event.current + " / " +event.total );
		}
		
		private function mediaPlayer_errorHandler( event:MediaErrorEvent ):void
		{
			message( "error: "+ event.code + "::"+event.description );
//			MediaPlayer.service.removePlayer();
		}
	}
}

