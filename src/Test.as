package
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.Color;
	
	public class Test extends Sprite
	{
		private var _quad1:Quad;
		private var _quad2:Quad;
		private static var sHelperPoint:Point = new Point();
		
		private var _sprite1:Sprite;
		private var _sprite2:Sprite;
		private var reverse:Boolean;
		
		public function Test()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void {
			
			
			var quad:Quad = new Quad(100, 100)
			quad.x = stage.stageWidth / 2;
			quad.y = stage.stageHeight / 2;
			addChild(quad);
			var matrix:Matrix = new Matrix();
			matrix.translate(100, 100);
			//matrix.translate(-quad.width / 2, quad.height / 2);
			/*matrix.rotate(3.14159);
			matrix.translate(100, 100);*/
			
			quad.transformationMatrix = matrix;
		}
		
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
		
	}
}