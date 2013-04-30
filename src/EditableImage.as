package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.ui.MouseCursorData;
	
	import flashx.textLayout.events.UpdateCompleteEvent;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.ResizeEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import utils.CustomMouse;
	
	
	public class EditableImage extends Sprite
	{
		
		private var _image:Image;
		private var _selected:Boolean;
		private var _imageUI:Sprite;
		private var _anchorsArray:Array;
		//anchors
		private var _topLeftAnchor:Quad;
		private var _topMidAnchor:Quad;
		private var _topRightAnchor:Quad;
		private var _midLeftAnchor:Quad;
		private var _midRightAnchor:Quad;
		private var _botLeftAnchor:Quad;
		private var _botMidAnchor:Quad;
		private var _botRightAnchor:Quad;
		private var _resizeDirection:int;
		
		public function EditableImage(image:Image)
		{
			_image = image;
			addChild(_image);
			_image.useHandCursor = true;
			_image.addEventListener(TouchEvent.TOUCH, onTouch);
			_imageUI = new Sprite();
			_imageUI.visible = false;
			addChild(_imageUI);
			
			setupAnchorPoints();
			
		}
		
		private function onTouch(e:TouchEvent):void {
			
			var image:Image = Image(e.currentTarget);
			var beganTouch:Touch = e.getTouch(image, TouchPhase.BEGAN);
			var hoverTouch:Touch = e.getTouch(image, TouchPhase.HOVER);
			var moveTouch:Touch = e.getTouch(image, TouchPhase.MOVED);
			
			if(hoverTouch){
				CustomMouse.setMouse("move_cursor");
				select(true);
			}
			
			if(moveTouch){
				
				this.x += moveTouch.getMovement(this.parent).x;
				this.y += moveTouch.getMovement(this.parent).y;
				
			}
			
			
		}
		
		public function select(value:Boolean):void {
			
			_selected = value;
			
			if(value)
				_imageUI.visible = true;
			else
				_imageUI.visible = false;
		}
		
		private function setupAnchorPoints():void {
			
			_anchorsArray = new Array();
			
			_anchorsArray[1] = _topLeftAnchor = new Quad(10, 10, 0x0000ff);  _topLeftAnchor.name = "topLeft";
			_anchorsArray[2] = _topMidAnchor = new Quad(10, 10, 0x0000ff);   _topMidAnchor.name = "topMid";
			_anchorsArray[3] = _topRightAnchor = new Quad(10, 10, 0x0000ff); _topRightAnchor.name = "topRight";
			_anchorsArray[4] = _midLeftAnchor = new Quad(10, 10, 0x0000ff);  _midLeftAnchor.name = "midLeft";
			_anchorsArray[6] = _midRightAnchor = new Quad(10, 10, 0x0000ff); _midRightAnchor.name = "midRight";
			_anchorsArray[7] = _botLeftAnchor = new Quad(10, 10, 0x0000ff);  _botLeftAnchor.name = "botLeft";
			_anchorsArray[8] = _botMidAnchor = new Quad(10, 10, 0x0000ff);   _botMidAnchor.name = "botMid";
			_anchorsArray[9] = _botRightAnchor = new Quad(10, 10, 0x0000ff); _botRightAnchor.name = "botRight";
			
			var xCounter:Number = 0;
			var yCounter:Number = 0;
			
			for(var i:int = 1; i <= 9; i++){
				
				if(i != 5){
					
					_anchorsArray[i].pivotX = _anchorsArray[i].width / 2;
					_anchorsArray[i].pivotY = _anchorsArray[i].height / 2;
					_anchorsArray[i].x = xCounter * _image.width; 
					_anchorsArray[i].y = yCounter * _image.height;
					
					_imageUI.addChild(_anchorsArray[i]);
				}
				
				xCounter += 0.5;
				
				if(i % 3 == 0){
					xCounter = 0;
					yCounter += 0.5;
				}
			}
			
			_topLeftAnchor.addEventListener(TouchEvent.TOUCH, dualResize);
			_topMidAnchor.addEventListener(TouchEvent.TOUCH, verticalResize);
			_topRightAnchor.addEventListener(TouchEvent.TOUCH, dualResize);
			_midLeftAnchor.addEventListener(TouchEvent.TOUCH, dualResize);
			_midRightAnchor.addEventListener(TouchEvent.TOUCH, dualResize);
			_botLeftAnchor.addEventListener(TouchEvent.TOUCH, dualResize);
			_botMidAnchor.addEventListener(TouchEvent.TOUCH, verticalResize);
			_botRightAnchor.addEventListener(TouchEvent.TOUCH, dualResize);
			
			//we need to recalculate the pivot since we are altering the image.
			this.pivotX = this.width / 2;
			this.pivotY = this.height / 2;
		}
		
		private function dualResize(e:TouchEvent):void {
			
			
			
		}
		
		private function verticalResize(e:TouchEvent):void {
			var anchor:Quad = Quad(e.currentTarget);
			var beganTouch:Touch = e.getTouch(anchor, TouchPhase.BEGAN);
			var hoverTouch:Touch = e.getTouch(anchor, TouchPhase.HOVER);
			var moveTouch:Touch = e.getTouch(anchor, TouchPhase.MOVED);
			
			
			//change the mouse appereance
			if(hoverTouch){
				CustomMouse.setMouse("resize_vertical");
			}
			else {
				CustomMouse.setAuto();
			}
			
			//configure the new pivot and position
			if(beganTouch){
				if(anchor.name == "topMid"){
					_image.pivotX = _image.width;
					_image.pivotY = _image.height;
					_image.x += _image.width;
					_image.y += _image.height;
					_resizeDirection = -1;
				}
				else {
					_image.pivotX = 0;
					_image.pivotY = 0;
				/*	_image.x -= _image.width;
					_image.y -= _image.height;*/
					_resizeDirection = 1;
				}
			}
			
			//resize
			if(moveTouch){
				trace(moveTouch.getMovement(this.parent).y * _resizeDirection);
				_image.height += moveTouch.getMovement(this.parent).y * _resizeDirection;
				
				if(anchor.name == "topMid"){
					_topLeftAnchor.y += moveTouch.getMovement(this.parent).y;
					_topMidAnchor.y += moveTouch.getMovement(this.parent).y;
					_topRightAnchor.y += moveTouch.getMovement(this.parent).y;
				}
				else {
					_botLeftAnchor.y += moveTouch.getMovement(this.parent).y;
					_botMidAnchor.y += moveTouch.getMovement(this.parent).y;
					_botRightAnchor.y += moveTouch.getMovement(this.parent).y;
				}
				
			}
				
				
			
			
		}
		
		private function horizontalResize(e:TouchEvent):void {
			
			
			
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}