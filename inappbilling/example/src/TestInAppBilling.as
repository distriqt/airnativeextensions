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
	import com.distriqt.extension.inappbilling.InAppBilling;
	import com.distriqt.extension.inappbilling.InAppBillingServiceTypes;
	import com.distriqt.extension.inappbilling.Product;
	import com.distriqt.extension.inappbilling.Purchase;
	import com.distriqt.extension.inappbilling.events.InAppBillingEvent;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	/**	
	 * Sample application for using the InAppBilling Native Extension
	 * 
	 * @author	Michael Archbold
	 */
	public class TestInAppBilling extends Sprite
	{
		public static const DEV_KEY : String = "YOUR_DEVELOPER_KEY";	

		public static const GOOGLE_PLAY_INAPP_BILLING_KEY : String = "YOUR_GOOGLE_PLAY_INAPP_BILLING_KEY";
		
		
		//
		//	Android test product ids
//		private static const TEST_PRODUCT_ID	: String = "com.distriqt.test.background1";
		private static const TEST_PRODUCT_ID	: String = "com.distriqt.test.subscription1";
				
//		private static const TEST_PRODUCT_ID	: String = "android.test.purchased";
//		private static const TEST_PRODUCT_ID	: String = "android.test.canceled";
//		private static const TEST_PRODUCT_ID	: String = "android.test.refunded";
//		private static const TEST_PRODUCT_ID	: String = "android.test.item_unavailable";

		
		/**
		 * Class constructor 
		 */	
		public function TestInAppBilling( devKey:String=DEV_KEY, googleKey:String=GOOGLE_PLAY_INAPP_BILLING_KEY )
		{
			super();
		
			_devKey = devKey;
			_googleKey = googleKey;
			
			create();
			init( _devKey );
			message( "click screen to start test" );
		}
		
		
		//
		//	VARIABLES
		//
		
		private var _devKey		: String;
		private var _googleKey	: String;
		
		private var _text		: TextField;
		
		
		//
		//	INITIALISATION
		//	
		
		private function create( ):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			

			var tf:TextFormat = new TextFormat();
			tf.font = "_typewriter";
			tf.size = 20;
			_text = new TextField();
			_text.defaultTextFormat = tf;
			addChild( _text );

			stage.addEventListener( Event.RESIZE, stage_resizeHandler, false, 0, true );
			stage.addEventListener( MouseEvent.CLICK, mouseClickHandler, false, 0, true );
			stage.addEventListener( MouseEvent.CLICK, respondHandler, false, 0, true );
		}
		
		private function message( str:String ):void
		{
			trace( str );
			_text.appendText(str+"\n");
		}
		
		private function stage_resizeHandler( event:Event ):void
		{
			_text.width  = stage.stageWidth;
			_text.height = stage.stageHeight - 100;
		}
		
		private function respondHandler( event:MouseEvent ):void
		{
			message( "click" );
		}
		private function mouseClickHandler( event:MouseEvent ):void
		{
			if (stage)
				stage.removeEventListener( MouseEvent.CLICK, mouseClickHandler );
			test();
		}
		
		private function finish():void
		{
			InAppBilling.service.removeEventListener( InAppBillingEvent.SETUP_SUCCESS,   			setup_successHandler );
			InAppBilling.service.removeEventListener( InAppBillingEvent.SETUP_FAILURE,   			setup_failureHandler );
			
			InAppBilling.service.removeEventListener( InAppBillingEvent.PRODUCTS_LOADED, 			products_loadedHandler );
			InAppBilling.service.removeEventListener( InAppBillingEvent.PRODUCTS_FAILED, 			products_failedHandler );
			InAppBilling.service.removeEventListener( InAppBillingEvent.INVALID_PRODUCT,			product_invalidHandler );
			
			InAppBilling.service.removeEventListener( InAppBillingEvent.PURCHASE_CANCELLED, 		purchase_cancelledHandler );
			InAppBilling.service.removeEventListener( InAppBillingEvent.PURCHASE_FAILED, 			purchase_failedHandler );
			InAppBilling.service.removeEventListener( InAppBillingEvent.PURCHASE_SUCCESS, 			purchase_successHandler );
			
			InAppBilling.service.removeEventListener( InAppBillingEvent.RESTORE_PURCHASES_SUCCESS,	restorePurchases_successHandler );
			InAppBilling.service.removeEventListener( InAppBillingEvent.RESTORE_PURCHASES_FAILED, 	restorePurchases_failedHandler );
			
			InAppBilling.service.removeEventListener( InAppBillingEvent.CONSUME_SUCCESS, 			consumePurchase_successHandler );
			InAppBilling.service.removeEventListener( InAppBillingEvent.CONSUME_FAILED, 			consumePurchase_failedHandler );
			
			InAppBilling.service.dispose();
			
			message( "finished" );
		}
		
		
		
		////////////////////////////////////////////////////////
		//	FUNCTIONALITY
		//
		
		public function init(dev_key:String):void
		{
			try
			{
				InAppBilling.init( dev_key );
				
				message( "InAppBilling.isSupported:     " + InAppBilling.isSupported );
				message( "InAppBilling.service.version: " + InAppBilling.service.version );
			}
			catch (e:Error)
			{
				message( e.message );
			}
		}
		
		
		public function test():void
		{
			try
			{
				InAppBilling.service.addEventListener( InAppBillingEvent.SETUP_SUCCESS,   			setup_successHandler, false, 0, true );
				InAppBilling.service.addEventListener( InAppBillingEvent.SETUP_FAILURE,   			setup_failureHandler, false, 0, true );
				
				InAppBilling.service.addEventListener( InAppBillingEvent.PRODUCTS_LOADED, 			products_loadedHandler, false, 0, true );
				InAppBilling.service.addEventListener( InAppBillingEvent.PRODUCTS_FAILED, 			products_failedHandler, false, 0, true );
				InAppBilling.service.addEventListener( InAppBillingEvent.INVALID_PRODUCT,			product_invalidHandler, false, 0, true );
				
				InAppBilling.service.addEventListener( InAppBillingEvent.PURCHASE_CANCELLED, 		purchase_cancelledHandler, false, 0, true );
				InAppBilling.service.addEventListener( InAppBillingEvent.PURCHASE_FAILED, 			purchase_failedHandler,    false, 0, true );
				InAppBilling.service.addEventListener( InAppBillingEvent.PURCHASE_SUCCESS, 			purchase_successHandler,   false, 0, true );
				
				InAppBilling.service.addEventListener( InAppBillingEvent.RESTORE_PURCHASES_SUCCESS, restorePurchases_successHandler, false, 0, true );
				InAppBilling.service.addEventListener( InAppBillingEvent.RESTORE_PURCHASES_FAILED, 	restorePurchases_failedHandler,  false, 0, true );
				
				InAppBilling.service.addEventListener( InAppBillingEvent.CONSUME_SUCCESS, 			consumePurchase_successHandler, false, 0, true );
				InAppBilling.service.addEventListener( InAppBillingEvent.CONSUME_FAILED, 			consumePurchase_failedHandler,  false, 0, true );
				 	
//				InAppBilling.service.setServiceType( InAppBillingServiceTypes.GOOGLE_PLAY_INAPP_BILLING );
				
//				InAppBilling.service.setServiceType( InAppBillingServiceTypes.APPLE_INAPP_PURCHASE );
				
				InAppBilling.service.setup( _googleKey );
				
			}
			catch (e:Error)
			{
				message( e.message );
			}
		}
		
		
		////////////////////////////////////////////////////////
		//	INTERNALS
		//
		
		
		
		private function startPurchase( event:MouseEvent ):void
		{
			if (stage)
				stage.removeEventListener( MouseEvent.CLICK, startPurchase );
			
			//
			//	Example of making a purchase
			makePurchase( TEST_PRODUCT_ID );
		}
		
		
		private function makePurchase( productId:String ):void
		{
			message( "InAppBilling makePurchase("+productId+")");
			
			var purchase:Purchase = new Purchase();
			purchase.productId = productId;
			purchase.quantity = 1;
			
			message( String(InAppBilling.service.makePurchase( purchase )) );
		}
		
		
		
		
		
		
		////////////////////////////////////////////////////////
		//	EVENT HANDLERS
		//
		
		
		private function setup_successHandler(event:InAppBillingEvent):void
		{
			message( "InAppBilling setup success" );

			message( "InAppBilling getting products: "+ TEST_PRODUCT_ID );
			InAppBilling.service.getProducts( [ TEST_PRODUCT_ID ] );
		}
		
		
		private function setup_failureHandler(event:InAppBillingEvent):void
		{
			message( "InAppBilling setup FAILURE!" );
		}
		
		
		private function products_loadedHandler( event:InAppBillingEvent ):void
		{
			message( "InAppBilling products loaded" );
			for each (var product:Product in event.data)
			{
				message( "\treceived:"+product.id );
			}
			
			//
			//	Retrieve any previously purchased products
			//
			//	Note: doing this here without a user clicking a button will fail the apple review guidelines
			//
			//		This should be treated as a functionality test only and not an example usage
			
			InAppBilling.service.restorePurchases();
		}
		
		
		private function products_failedHandler( event:InAppBillingEvent ):void
		{
			message( "InAppBilling products FAILED:: " +event.data );
			
			stage.addEventListener( MouseEvent.CLICK, startPurchase, false, 0, true );
		}
		
		
		private function product_invalidHandler( event:InAppBillingEvent ):void
		{
			message( "InAppBilling invalid product:"+event.errorCode+":"+event.message );
		}
		
		
		private function purchase_cancelledHandler( event:InAppBillingEvent ):void
		{
			message( "InAppBilling purchase cancelled" + event.errorCode );

			finish();
		}
		
		
		private function purchase_failedHandler( event:InAppBillingEvent ):void
		{
			message( "InAppBilling purchase failed [" + event.errorCode + "] :: "+ event.message );

//			if (event.message == "response:item:already:owned")
//			{
//				InAppBilling.service.consumePurchase( new Purchase(TEST_PRODUCT_ID) );
//			}
			
//			finish();	
		}
		
		
		private function purchase_successHandler( event:InAppBillingEvent ):void
		{
			message( "InAppBilling purchase success" + event.errorCode );
			printPurchase( event.data[0] );
			
			//
			//	Attempt to consume the purchase
//			message( "consuming purchase "+Purchase(event.data[0]).productId );
//			InAppBilling.service.consumePurchase( Purchase(event.data[0]) );
		}
		
		
		private function printPurchase( purchase:Purchase ):void
		{
			message( purchase.productId +":"+purchase.transactionState + "::" + purchase.error +":: "+ purchase.transactionReceipt );
		}
		
		
		private function restorePurchases_successHandler( event:InAppBillingEvent ):void
		{
			message( "InAppBilling restore success" );
			
			
			message( "=================" );
			message( "CLICK TO PURCHASE: "+TEST_PRODUCT_ID );
			
			stage.addEventListener( MouseEvent.CLICK, startPurchase, false, 0, true );
			
		}
		
		private function restorePurchases_failedHandler( event:InAppBillingEvent ):void
		{
			message( "InAppBilling restore failed" );
		}
		
		
		private function consumePurchase_successHandler( event:InAppBillingEvent ):void
		{
			message( "InAppBilling consume success :: " + Purchase(event.data[0]).productId );
			
			finish();
		}
		
		
		private function consumePurchase_failedHandler( event:InAppBillingEvent ):void
		{
			message( "InAppBilling consume failed" );
		}
		
		
	}
}

