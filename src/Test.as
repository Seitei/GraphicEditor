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
	
	public class Test extends Sprite
	{
		private var _quad1:Quad;
		private var _quad2:Quad;
		private static var sHelperPoint:Point = new Point();
		
		private var _sprite1:Sprite;
		private var _sprite2:Sprite;
		
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
			_quad2 = new Quad(stage.stageWidth / 8, stage.stageHeight / 8, 0xff0000);
			_sprite2.addChild(_quad2);
			_sprite2.x = stage.stageWidth / 2;
			_sprite2.y = stage.stageHeight / 2;
			
			_sprite2.pivotX = _sprite2.width;
			_sprite2.pivotY = _sprite2.height;
			_sprite1.addChild(_sprite2);
			
			_sprite2.addEventListener(TouchEvent.TOUCH, onSpriteClicked);
		}
		
		private function onSpriteClicked(e:TouchEvent):void {
			
			var sprite:Sprite = Sprite(e.currentTarget);
			var moveTouch:Touch = e.getTouch(sprite, TouchPhase.MOVED);
			var beganTouch:Touch = e.getTouch(sprite, TouchPhase.BEGAN);
			
			/*if(beganTouch){
				sprite.pivotX = 0;
				sprite.pivotY = 0;
				sprite.x -= sprite.width;
				sprite.y -= sprite.height;
				
			}*/
				
			if(moveTouch){
				//moveTouch.getLocation(sprite.parent, sHelperPoint);	
				
				sprite.height -= moveTouch.getMovement(this.parent).y;
				
				/*sprite.x = sHelperPoint.x;
				sprite.y = sHelperPoint.y;*/
				
			}
		
		}

			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
		
	}
}