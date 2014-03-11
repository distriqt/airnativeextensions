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
 * @file   		DistriqtANETestBase.as
 * @brief  		
 * @author 		Shane Korin
 * @created		Jan 4, 2012
 * @updated		$Date:$
 * @copyright	http://distriqt.com/copyright/license.txt
 */

package com.distriqt.extension.base
{
	import com.bit101.components.PushButton;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class DistriqtANETestBase extends Sprite
	{
		
		[Embed("/assets/distriqt-logo.png")]
		static public var DistriqtLogo	: Class;
		
		
		// UI components
		private var _headerbg		: Sprite;
		private var _footerbg		: Sprite;
		private var _logo			: Bitmap;
		private var _title			: TextField;
		
		protected var _text			: TextField;
		protected var _buttons		: Array;
		
		
		
		public function DistriqtANETestBase()
		{
			_buttons = [ ];
			
			if (stage)
			{
				createUI();
			}
			else
			{
				addEventListener( Event.ADDED_TO_STAGE, createUI );
			}
			
			super();
		}
		
		
		public function createUI( event:Event=null ):void
		{
			if (hasEventListener(Event.ADDED_TO_STAGE))
				removeEventListener( Event.ADDED_TO_STAGE, createUI );
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener( Event.RESIZE, stage_resizeHandler, false, 0, true );
			//stage.addEventListener( MouseEvent.CLICK, mouseClickHandler, false, 0, true );
			
			
			_headerbg = new Sprite();
			_headerbg.graphics.beginFill( 0xAAAAAA, 1 );
			_headerbg.graphics.drawRect( 0, 0, stage.stageWidth, stage.stageHeight * 0.12 );
			_headerbg.graphics.endFill();
			addChild( _headerbg );
			
			_footerbg = new Sprite();
			_footerbg.graphics.beginFill( 0xAAAAAA, 1 );
			_footerbg.graphics.drawRect( 0, 0, stage.stageWidth, stage.stageHeight * 0.025 );
			_footerbg.graphics.endFill();
			_footerbg.y = stage.stageHeight - _footerbg.height;
			addChild( _footerbg );
			
			_logo = new DistriqtLogo() as Bitmap;
			_logo.smoothing = true;
			_logo.height = _headerbg.height * 0.75;
			_logo.scaleX = _logo.scaleY;
			_logo.x = 10;
			_logo.y = _headerbg.height * 0.125;
			addChild( _logo );
			
			
			var tf:TextFormat = new TextFormat();
			tf.size = 18;
			_title = new TextField();
			_title.multiline = true;
			_title.width = stage.stageWidth * 0.45;
			_title.autoSize = TextFieldAutoSize.LEFT;
			_title.defaultTextFormat = tf;
			_title.text = "BumpService ANE Example";
			_title.x = _logo.x + _logo.width + stage.stageWidth * 0.075;
			_title.y = _logo.y;
			addChild( _title );
			
			
			tf.size = 20;
			_text = new TextField();
			_text.defaultTextFormat = tf;
			_text.wordWrap = true;
			_text.y = _logo.y + _logo.height * 1.1;
			addChild( _text );
			
			init();
		}
		
		protected function addButton( id:String, label:String, clickHandler:Function=null ):void
		{
			var btn:PushButton = new PushButton( this, 0, 0, label, clickHandler );
			layout();
			_buttons.push(btn);
			addChild( btn );
		}
		
		
		protected function init( ):void
		{
			
		}
		
		
		protected function message( str:String ):void
		{
			trace( str );
			_text.appendText(str+"\n");
			_text.scrollV = _text.maxScrollV;
		}
		
		
		protected function layout( ):void
		{
			var yp:Number = _headerbg.height*1.05;
			
			for each (var btn:PushButton in _buttons)
			{
				btn.setSize( stage.stageWidth*0.7, stage.stageWidth*0.1);
				btn.x = stage.stageWidth * 0.15;
				btn.y = yp;
				yp += btn.height * 1.25;
			}
			
			_text.y = yp;
			
			_text.width = stage.stageWidth;
			_text.height = stage.stageHeight - (yp + _footerbg.height);
			_footerbg.y = stage.stageHeight - _footerbg.height;
		}
		
		
		////////////////////////////////////////////////////////
		//	EVENT HANDLERS
		//
		
		protected function stage_resizeHandler( event:Event ):void
		{
			layout();
		}
		
		protected function mouseClickHandler( event:MouseEvent ):void
		{
			// Override this
		}
		
	}
}