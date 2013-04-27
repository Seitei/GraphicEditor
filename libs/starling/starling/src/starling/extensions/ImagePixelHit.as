package starling.extensions
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.SubTexture;
	import starling.textures.Texture;
	
	/**
	 * Pixel Perfect touch image object - pass or stopPropagation for TouchEvent with BEGAN phase
	 * @author
	 */
	public class ImagePixelHit extends Image
	{
		private var _bitmapDataHit:BitmapData;
		private var _threshold:uint;
		
		public function ImagePixelHit ( texture:Texture, bitmapDataHit:BitmapData = null, threshold:uint = 0 )
		{
			super ( texture );
			_bitmapDataHit = bitmapDataHit;
			_threshold = threshold;
		}
		
		override public function hitTest(localPoint:Point, forTouch:Boolean = false):DisplayObject
		{
			if (getBounds(this).containsPoint(localPoint) && _bitmapDataHit )
			{
				var c:Rectangle = SubTexture (texture).clipping; //get clipping rect for object from atlas in %/
				var X:int = localPoint.x + _bitmapDataHit.width * c.x; //recalculate
				var Y:int = localPoint.y + _bitmapDataHit.height * c.y; //recalculate
				return _bitmapDataHit.hitTest ( new Point (0, 0), _threshold, new Point (X, Y) ) ? this : null;
			} else {
				return super.hitTest ( localPoint, forTouch );
			}
			return null;
		}
	}
	
}