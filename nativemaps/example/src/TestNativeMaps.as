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
 * An example application for the Native Maps extension.
 * 
 * @author Michael Archbold & Shane Korin
 * 	
 */
package
{
	import com.distriqt.extension.nativemaps.NativeMaps;
	import com.distriqt.extension.nativemaps.events.NativeMapBitmapEvent;
	import com.distriqt.extension.nativemaps.events.NativeMapEvent;
	import com.distriqt.extension.nativemaps.objects.CircleOverlay;
	import com.distriqt.extension.nativemaps.objects.CustomMarkerIcon;
	import com.distriqt.extension.nativemaps.objects.LatLng;
	import com.distriqt.extension.nativemaps.objects.LatLngBounds;
	import com.distriqt.extension.nativemaps.objects.MapMarker;
	import com.distriqt.extension.nativemaps.objects.MapMarkerColour;
	import com.distriqt.extension.nativemaps.objects.MapOptions;
	import com.distriqt.extension.nativemaps.objects.MapType;
	import com.distriqt.extension.nativemaps.objects.Polyline;
	import com.distriqt.extension.nativemaps.objects.UserTrackingMode;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	

	public class TestNativeMaps extends Sprite
	{
		
		static public const DEV_KEY	: String = "your-dev-key";
		
		
		[Embed(source="./assets/custom-marker.png")]
		public var CustomMarker	: Class;
		
		private var _devKey : String = "";
		
		protected var _created :Boolean = false;
		protected var _count:int = 0;
		protected var _buttons:Array;
		protected var _mapTypeIndex:uint = 0;
		
		public var pl1id:int = -1;
		public var pl2id:int = -1;
		
		
		public var mapTypes:Array = [ MapType.MAP_TYPE_NORMAL, MapType.MAP_TYPE_SATELLITE, MapType.MAP_TYPE_TERRAIN, MapType.MAP_TYPE_HYBRID ];
		
		
		public function TestNativeMaps( devKey:String=DEV_KEY )
		{
			super();
			
			_devKey = devKey;
			_buttons = [];
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			if (stage)
				onAddedToStage(null);
			else
				stage.addEventListener( Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true );
			
			stage.addEventListener( Event.RESIZE, onStageResize, false, 0, true );	
		}
		  
		protected function onAddedToStage(event:Event):void
		{
			createUI();
		}
		 
		
		protected function mouseClickHandler( event:MouseEvent ):void
		{
			if (!NativeMaps.isSupported) 
				return;
			 
			if (event.currentTarget.alpha != 1)
				return; 
			 
			switch (event.currentTarget)
			{
				
				// Create Map
				case _buttons[0]:
					trace("Map exists :: " + NativeMaps.service.mapExists());
					
					if (!_created)
					{
						trace( "creating - " + stage.stageHeight);
						NativeMaps.service.createMap( 200, 200, 10, 10 );
						_created = true;
						
						for each (var b:Sprite in _buttons)
						{
							b.alpha = 1;
						}
						
						_buttons[0].getChildAt(0).text = "Destroy Map";
					}
					else
					{
						NativeMaps.service.destroyMap();
						_created = false;
						for each (var b:Sprite in _buttons)
						{
							if (b != _buttons[0])
								b.alpha = 0.5;
						}
						
						_buttons[0].getChildAt(0).text = "Create Map";
					}
					
					var tf:TextFormat = _buttons[0].getChildAt(0).getTextFormat();
					tf.size = int(stage.stageWidth/42);
					tf.font = "Helvetica";
					tf.align = TextFormatAlign.CENTER;
					_buttons[0].getChildAt(0).setTextFormat(tf);
					
					break;
				
				
				// Set layout
				case _buttons[1]:
					
					trace("Map exists :: " + NativeMaps.service.mapExists());
					trace("Stage w: " + stage.stageWidth);
					trace("Stage h: " + stage.stageHeight);
					NativeMaps.service.setLayout( stage.stageWidth-20, stage.stageHeight*0.5, 10, 10 );
					break;
				
				
				// Set Centre
				case _buttons[2]:
					NativeMaps.service.setCentre( new LatLng(-37, 144), 6, true );
					break;
				
				
				// Zoom in
				case _buttons[3]:
					var circle:CircleOverlay = new CircleOverlay(20000, new LatLng(-37, 144), 5, 0xFFFF0000, 0xAA0000FF, 1, true );
					circle.name = "circle";
					trace("Added circle ID: " + NativeMaps.service.addCircleOverlay( circle ));
					//NativeMaps.service.zoomIn();
					//NativeMaps.service.showMap();
					break;
				
				
				// Zoom out
				case _buttons[4]:
					
					//trace("Circle ID to remove: " + NativeMaps.service.getCircleOverlayIdByName("circle"));
					//NativeMaps.service.removeCircleOverlay( NativeMaps.service.getCircleOverlayIdByName("circle") );
					
					//NativeMaps.service.zoomOut();
					NativeMaps.service.hideMap();
					break;
				
				
				// Set Zoom
				case _buttons[5]:
					NativeMaps.service.setZoom( 6, true );					
					
					break;
				
				// Get Zoom
				case _buttons[6]:
					//trace( "Zoom level: " + NativeMaps.service.getZoom() );
					
					break;
				
				
				// Set Bounds
				case _buttons[7]:
					var bounds:LatLngBounds = new LatLngBounds( new LatLng(-39, 111), new LatLng(-12, 160) );
					NativeMaps.service.setBounds( bounds, 10, true );
					break;
				
				
				// Get centre
				case _buttons[8]:
					var ll:LatLng = NativeMaps.service.getCentre();
					trace("Centre: " + ll.toString() );
					break;
				
				
				// Set map type
				case _buttons[9]:
					if (++_mapTypeIndex > 3)
						_mapTypeIndex = 0;
					
					NativeMaps.service.setMapType( mapTypes[_mapTypeIndex] );
					break;
				
				
				// Set map options (enabled interaction)
				case _buttons[10]:
					var options:MapOptions = NativeMaps.service.mapOptions;
					options.trafficEnabled = true;
					options.compassEnabled = true;
					options.zoomControlsEnabled = true;
					options.zoomGesturesEnabled = true;
					options.scrollGesturesEnabled = true;
					options.tiltGesturesEnabled = true;
					options.rotateGesturesEnabled = true;
					options.myLocationButtonEnabled = true;
					NativeMaps.service.setMapOptions( options );
					break;
				
				
				// Set map options (disabled interaction)
				case _buttons[11]:
					var options:MapOptions = NativeMaps.service.mapOptions;
					options.trafficEnabled = false;
					options.compassEnabled = false;
					options.zoomControlsEnabled = false;
					options.zoomGesturesEnabled = false;
					options.scrollGesturesEnabled = false;
					options.tiltGesturesEnabled = false;
					options.rotateGesturesEnabled = false;
					options.myLocationButtonEnabled = false;
					NativeMaps.service.setMapOptions( options );
					break;
				
				
				// Turn on/off user location stuff
				case _buttons[12]:
					if (!NativeMaps.service.showingUserLocation)
						NativeMaps.service.showUserLocation(true);
					else
						NativeMaps.service.showUserLocation(false);
					break;
				
				
				// Add marker
				case _buttons[13]:
					
					NativeMaps.service.drawMapToBitmapData();
					
					// The old example marker
					var marker:MapMarker = new MapMarker("test1");
					marker.title = "Test Marker";
					marker.info = "This is a test marker alright.";
					marker.setPosition( new LatLng(-37, 144) );
					marker.draggable = true;
					marker.animatesDrop = true;
					marker.infoWindowEnabled = true;
					marker.showInfoWindowButton = false;
					
					if (NativeMaps.service.getCustomIconById("myCustomIcon") == null)
					{
						var bmp:Bitmap = new CustomMarker() as Bitmap;
						var icon:CustomMarkerIcon = new CustomMarkerIcon("myCustomIcon", bmp.bitmapData);
						NativeMaps.service.addCustomMarkerIcon(icon);
					}
					
					marker.customIconId = "myCustomIcon";
	
					NativeMaps.service.addMarker( marker );
					
					break;
				
				
				// Add marker 2 
				case _buttons[14]:
					
					var test:MapMarker = NativeMaps.service.getMarkerByName("test1");
					test.setPosition( new LatLng(-33.8, 151.2) );
					
					NativeMaps.service.updateMarker( test );
					return;
					
					var marker2:MapMarker = new MapMarker("test2");
					marker2.title = "Sydney";
					marker2.info = "This is the Sydney marker.";
					marker2.setPosition( new LatLng(-33.8, 151.2) );
					
					marker2.draggable = true; // this was false
					marker2.animatesDrop = true; // this was flalse
					marker2.infoWindowEnabled = true;
					marker2.showInfoWindowButton = true; // this was false
					
					//marker2.customIconId = "myCustomIcon";
					
					// I stopped setting the colour
					if (Capabilities.version.indexOf("AND") != -1)
						marker2.colour = MapMarkerColour.AND_ROSE;
					else
						marker2.colour = MapMarkerColour.IOS_GREEN;
						
					
					trace("added marker : " + NativeMaps.service.addMarker( marker2 ));
					
					break;
				
				
				// Remove marker
				case _buttons[15]:
					NativeMaps.service.removeMarker( 0 );
					break;
				
				
				// Clear map
				case _buttons[16]:
					NativeMaps.service.clearMap();
					break;
				
				
				// Switch marker values 	(marker 2)
				case _buttons[17]:
					if (NativeMaps.service.getMarkerByName("test2") == null)
						return;
					
					if (NativeMaps.service.getMarkerByName("test2").draggable)
					{
						if (Capabilities.version.indexOf("AND") != -1)
							NativeMaps.service.getMarkerByName("test2").colour = MapMarkerColour.AND_AZURE;
						else
							NativeMaps.service.getMarkerByName("test2").colour = MapMarkerColour.IOS_GREEN;
						
						NativeMaps.service.getMarkerByName("test2").draggable = false;
					}
					else
					{
						if (Capabilities.version.indexOf("AND") != -1)
							NativeMaps.service.getMarkerByName("test2").colour = MapMarkerColour.AND_ROSE;
						else
							NativeMaps.service.getMarkerByName("test2").colour = MapMarkerColour.IOS_RED;
						
						NativeMaps.service.getMarkerByName("test2").draggable = true;
					}
					
					NativeMaps.service.updateMarker( "test2" );
					
					break;
				
				
				case _buttons[18]:
					NativeMaps.service.showInfoWindow( NativeMaps.service.getMarkerIdByName("test2") );
					break;
				
				
				case _buttons[19]:
					NativeMaps.service.hideInfoWindow( NativeMaps.service.getMarkerIdByName("test2") );
					break;
				
				
				case _buttons[20]:
					NativeMaps.service.hideMap();
					//NativeMaps.service.setUserFollowMode( UserTrackingMode.FOLLOW );
					break;
				
				
				case _buttons[21]:
					//NativeMaps.service.showMap();
					NativeMaps.service.requestMapBitmapData();
					trace("Android Google Play Legal Notice");
					//trace(NativeMaps.service.getGooglePlayLegalNotice());
					break;
			}
		}
		
		
		
		
		
		
		
		
		/// Callback Events from Map
		
		private function map_createdHandler( event:NativeMapEvent ):void
		{
			trace("Map created!");
		}
		
		private function map_moveCompleteHandler( event:NativeMapEvent ):void
		{
			trace("Map Move Complete : " + event.position.toString() );
		}
		
		private function map_touchedHandler( event:NativeMapEvent ):void
		{
			trace("Map Touched : " + event.position.toString() );
			
			trace( "Map touched at: " + event.position.lat + ", " + event.position.lon );
			
			//NativeMaps.service.getPolyline(0).addPoint( new LatLng(event.position.lat, event.position.lon) );
			//NativeMaps.service.updatePolygon(0);
			
			
		}
		
		private function map_markerTouchedHandler( event:NativeMapEvent ):void
		{
			trace("Marker Touched : " + event.markerId );
		}
		
		private function map_infoWindowTouchedHandler( event:NativeMapEvent ):void
		{
			trace("Info Window Touched for marker : " + event.markerId );
		}
		
		private function map_markerDragStartHandler( event:NativeMapEvent ):void
		{
			trace("Marker Drag Started : " + event.markerId );
		}
		
		private function map_markerDragEndHandler( event:NativeMapEvent ):void
		{
			trace("Marker Drag Ended : " + event.markerId + " at: " + event.position.toString() );
		}
		
		private function map_userLocationUpdateHandler( event:NativeMapEvent ):void
		{
			trace("User Location Updated at: " + event.position.toString() );
		}
		
		private function map_userLocationErrorHandler( event:NativeMapEvent ):void
		{
			trace("User Location Error: " + event.data );
		}
		
		
		
		
		
		
		
		//// Internal functions ////
		
		protected function createUI( ):void
		{
			for each (var b:Sprite in _buttons)
			{
				b.removeEventListener( MouseEvent.CLICK, mouseClickHandler, false );
				if (contains(b)) removeChild(b);
				b = null;
			}
			
			_buttons = [];
			
			_buttons.push( createButton("Create Map") );
			_buttons.push( createButton("Set Layout") );
			_buttons.push( createButton("Set Centre") );
			_buttons.push( createButton("Zoom In") );
			_buttons.push( createButton("Zoom Out") );
			_buttons.push( createButton("Set Zoom") );
			_buttons.push( createButton("Get Zoom") );
			_buttons.push( createButton("Set Bounds") );
			_buttons.push( createButton("Get Centre") );
			_buttons.push( createButton("Switch Map Type") );
			_buttons.push( createButton("Set Options On") );
			_buttons.push( createButton("Set Options Off") );
			_buttons.push( createButton("User Loc On/Off") );
			_buttons.push( createButton("Add Marker 1") );
			_buttons.push( createButton("Add Marker 2") );
			_buttons.push( createButton("Remove Marker 1") );
			_buttons.push( createButton("Clear Map") );
			_buttons.push( createButton("Switch Draggable") );
			_buttons.push( createButton("Show Info Wdw") );
			_buttons.push( createButton("Hide Info Wdw") );
			_buttons.push( createButton("UserFollow On") );
			_buttons.push( createButton("Get Legal (AND)") );
			
			for each (var b:Sprite in _buttons)
			{
				if (b != _buttons[0])
					b.alpha = 0.6;
				 
				addChild( b );
				b.addEventListener( MouseEvent.CLICK, mouseClickHandler, false, 0, true );
			}
			
			layout();
			
			if (!_initialised)
			{
				try
				{
					NativeMaps.init( _devKey );
					
					trace( "NativeMaps Supported: "+ String(NativeMaps.isSupported) );
					trace( "NativeMaps Version: " + NativeMaps.service.version );
					
					NativeMaps.service.addEventListener( NativeMapEvent.MAP_CREATED, map_createdHandler );
					NativeMaps.service.addEventListener( NativeMapEvent.MAP_MOVE_COMPLETE, map_moveCompleteHandler );
					NativeMaps.service.addEventListener( NativeMapEvent.MAP_TOUCHED, map_touchedHandler );
					NativeMaps.service.addEventListener( NativeMapEvent.MARKER_DRAG_START, map_markerDragStartHandler );
					NativeMaps.service.addEventListener( NativeMapEvent.MARKER_DRAG_END, map_markerDragEndHandler );
					NativeMaps.service.addEventListener( NativeMapEvent.MARKER_TOUCHED, map_markerTouchedHandler );
					NativeMaps.service.addEventListener( NativeMapEvent.MARKER_INFO_WINDOW_TOUCHED, map_infoWindowTouchedHandler );
					NativeMaps.service.addEventListener( NativeMapEvent.USER_LOCATION_ERROR, map_userLocationErrorHandler );
					NativeMaps.service.addEventListener( NativeMapEvent.USER_LOCATION_UPDATE, map_userLocationUpdateHandler );
					NativeMaps.service.addEventListener( NativeMapBitmapEvent.READY, map_bitmapReadyHandler );
					NativeMaps.service.addEventListener( NativeMapBitmapEvent.FAILED, map_bitmapFailedHandler );
				
					_initialised = true;
				}
				catch (e:Error)
				{
					trace( e.message );
				}
			}
		}
		private var _initialised : Boolean = false;
		protected function onStageResize(event:Event):void
		{
			createUI(); 
		}		
		
		protected function layout():void
		{
			var xp:Number = 10;
			var yp:Number = stage.stageHeight * 0.55;
			
			for (var i:int = 0; i < _buttons.length; i++)
			{
				_buttons[i].x = xp;
				_buttons[i].y = yp;
				
				xp += _buttons[i].width * 1.1;
				
				if (xp > (stage.stageWidth - (_buttons[i].width * 1.1)))
				{
					yp += _buttons[i].height * 1.1;
					xp = 10;
				}
			}
		}
		
		
		public function message(txt:String):void
		{
			trace("> " + message);
		}2
		
		
		public function createButton( label:String ):Sprite
		{
			var s:Sprite = new Sprite();
			
			s.graphics.lineStyle( 1, 0x0000FF );
			s.graphics.beginFill(0x222222, 1);
			s.graphics.drawRoundRect(0, 0, stage.stageWidth*0.22, stage.stageHeight*0.05, 7, 7);
			s.graphics.endFill();
			
			var t:TextField = new TextField();
			t.text = label;
			
			var tf:TextFormat = t.defaultTextFormat;
			tf.size = int(stage.stageWidth/42);
			tf.font = "Helvetica";
			tf.align = TextFormatAlign.CENTER;
			t.setTextFormat(tf);

			
			t.textColor = 0xFFFFFF;
			t.selectable = false;
			t.mouseEnabled = false;
			t.width = s.width*0.95;
			t.height = s.height;
			t.x = (s.width * 0.025);
			t.y = (s.height * 0.5) - (t.textHeight*0.5);

			s.addChild( t );

		
			return s;
		}
		
		
		protected function map_bitmapReadyHandler( event:NativeMapBitmapEvent ):void
		{
			trace("Bitmap ready!!");
			trace("width: " + event.bitmapData.width);
			
			NativeMaps.service.destroyMap();
			var bmp:Bitmap = new Bitmap(event.bitmapData);
			bmp.x = 10;
			bmp.y = 10;
			addChild( bmp );
		}
		
		protected function map_bitmapFailedHandler( event:NativeMapBitmapEvent ):void
		{
			trace("Bitmap failed!");
		}
		
	}
}

