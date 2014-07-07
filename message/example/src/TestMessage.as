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
			
			if (Message.isMailSupported)
			{
				message( " === SENDING EMAIL === " );
				//
				// Create attachments
				
//				var textfileNativePath:String  = createAttachmentTextFile( "text.txt" );
//				var imagefileNativePath:String = createAttachmentImageFile( "image.jpg" );

				var email:String = "ma@distriqt.com";
				
				var subject:String = "test html";
				var body:String = "<table>" +
					"<tr><td<strong>body</strong></td></tr>"+
					"<tr><td></td></tr>"+
					"<tr><td><img src='http://distriqt.com/wordpress/wp-content/uploads/2009/05/distriqt.jpg'/></td></tr>"+
					"<tr><td><a href='http://distriqt.com'>test link</a></td></tr>" +
					"</table>";
				
//				var body:String = "<table style='font-family:Arial;padding:40px;'><tr><td colspan='2' style='font-weight:bold;font-size:150%;padding-bottom:15px;'>Dr. James McNess</td</tr><tr><td colspan='2' style='font-weight:bold;font-size:120%;padding-bottom:15px;'>Surgical Audit</td></tr><tr><td colspan='2' style='padding-bottom:30px;'> <span style='font-weight:bold;'>Audit Interval:</span> From <span style='font-style:italic; color:#ff0000'> 24/06/14 </span> to <span style='font-style:italic; color:#ff0000; '>02/07/14</span > </td></tr > <tr style='font-weight:bold' valign='top'><td style='width:75px;padding-top:35px;padding-bottom:20px;' > CI 1.1 </td><td style='padding-top:30px;padding-bottom:20px;'>Gynaecological surgery for benign disease ? unplanned intra- or post-operative blood transfusion</td > </tr><tr><td></td><td style='border-bottom:1px solid #000000;padding-bottom:5px;color:#222222;'>Number of patients receiving an unplanned intra-operative or post-operative blood transfusion during their hospital admission for any type of gynaecological surgery for benign disease. <span style='font-style:italic;'>(16)</span></td></tr><tr><td></td><td style='padding-top:5px;color:#222222;'>Number of patients undergoing gynaecological surgery for benign disease  <span style='font-style:italic;'>(19)</span></td></tr><tr style='padding-bottom:60px;'><td style='color:#ff0000;text-align:right;padding-top:15px;' colspan='2'>16/19 = <span style='font-weight:bold;'>84.21% </span></td></tr><tr style='font-weight:bold' valign='top'><td style='width:75px;padding-top:35px;padding-bottom:20px;' > CI 2.1 </td><td style='padding-top:30px;padding-bottom:20px;'>Gynaecological surgery - injury to a major viscus with repair</td > </tr><tr><td></td><td style='border-bottom:1px solid #000000;padding-bottom:5px;color:#222222;'>Number of patients suffering injury to a major viscus with repair, during a gynaecological operative procedure or subsequently up to 2 weeks post-operatively. <span style='font-style:italic;'>(2)</span></td></tr><tr><td></td><td style='padding-top:5px;color:#222222;'>Number of patients undergoing gynaecological surgery for benign disease.  <span style='font-style:italic;'>(19)</span></td></tr><tr style='padding-bottom:60px;'><td style='color:#ff0000;text-align:right;padding-top:15px;' colspan='2'>2/19 = <span style='font-weight:bold;'>10.53% </span></td></tr><tr style='font-weight:bold' valign='top'><td style='width:75px;padding-top:35px;padding-bottom:20px;' > CI 3.1 </td><td style='padding-top:30px;padding-bottom:20px;'>Ectopic pregnancy managed laparoscopically</td > </tr><tr><td></td><td style='border-bottom:1px solid #000000;padding-bottom:5px;color:#222222;'>Number of patients having laparoscopic management of an ectopic pregnancy. <span style='font-style:italic;'>(8)</span></td></tr><tr><td></td><td style='padding-top:5px;color:#222222;'>Number of patients presenting with an ectopic pregnancy who are managed surgically.  <span style='font-style:italic;'>(14)</span></td></tr><tr style='padding-bottom:60px;'><td style='color:#ff0000;text-align:right;padding-top:15px;' colspan='2'>8/14 = <span style='font-weight:bold;'>57.14% </span></td></tr><tr style='font-weight:bold' valign='top'><td style='width:75px;padding-top:35px;padding-bottom:20px;' > CI 4.1 </td><td style='padding-top:30px;padding-bottom:20px;'>Thromboprophylaxis for major gynaecological surgery</td > </tr><tr><td></td><td style='border-bottom:1px solid #000000;padding-bottom:5px;color:#222222;'>Number of patients undergoing major gynaecological surgery who receive thromboprophylaxis according to hospital guidelines. <span style='font-style:italic;'>(1)</span></td></tr><tr><td></td><td style='padding-top:5px;color:#222222;'>Number of patients undergoing major gynaecological surgery.  <span style='font-style:italic;'>(19)</span></td></tr><tr style='padding-bottom:60px;'><td style='color:#ff0000;text-align:right;padding-top:15px;' colspan='2'>1/19 = <span style='font-weight:bold;'>5.26% </span></td></tr><tr style='font-weight:bold' valign='top'><td style='width:75px;padding-top:35px;padding-bottom:20px;' > CI 4.2 </td><td style='padding-top:30px;padding-bottom:20px;'>Re-admission for venous thromboembolism within 28 days</td > </tr><tr><td></td><td style='border-bottom:1px solid #000000;padding-bottom:5px;color:#222222;'>Number of patients who develop or are re-admitted with venous thromboembolism (VTE) within 28 days of major gynaecological surgery. <span style='font-style:italic;'>(6)</span></td></tr><tr><td></td><td style='padding-top:5px;color:#222222;'>Number of patients undergoing major gynaecological surgery.  <span style='font-style:italic;'>(19)</span></td></tr><tr style='padding-bottom:60px;'><td style='color:#ff0000;text-align:right;padding-top:15px;' colspan='2'>6/19 = <span style='font-weight:bold;'>31.58% </span></td></tr><tr style='font-weight:bold' valign='top'><td style='width:75px;padding-top:35px;padding-bottom:20px;' > CI 5.1 </td><td style='padding-top:30px;padding-bottom:20px;'>Use of mesh repair for pelvic organ prolapse</td > </tr><tr><td></td><td style='border-bottom:1px solid #000000;padding-bottom:5px;color:#222222;'>Number of patients having mesh repair. <span style='font-style:italic;'>(4)</span></td></tr><tr><td></td><td style='padding-top:5px;color:#222222;'>Number of patients having a repair for pelvic organ prolapse.  <span style='font-style:italic;'>(17)</span></td></tr><tr style='padding-bottom:60px;'><td style='color:#ff0000;text-align:right;padding-top:15px;' colspan='2'>4/17 = <span style='font-weight:bold;'>23.53% </span></td></tr><tr style='font-weight:bold' valign='top'><td style='width:75px;padding-top:35px;padding-bottom:20px;' > CI 6.1 </td><td style='padding-top:30px;padding-bottom:20px;'>Surgical intervention for menorrhagia</td > </tr><tr><td></td><td style='border-bottom:1px solid #000000;padding-bottom:5px;color:#222222;'>Number of patients undergoing a hysterectomy for menorrhagia. <span style='font-style:italic;'>(6)</span></td></tr><tr><td></td><td style='padding-top:5px;color:#222222;'>Number of patients undergoing gynaecological surgery to treat menorrhagia.  <span style='font-style:italic;'>(18)</span></td></tr><tr style='padding-bottom:60px;'><td style='color:#ff0000;text-align:right;padding-top:15px;' colspan='2'>6/18 = <span style='font-weight:bold;'>33.33% </span></td></tr></table>";
				
				
				Message.service.sendMailWithOptions( 
					subject, 
					body, 
					email, 
					"",
					"",
					null
//					[
//						new MessageAttachment( textfileNativePath,  "text/plain" ),
//						new MessageAttachment( imagefileNativePath, "image/jpeg" )
//					]
					,
					true
				);
			}
			
//			if (Message.isSMSSupported)
//			{
//				message( " === SENDING SMS === " );
//				
//				var sms:SMS = new SMS();
//				sms.address = "0417711791";
//				sms.message = "Testing Message ANE";
//				
//				Message.service.sendSMS( sms );
//			}
			
			
			
			
			
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

