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
	import com.distriqt.extension.androidroot.AndroidRoot;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import net.hires.debug.Stats;
	
	import com.distriqt.animation.tests.ParticleAnimationTest;
	
	[SWF(frameRate="60")]
	/**	
	 * <p>
	 * Sample application for using the AndroidRoot Native Extension.
	 * </p>
	 * 
	 * <p>
	 * This application initialises the AndroidRoot extension and then waits for 
	 * a user to tap the screen. It will then execute one of the extensions functions
	 * as shown in the mouseClickHandler. 
	 * </p>
	 * 
	 * @author	Michael Archbold
	 */
	public class TestAndroidRoot extends Sprite
	{
		
		public static const DEV_KEY : String = "your_dev_key";
		
		private var _text		: TextField;
		
		
		
		/**
		 * Class constructor 
		 */	
		public function TestAndroidRoot()
		{
			super();
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var tf:TextFormat = new TextFormat();
			tf.font = "_typewriter";
			tf.size = 18;
			_text = new TextField();
			_text.defaultTextFormat = tf;
			_text.y = 480;
			addChild( _text );
			
			
			var animation:ParticleAnimationTest = new ParticleAnimationTest( 800, 400 );
			animation.y = 80;
			addChild( animation );
			addChild( new Stats() );	
			
			init();
			
			stage.addEventListener( Event.RESIZE, stage_resizeHandler, false, 0, true );
			stage.addEventListener( MouseEvent.CLICK, mouseClickHandler, false, 0, true );
			message( "TestAndroidRoot:: startup" );
			
			
			
			
		}
		
		
		//
		//	INITIALISATION
		//	
		
		private function init( ):void
		{
			try
			{
				AndroidRoot.init( DEV_KEY );

				message( "AndroidRoot Supported: " + AndroidRoot.isSupported );
				message( "AndroidRoot Version: "   + AndroidRoot.service.version );
				
				AndroidRoot.service.showSystembar( false );
				
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
			_text.appendText(str+"\n");
		}
		
		
		//
		//	EVENT HANDLERS
		//
		
		private function stage_resizeHandler( event:Event ):void
		{
			_text.width  = stage.stageWidth;
			_text.height = stage.stageHeight - _text.y;
		}
		
		
		private function mouseClickHandler( event:MouseEvent ):void
		{
			//
			//	Do something when user clicks screen
			//	
			
			message( "showSystembar( "+ String(!AndroidRoot.service.isSystembarVisible) +" )" );
			AndroidRoot.service.showSystembar( !AndroidRoot.service.isSystembarVisible, 2 );

			AndroidRoot.service.setAutoStart( true );
			
			AndroidRoot.service.restart();
			
//			AndroidRoot.service.shutdown();
			
		}
		
		
		
		
		
		
	}
}

