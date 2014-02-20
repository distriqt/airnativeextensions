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
	import com.distriqt.extension.bluetooth.Bluetooth;
	import com.distriqt.extension.bluetooth.BluetoothDevice;
	import com.distriqt.extension.bluetooth.events.BluetoothConnectionEvent;
	import com.distriqt.extension.bluetooth.events.BluetoothDeviceEvent;
	import com.distriqt.extension.bluetooth.events.BluetoothEvent;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	
	/**	
	 * Sample application for using the Bluetooth Native Extension
	 * 
	 * @author	Michael Archbold
	 */
	public class TestBluetooth extends Sprite
	{
		public static const DEV_KEY : String = "betatesting";
		
		
		/**
		 * Class constructor 
		 */	
		public function TestBluetooth()
		{
			super();
			create();
			init();
		}
		
		
		//
		//	VARIABLES
		//
		
		private var _text		: TextField;
		
		private var _stage		: int = 0;
		
		private var _device		: BluetoothDevice;
		
		private var uuid		: String = "fa87c0d0-afac-11de-8a39-0800200c9a66";
		
		
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
				Bluetooth.init( DEV_KEY );
				
				message( "Bluetooth Supported: " + Bluetooth.isSupported );
				message( "Bluetooth Version:   " + Bluetooth.service.version );
				
				//
				//	Add test inits here
				//
				
				Bluetooth.service.addEventListener( BluetoothEvent.STATE_CHANGED, bluetooth_stateChangedHandler, false, 0, true );
				Bluetooth.service.addEventListener( BluetoothEvent.SCAN_MODE_CHANGED, bluetooth_scanModeChangedHandler, false, 0, true );
				Bluetooth.service.addEventListener( BluetoothEvent.SCAN_STARTED, bluetooth_scanStartedHandler, false, 0, true );
				Bluetooth.service.addEventListener( BluetoothEvent.SCAN_FINISHED, bluetooth_scanFinishedHandler, false, 0, true );
				
				
				Bluetooth.service.addEventListener( BluetoothDeviceEvent.DEVICE_FOUND, bluetooth_deviceFoundHandler, false, 0, true );
				Bluetooth.service.addEventListener( BluetoothConnectionEvent.CONNECTION_RECEIVED_BYTES, bluetooth_receivedBytesHandler, false, 0, true );
				Bluetooth.service.addEventListener( BluetoothConnectionEvent.CONNECTION_REMOTE, bluetooth_remoteConnectionHandler, false, 0, true );
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
			_text.text = str + "\n" + _text.text;
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
			message( "====== TEST ACTION ======" );
			switch (_stage)
			{
				case 0:
					message( "enable bluetooth" );
					if (!Bluetooth.service.isEnabled())
						Bluetooth.service.enable();
					else
						message( "already enabled" );
					break;
				
				
				case 1:
					message( "getPairedDevices()" );
					var pairedDevices:Vector.<BluetoothDevice> = Bluetooth.service.getPairedDevices();
					if (pairedDevices.length == 0) 
					{
						message( "No paired devices" );
					}
					else
					{
						for each (var device:BluetoothDevice in pairedDevices)
						{
							_device = device;
							message( "Device: " + device.deviceName + "::"+device.address );
							if (device.bluetoothClass != null)
								message( "  Class: " + device.bluetoothClass.deviceClass +"::"+device.bluetoothClass.majorDeviceClass );
						}
					}
					break;
				
				
				case 2: 
//					message( "setting device discoverable" );
//					Bluetooth.service.setDeviceDiscoverable();
					break;
				
				
				case 3:
//					message( "scan for devices" );
//					Bluetooth.service.startScan();
					break;
				
				
				case 4:
//					message( "show settings" );
//					Bluetooth.service.showSettings();
					break;
				
				
				case 5:
					message( "create a listen connection :: "+uuid );
					var listenResult:Boolean = Bluetooth.service.listen( uuid );
					message( "success="+listenResult );
					break;
				
				case 6:
//					_device = new  BluetoothDevice();
//					_device.address = "F0:08:F1:A9:BF:E1";
					if (_device)
					{
						message( "create a connection :: "+_device.deviceName );
						var connectionResult:Boolean = Bluetooth.service.connect( _device, uuid );
						message( "success="+connectionResult );
					}
					break;
				
				case 7:
					message( "write some data" );
					var data:ByteArray = new ByteArray();
					data.writeUTF( "some test data string" );
					var success:Boolean = Bluetooth.service.writeBytes( uuid, data );
					
					message( "success="+success );
					break;
				
				
				default: 
					message( "disable bluetooth" );
					Bluetooth.service.closeAll();
					Bluetooth.service.disable();
					_stage = -1;
			}
			
			_stage++;
		}
		
		
		
		//
		//	NOTIFICATION HANDLERS
		//
		
		private function activateHandler( event:Event ):void
		{
			
		}
		
		
		private function deactivateHandler( event:Event ):void
		{
//			trace( "deactivateHandler() ");
		}

		
		private function bluetooth_stateChangedHandler( event:BluetoothEvent ):void
		{
			message( "state changed:: "+event.data );
		}
		
		
		private function bluetooth_scanModeChangedHandler( event:BluetoothEvent ):void
		{
			message( "scan mode changed:: "+event.data );
		}
		
		
		private function bluetooth_scanStartedHandler( event:BluetoothEvent ):void
		{
			message( "scan started" );
		}
		
		
		private function bluetooth_scanFinishedHandler( event:BluetoothEvent ):void
		{
			message( "scan finished" );
		}

		
		private function bluetooth_deviceFoundHandler( event:BluetoothDeviceEvent ):void
		{
			message( "device found:: '"+ event.device.deviceName + "' :: "+event.device.address );
			if (event.device.bluetoothClass != null)
				message( "  Class: " + event.device.bluetoothClass.deviceClass + "::" + event.device.bluetoothClass.majorDeviceClass );
		
			_device = event.device;
		}
		
		
		private function bluetooth_remoteConnectionHandler( event:BluetoothConnectionEvent ):void
		{
			var data:ByteArray = new ByteArray();
			data.writeUTF( "thanks for connecting to me" );
			var success:Boolean = Bluetooth.service.writeBytes( event.uuid, data );
			message( "send to client: success="+success );
		}		

		
		private function bluetooth_receivedBytesHandler( event:BluetoothConnectionEvent ):void
		{
			message( "received bytes" );
			var read:ByteArray = Bluetooth.service.readBytes( uuid );
			if (read == null)
			{
				message( "error reading data?" );
			}
			else
			{
				read.position = 0;
				message( "READ: " + read.readUTF() );
			}
		}
		
		
		/*
		private var receivedBytes 	: ByteArray;
		private var terminatingByte : int = '\n'.charCodeAt(0);
		
		private function bluetooth_receivedBytesHandler( event:BluetoothConnectionEvent ):void
		{
			message( "received bytes" );
		
			if (receivedBytes == null) receivedBytes = new ByteArray();
			
			var read:ByteArray = Bluetooth.service.readBytes( uuid );
			if (read == null)
			{
				message( "error reading data?" );
			}
			else
			{
				read.position = 0;
				
				while (read.bytesAvailable)
				{
					var byte:int = read.readByte();
					receivedBytes.writeByte( byte );
					
					if (byte == terminatingByte)
					{
						// process the receivedBytes
						processBytes( receivedBytes );
					}
				}
				
				message( "READ: " + read.readUTF() );
			}
		}
		
		private function processBytes( bytes:ByteArray ):void
		{
			
		}
		*/
		
	}
}

