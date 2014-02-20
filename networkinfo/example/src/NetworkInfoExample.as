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
 * @file   		NetworkInfoExample.as
 * @brief  		This is a test for integrating the network info ANE
 * @author 		Michael Archbold (ma@distriqt.com)
 * @created		Oct 26, 2011
 * @updated		$Date:$
 * @copyright	http://distriqt.com/copyright/license.txt
 */
package
{
	import com.distriqt.extension.networkinfo.InterfaceAddress;
	import com.distriqt.extension.networkinfo.NetworkInfo;
	import com.distriqt.extension.networkinfo.NetworkInterface;
	import com.distriqt.extension.networkinfo.events.NetworkInfoEvent;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setInterval;
	
	
	/**	
	 * @author	Michael Archbold (ma@distriqt.com)
	 */
	public class NetworkInfoExample extends Sprite
	{
		////////////////////////////////////////////////////////
		//	VARIABLES
		//
		
		public static const DEV_KEY : String = "your_dev_key";
		 
		private var status	: TextField;
		
		private var statusEventCount	: Number = 0;
		private var updateEventCount	: Number = 0;
		
		public function NetworkInfoExample()
		{
			super();
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			create();

			try
			{
				NetworkInfo.init( DEV_KEY );
				trace( "supported:"+ NetworkInfo.isSupported );
				trace( "version:"+NetworkInfo.networkInfo.version );
				NetworkInfo.networkInfo.addEventListener( NetworkInfoEvent.CHANGE, networkInfo_changeHandler );
			}
			catch (e:Error)
			{
				trace( "ERROR:"+e.message );
			}
			setInterval( update, 5000 );
		}
		
		
		
		////////////////////////////////////////////////////////
		//	FUNCTIONALITY
		//
		
		
		////////////////////////////////////////////////////////
		//	INTERNALS
		//
		
		private function create():void
		{
			status = new TextField();
			
			status.x = 0;
			status.y = 0;
			status.width  = stage.stageWidth;
			status.height = 1000;//stage.stageHeight;
			status.multiline = true;
			status.wordWrap = true;
			
			var tf:TextFormat = status.getTextFormat();
			tf.size = 14;
			tf.color = 0x0000ff;
			
			status.defaultTextFormat = tf;
			status.setTextFormat( tf );
			status.text = "start up";
			
			addChild( status );
		}
		
		
		private function update():void
		{
			updateEventCount++;
			var ntf:Vector.<NetworkInterface> = NetworkInfo.networkInfo.findInterfaces();

			status.text = 
				"supported: "+NetworkInfo.isSupported+"\nversion: "+NetworkInfo.networkInfo.version+"\n"+
				"status count: "+statusEventCount+"\n"+"update count: "+updateEventCount+"\n";
			status.appendText( "isReachable="+NetworkInfo.networkInfo.isReachable() +"\n" );
			status.appendText( "isWWAN="+NetworkInfo.networkInfo.isWWAN() +"\n" );
			status.appendText( "interface count="+ntf.length +"\n" );
			status.appendText( "\n" );
			status.appendText( "--- INTERFACES ---\n" );
			
			for each (var interfaceObj:NetworkInterface in ntf)
			{
				status.appendText( 
					interfaceObj.name +"::"+
					interfaceObj.displayName +
					"["+interfaceObj.active.toString()+"]:"+
					interfaceObj.hardwareAddress +"\n"
				);
				
				for each (var address:InterfaceAddress in interfaceObj.addresses)
				{
					status.appendText( "\t"+address.address +"\n");
				}
			}
		}
		
		
		////////////////////////////////////////////////////////
		//	EVENT HANDLERS
		//
		
		private function networkInfo_changeHandler( event:NetworkInfoEvent ):void
		{
			statusEventCount++;
			update();
		}
		
	}
}