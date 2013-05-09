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
	import starling.text.TextField;
	import starling.utils.Color;
	
	import utils.ResourceManager;
	
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
			
			
			var quad:Quad = new Quad(100, 100);
			
			quad.x = stage.stageWidth / 2;
			quad.y = stage.stageHeight / 2;
			
			var quad2:Quad = new Quad(100, 100, Color.RED);
			
			quad2.x = stage.stageWidth / 2;
			quad2.y = stage.stageHeight / 2;
			
			addChild(quad2);
			
			var tm:Matrix = quad.transformationMatrix;
			
			var point:Point = new Point(50, 50);
			
			point = tm.transformPoint(point);
			
			tm.translate( -point.x, -point.y); 
			
			tm.rotate(45 * (Math.PI / 180));
			
			tm.translate(point.x, point.y); 
			
			quad.transformationMatrix = tm;
			
			addChild(quad);
			
			
			
			
		}
		
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
		
	}
}