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
 * @file   		ParticleAnimationTest.as
 * @brief  		
 * @author 		Michael Archbold
 * @created		Feb 26, 2013
 * @updated		$Date:$
 * @copyright	http://distriqt.com/copyright/license.txt
 */
package com.distriqt.animation.tests
{
	import flash.display.Sprite;
	
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.renderers.DisplayObjectRenderer;
	
	/**	
	 * @author	Michael Archbold
	 */
	public class ParticleAnimationTest extends Sprite
	{
		
		/**
		 *  Constructor
		 */
		public function ParticleAnimationTest( width:Number = 640, height:Number = 480 )
		{
			super();
			
			emitter = new Flock( width, height );
			
			var renderer:DisplayObjectRenderer = new DisplayObjectRenderer();
			renderer.addEmitter( emitter );
			addChild( renderer );
			
			emitter.start( );
		}
		
		
		////////////////////////////////////////////////////////
		//	VARIABLES
		//
		
		private var emitter:Emitter2D;
		
		
		////////////////////////////////////////////////////////
		//	FUNCTIONALITY
		//
		
		
		////////////////////////////////////////////////////////
		//	INTERNALS
		//
		
		
		////////////////////////////////////////////////////////
		//	EVENT HANDLERS
		//
		
		
	}
}



import flash.display.Bitmap;
import flash.display.Sprite;
import flash.geom.Point;

import org.flintparticles.common.counters.Blast;
import org.flintparticles.common.initializers.ImageClass;
import org.flintparticles.twoD.actions.ApproachNeighbours;
import org.flintparticles.twoD.actions.BoundingBox;
import org.flintparticles.twoD.actions.MatchVelocity;
import org.flintparticles.twoD.actions.MinimumDistance;
import org.flintparticles.twoD.actions.Move;
import org.flintparticles.twoD.actions.RotateToDirection;
import org.flintparticles.twoD.actions.SpeedLimit;
import org.flintparticles.twoD.emitters.Emitter2D;
import org.flintparticles.twoD.initializers.Position;
import org.flintparticles.twoD.initializers.Velocity;
import org.flintparticles.twoD.zones.DiscZone;
import org.flintparticles.twoD.zones.RectangleZone;

class Flock extends Emitter2D
{
	
	
	public function Flock( width:Number, height:Number )
	{
		counter = new Blast( 80 );
		
		addInitializer( new ImageClass( Bird ) );
		addInitializer( new Position( new RectangleZone( 10, 10, width-20, height-20 ) ) );
		addInitializer( new Velocity( new DiscZone( new Point( 0, 0 ), 150, 100 ) ) );
		
		addAction( new ApproachNeighbours( 150, 100 ) );
		addAction( new MatchVelocity( 20, 200 ) );
		addAction( new MinimumDistance( 10, 600 ) );
		addAction( new SpeedLimit( 100, true ) );
		addAction( new RotateToDirection() );
		addAction( new BoundingBox( 0, 0, width, height ) );
		addAction( new SpeedLimit( 200 ) );
		addAction( new Move() );
	}
}


class Bird extends Sprite
{
	[Embed( "bird.png" )]
	private var BaseImage:Class;

	private var _image	: Bitmap;
	
	public function Bird()
	{
		_image = new BaseImage() as Bitmap;
		_image.x = - _image.width  * 0.5;
		_image.y = - _image.height * 0.5;
		addChild( _image );
	}
	
}
