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
	import com.adobe.images.JPGEncoder;
	import com.distriqt.extension.message.Message;
	import com.distriqt.extension.message.MessageAttachment;
	import com.distriqt.extension.message.events.MessageEvent;
	import com.distriqt.extension.message.events.MessageSMSEvent;
	import com.distriqt.extension.message.objects.SMS;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	
	/**	
	 * Sample application for using the Message Native Extension
	 * 
	 * Notes:
	 * - The generation of the jpeg takes a little time on an older iOS device so the dialog may not appear straight away. 
	 * 
	 * @author	Michael Archbold
	 */
	public class TestMessage extends Sprite
	{
		public static const DEV_KEY : String = "YOUR_DEVELOPER_KEY";	
		
		/**
		 * Class constructor 
		 */	
		public function TestMessage( devKey:String = DEV_KEY )
		{
			super();
			_devKey = devKey;
			create();
			
			
			try
			{
				Message.init( _devKey );
				
				message( "Message Supported:      " + Message.isSupported );
				message( "Message Version:        " + Message.service.version );
				message( "Message Mail Supported: " + Message.isMailSupported );
				
				Message.service.addEventListener( MessageEvent.MESSAGE_MAIL_ATTACHMENT_ERROR, 	message_errorHandler, 	false, 0, true );
				Message.service.addEventListener( MessageEvent.MESSAGE_MAIL_COMPOSE, 			message_composeHandler, false, 0, true );
				
				Message.service.addEventListener( MessageSMSEvent.MESSAGE_SMS_SENT, 			message_smsSentHandler, false, 0, true );
				
			}
			catch (e:Error)
			{
				message( "ERROR::"+e.message );
			}
			
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
		}
		
		
		//
		//	FUNCTIONALITY
		//
		
		private function message( str:String ):void
		{
			trace( str );
			_text.appendText(str+"\n");
		}
		
		
		private function createAttachmentTextFile( filename:String ):String
		{
			var file:File = File.documentsDirectory.resolvePath( filename );
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes("This is the attachment");
			stream.close();
			
			return file.nativePath;
		}
		
		
		private function createAttachmentImageFile( filename:String ):String
		{
			var bd:BitmapData = new BitmapData( 100, 100, false, 0x222222 ); 
			
			var jpg:JPGEncoder = new JPGEncoder(50);
			var ba:ByteArray = jpg.encode( bd );
			
			var file:File = File.documentsDirectory.resolvePath( filename );
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeBytes(ba);
			stream.close();
			
			return file.nativePath;
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
			
//			if (Message.isMailSupported)
//			{
//				message( " === SENDING EMAIL === " );
//				//
//				// Create attachments
//				
//				var textfileNativePath:String  = createAttachmentTextFile( "text.txt" );
//				var imagefileNativePath:String = createAttachmentImageFile( "image.jpg" );
//
//				var email:String = "ma@distriqt.com";
//				
//				Message.service.sendMailWithOptions( 
//					"test", 
//					"test body", 
//					email, 
//					"",
//					"",
//					[
//						new MessageAttachment( textfileNativePath,  "text/plain" ),
//						new MessageAttachment( imagefileNativePath, "image/jpeg" )
//					],
//					false
//				);
//			}
			
			if (Message.isSMSSupported)
			{
				message( " === SENDING SMS === " );
				
				var sms:SMS = new SMS();
				sms.address = "0417711791";
				sms.message = "Testing Message ANE";
				
				Message.service.sendSMS( sms );
			}
			
		}
		
		
		//
		//	EXTENSION EVENT HANDLERS
		//
		
		private function message_errorHandler( event:MessageEvent ):void 
		{
			message( event.type +"::"+ event.details );
		}
		
		private function message_composeHandler( event:MessageEvent ):void 
		{
			message( event.type +"::"+ event.details );
		}
		
		private function message_smsSentHandler( event:MessageSMSEvent ):void
		{
			message( event.type +"::"+ event.details );
		}
		
	}
}

