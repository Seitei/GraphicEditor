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
	import starling.utils.Color;
	
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
		private var _previousAnchor:String;
		private var _originalHeight:Number;
		private var _originalWidth:Number;
		private var _heightIncrement:Number;
		
		public function EditableImage(image:Image)
		{
			_image = image;
			addChild(_image);
			_image.useHandCursor = true;
			_image.addEventListener(TouchEvent.TOUCH, onTouch);
			_imageUI = new Sprite();
			_imageUI.visible = false;
			addChild(_imageUI);
			_originalWidth = _image.width;
			_originalHeight = _image.height;
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
			
			_topLeftAnchor.addEventListener(TouchEvent.TOUCH, diagonalResize);
			_topMidAnchor.addEventListener(TouchEvent.TOUCH, verticalResize);
			_topRightAnchor.addEventListener(TouchEvent.TOUCH, diagonalResize);
			_midLeftAnchor.addEventListener(TouchEvent.TOUCH, horizontalResize);
			_midRightAnchor.addEventListener(TouchEvent.TOUCH, horizontalResize);
			_botLeftAnchor.addEventListener(TouchEvent.TOUCH, diagonalResize);
			_botMidAnchor.addEventListener(TouchEvent.TOUCH, verticalResize);
			_botRightAnchor.addEventListener(TouchEvent.TOUCH, diagonalResize);
			
			//we need to recalculate the pivot since we are altering the image.
			this.pivotX = this.width / 2;
			this.pivotY = this.height / 2;
		}
		
		//////////////////////////////////////////////////////

		private function diagonalResize(e:TouchEvent):void {
			
			var anchor:Quad = Quad(e.currentTarget);
			var beganTouch:Touch = e.getTouch(anchor, TouchPhase.BEGAN);
			var hoverTouch:Touch = e.getTouch(anchor, TouchPhase.HOVER);
			var moveTouch:Touch = e.getTouch(anchor, TouchPhase.MOVED);
			var endedTouch:Touch = e.getTouch(anchor, TouchPhase.ENDED);
			
			//change the mouse appereance
			if(hoverTouch){
				CustomMouse.setMouse("resize_topleft");
			}
			else {
				CustomMouse.setAuto();
			}
			
			//configure the new pivot and position
			if(beganTouch){
				
				if(anchor.name != _previousAnchor || _previousAnchor == ""){
					if(anchor.name == "topLeft"){
						if(_image.pivotX != _originalWidth){
							_image.pivotX = _originalWidth;
							_image.x += _image.width;
						}
						if(_image.pivotY != _originalHeight){
							_image.pivotY = _originalHeight;
							_image.y += _image.height;
						}
						_resizeDirection = -1;
					}
					
					if(anchor.name == "midRight"){
						if(_image.pivotX != 0){
							_image.pivotX = 0;
							_image.x -= _image.width;
						}
						_resizeDirection = 1;
					}
				}
				
				_previousAnchor = anchor.name;
			}
			
			//resize
			if(moveTouch){
				
				var movementX:Number = moveTouch.getMovement(this.parent).x;
				var movementY:Number = moveTouch.getMovement(this.parent).y;
				
				_image.width += movementX * _resizeDirection;
				_image.height += movementY * _resizeDirection;
				
				if(anchor.name == "topLeft"){
					_topLeftAnchor.x += movementX; _topLeftAnchor.y += movementY;
					_topMidAnchor.x += movementX / 2; _topMidAnchor.y += movementY;
					_midLeftAnchor.x += movementX; _midLeftAnchor.y += movementY / 2;
					_botLeftAnchor.x += movementX;
					_botMidAnchor.x += movementX / 2;
					_topRightAnchor.y += movementY;
					_midRightAnchor.y += movementY / 2;
				}
				
				if(anchor.name == "topRight"){ 
					
				}
			}
			
		}
		
		
		//////////////////////////////////////////////////////
		
		private function horizontalResize(e:TouchEvent):void {
			
			var anchor:Quad = Quad(e.currentTarget);
			var beganTouch:Touch = e.getTouch(anchor, TouchPhase.BEGAN);
			var hoverTouch:Touch = e.getTouch(anchor, TouchPhase.HOVER);
			var moveTouch:Touch = e.getTouch(anchor, TouchPhase.MOVED);
			var endedTouch:Touch = e.getTouch(anchor, TouchPhase.ENDED);
			
			//change the mouse appereance
			if(hoverTouch){
				CustomMouse.setMouse("resize_horizontal");
			}
			else {
				CustomMouse.setAuto();
			}
			
			//configure the new pivot and position
			if(beganTouch){
				
				if(anchor.name != _previousAnchor || _previousAnchor == ""){
					if(anchor.name == "midLeft"){
						if(_image.pivotX != _originalWidth){
							_image.pivotX = _originalWidth;
							_image.x += _image.width;
						}
						_resizeDirection = -1;
					}
					
					if(anchor.name == "midRight"){
						if(_image.pivotX != 0){
							_image.pivotX = 0;
							_image.x -= _image.width;
						}
						
						_resizeDirection = 1;
					}
				}
				
				_previousAnchor = anchor.name;
			}
			
			//resize
			if(moveTouch){
				
				var movement:Number = moveTouch.getMovement(this.parent).x;
				
				_image.width += movement * _resizeDirection;
				
				if(anchor.name == "midLeft"){
					_topLeftAnchor.x += movement;
					_midLeftAnchor.x += movement;
					_botLeftAnchor.x += movement;
				}
				else {
					_topRightAnchor.x += movement;
					_midRightAnchor.x += movement;
					_botRightAnchor.x += movement;
				}
				
				_topMidAnchor.x += movement / 2;
				_botMidAnchor.x += movement / 2;
			}
		}
		
		//////////////////////////////////////////////////////
		
		private function verticalResize(e:TouchEvent):void {
			
			var anchor:Quad = Quad(e.currentTarget);
			var beganTouch:Touch = e.getTouch(anchor, TouchPhase.BEGAN);
			var hoverTouch:Touch = e.getTouch(anchor, TouchPhase.HOVER);
			var moveTouch:Touch = e.getTouch(anchor, TouchPhase.MOVED);
			var endedTouch:Touch = e.getTouch(anchor, TouchPhase.ENDED);
			
			//change the mouse appereance
			if(hoverTouch){
				CustomMouse.setMouse("resize_vertical");
			}
			else {
				CustomMouse.setAuto();
			}
			
			//configure the new pivot and position
			if(beganTouch){
				
				if(anchor.name != _previousAnchor || _previousAnchor == ""){
					
					if(anchor.name == "topMid"){
						if(_image.pivotY != _originalHeight){
							_image.pivotY = _originalHeight;
							_image.y += _image.height;
						}
						_resizeDirection = -1;
						
						
					}
					
					if(anchor.name == "botMid"){
						if(_image.pivotY != 0){
							_image.pivotY = 0;
							_image.y -= _image.height;
						}
						_resizeDirection = 1;
					}
				}
				_previousAnchor = anchor.name;
			}
			
			//resize
			if(moveTouch){
				
				var movement:Number = moveTouch.getMovement(this.parent).y;
				
				_image.height += movement * _resizeDirection;
					
				if(anchor.name == "topMid"){
					_topLeftAnchor.y += movement;
					_topMidAnchor.y += movement;
					_topRightAnchor.y += movement;
				}
				else {
					_botLeftAnchor.y += movement;
					_botMidAnchor.y += movement;
					_botRightAnchor.y += movement;
				}
				
				_midLeftAnchor.y += movement / 2;
				_midRightAnchor.y += movement / 2;
			}
			
			if(endedTouch){
				
			}
				
			
		}
		
		
		
	
		
		
		
		
		
		
		
		
		
		
		
		private function drawQuad(xCoord:Number, yCoord:Number, size:int, color:uint):void {
			var quad:Quad = new Quad(size, size, color);
			quad.x = xCoord;
			quad.y = yCoord;
			addChild(quad);
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}