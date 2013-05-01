package
{
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
			
			_sprite1 = new Sprite();
			_quad1 = new Quad(stage.stageWidth, stage.stageHeight, 0x1a1a1a);
			_sprite1.addChild(_quad1);
			addChild(_sprite1);
			
			
			_sprite2 = new Sprite();
			_quad2 = new Quad(100, 100, 0xff0000);
			_sprite2.addChild(_quad2);
			_sprite2.x = stage.stageWidth / 2;
			_sprite2.y = stage.stageHeight / 2;
			
			_sprite1.addChild(_sprite2);
			_quad2.addEventListener(TouchEvent.TOUCH, onSpriteClicked);
			//_quad2.pivotY = _quad2.height;
		}
		
		private function onSpriteClicked(e:TouchEvent):void {
			
			var quad:Quad = Quad(e.currentTarget);
			var moveTouch:Touch = e.getTouch(quad, TouchPhase.MOVED);
			var beganTouch:Touch = e.getTouch(quad, TouchPhase.BEGAN);
			var endedTouch:Touch = e.getTouch(quad, TouchPhase.ENDED);
			
			if(beganTouch){
		
				drawQuad(quad.pivotX, quad.pivotY, 8, Color.GREEN);
				drawQuad(quad.x, quad.y, 5, Color.WHITE);
				
				quad.height += 50;
				if(reverse){
					
					
					quad.pivotY += quad.height;
					quad.y += quad.height;
					
					
					
					
				}
			}
				
			if(moveTouch){
				
				
				quad.height += moveTouch.getMovement(this.parent).y;
				
				trace(quad.pivotY);
				trace(quad.y);
				trace(quad.height);
				
			}
			
			if(endedTouch){
				//reverse = true;
				quad.pivotY += quad.height - 50;
				quad.y += quad.height;
				
				//quad.height += 20;
				drawQuad(quad.pivotX, quad.pivotY, 8, Color.BLACK);
				drawQuad(quad.x, quad.y, 5, Color.LIME);
			}
		
		}

			
		
		
		
		
		
		private function drawQuad(xCoord:Number, yCoord:Number, size:int, color:uint):void {
			var quad:Quad = new Quad(size, size, color);
			quad.x = xCoord;
			quad.y = xCoord;
			_sprite2.addChild(quad);
		}
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
		
	}
}