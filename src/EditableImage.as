package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.ui.MouseCursorData;
	
	import flashx.textLayout.events.UpdateCompleteEvent;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.ResizeEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.Color;
	
	import utils.CustomMouse;
	
	
	public class EditableImage extends Sprite
	{
		
		private static const PI:Number = Math.PI;
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
		private var _resizeDirectionX:int;
		private var _resizeDirectionY:int;
		private var _previousAnchor:String;
		private var _originalHeight:Number;
		private var _originalWidth:Number;
		private var _heightIncrement:Number;
		private var _rotationAnchor:Quad;
		private var _rotationVector:Point;
		private var _border:Sprite;
		private var _finalWidth:Number;
		private var _finalHeight:Number;
		
		public function EditableImage(image:Image)
		{
			_image = image;
			addChild(_image);
			
			_image.pivotX = _image.width / 2; 
			_image.pivotY = _image.height / 2;
			_image.x = _image.width / 2;
			_image.y = _image.height / 2;
			
			var text:TextField = new TextField(_image.width, _image.height, "");
			text.border;
			_image.useHandCursor = true;
			_image.addEventListener(TouchEvent.TOUCH, onTouch);
			_imageUI = new Sprite();
			_imageUI.visible = false;
			addChild(_imageUI);
			_originalWidth = _image.width;
			_originalHeight = _image.height;
			_rotationVector = new Point();
			createBorder();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			select(true);
		}
		
		public function createBorder():void
		{
			_finalWidth = 0;
			_finalHeight = 0;
			_border = new Sprite();
			_border.touchable = false;
			//_border.visible = false;
			addChild(_border);
				
			for (var i:int=0; i<4; ++i)
				_border.addChild(new Quad(1.0, 1.0));
				
			updateBorder();
		}
		
		private function updateBorder(anchor:String = "", valueX:Number = NaN, valueY:Number = NaN):void
		{
			
			var topLine:Quad    = _border.getChildAt(0) as Quad;
			var rightLine:Quad  = _border.getChildAt(1) as Quad;
			var bottomLine:Quad = _border.getChildAt(2) as Quad;
			var leftLine:Quad   = _border.getChildAt(3) as Quad;
			
			if(anchor == "midRight"){
				topLine.width    += valueX;
				bottomLine.width += valueX;
				rightLine.x 	 += valueX;
			}
			
			if(anchor == "midLeft"){
				topLine.width    += valueX;
				topLine.x        += valueX * _resizeDirectionX;
				bottomLine.width += valueX;
				bottomLine.x     += valueX * _resizeDirectionX;
				leftLine.x  	 += valueX * _resizeDirectionX;
			}
			
			if(anchor == "topMid"){
				topLine.y        -= valueY;
				leftLine.height  -= valueY * _resizeDirectionY;
				leftLine.y 		 += valueY * _resizeDirectionY;
				rightLine.height -= valueY * _resizeDirectionY;
				rightLine.y 	 += valueY * _resizeDirectionY;
			}
			
			if(anchor == "botMid"){
				bottomLine.y     += valueY;
				leftLine.height  += valueY * _resizeDirectionY;
				rightLine.height += valueY * _resizeDirectionY;
			}
			
			if(anchor == "topRight"){
				topLine.width    += valueX;
				bottomLine.width += valueX;
				rightLine.x 	 += valueX;
				topLine.y        -= valueY;
				leftLine.height  -= valueY * _resizeDirectionY;
				leftLine.y 		 += valueY * _resizeDirectionY;
				rightLine.height -= valueY * _resizeDirectionY;
				rightLine.y 	 += valueY * _resizeDirectionY;
			}
			
			if(anchor == "topLeft"){
				topLine.width    += valueX;
				topLine.x        += valueX * _resizeDirectionX;
				bottomLine.width += valueX;
				bottomLine.x     += valueX * _resizeDirectionX;
				leftLine.x  	 += valueX * _resizeDirectionX;
				topLine.y        -= valueY;
				leftLine.height  -= valueY * _resizeDirectionY;
				leftLine.y 		 += valueY * _resizeDirectionY;
				rightLine.height -= valueY * _resizeDirectionY;
				rightLine.y 	 += valueY * _resizeDirectionY;
			}
			
			if(anchor == "botLeft"){
				topLine.width    += valueX;
				topLine.x        += valueX * _resizeDirectionX;
				bottomLine.width += valueX;
				bottomLine.x     += valueX * _resizeDirectionX;
				leftLine.x  	 += valueX * _resizeDirectionX;
				bottomLine.y     += valueY;
				leftLine.height  += valueY * _resizeDirectionY;
				rightLine.height += valueY * _resizeDirectionY;
			}
			
			if(anchor == "botRight"){
				bottomLine.y     += valueY;
				leftLine.height  += valueY * _resizeDirectionY;
				rightLine.height += valueY * _resizeDirectionY;
				topLine.width    += valueX;
				bottomLine.width += valueX;
				rightLine.x 	 += valueX;
			}
			
			
			
			if(anchor == ""){
				topLine.width    = _image.width;
				bottomLine.width = _image.width;
				bottomLine.y     = _image.height - 1;
				rightLine.height = _image.height;
				rightLine.x 	 = _image.width; - 1;
				leftLine.height  = _image.height;
			}
			
			
			
			
			
			
			
			
			
			topLine.color = rightLine.color = bottomLine.color = leftLine.color = Color.BLUE;
		}
		
		private function onAdded(e:Event):void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			setupAnchorPoints();
		}
		
		private function onKeyDown(e:KeyboardEvent):void {
			if(e.keyCode == Keyboard.DELETE){
				dispatchEventWith("deleteImage", true, this);
			}
		}
		
		private function onTouch(e:TouchEvent):void {
			
			var image:Image = Image(e.currentTarget);
			var beganTouch:Touch = e.getTouch(image, TouchPhase.BEGAN);
			var hoverTouch:Touch = e.getTouch(image, TouchPhase.HOVER);
			var moveTouch:Touch = e.getTouch(image, TouchPhase.MOVED);
			
			if(hoverTouch){
				CustomMouse.setMouse("move_cursor");
				_border.visible = true;
			}
			
			if(!hoverTouch && !_selected) {
				_border.visible = false;
			}
			
			if(beganTouch){
				select(true);
			}
			
			if(moveTouch){
				this.x += moveTouch.getMovement(this.parent).x;
				this.y += moveTouch.getMovement(this.parent).y;
			}
		}
		
		public function select(value:Boolean):void {
			
			_selected = value;
			
			if(value){
				_border.visible = true;				
				_imageUI.visible = true;
			}
			else{
				_imageUI.visible = false;
			}
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
			_rotationAnchor = new Quad(10, 10, Color.AQUA);
			
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
			
			/*_rotationAnchor.pivotX = _rotationAnchor.width / 2;
			_rotationAnchor.pivotY = _rotationAnchor.height / 2;
			
			_rotationAnchor.x = _topMidAnchor.x;
			_rotationAnchor.y = _topMidAnchor.y - 15;
			
			_imageUI.addChild(_rotationAnchor);*/
			/*_imageUI.pivotX = _originalWidth / 2;
			_imageUI.pivotY = _originalHeight / 2;
			_imageUI.x = _imageUI.pivotX
			_imageUI.y = _imageUI.pivotY*/
			
			_topLeftAnchor.addEventListener(TouchEvent.TOUCH, diagonalResize);
			_topMidAnchor.addEventListener(TouchEvent.TOUCH, verticalResize);
			_topRightAnchor.addEventListener(TouchEvent.TOUCH, diagonalResize);
			_midLeftAnchor.addEventListener(TouchEvent.TOUCH, horizontalResize);
			_midRightAnchor.addEventListener(TouchEvent.TOUCH, horizontalResize);
			_botLeftAnchor.addEventListener(TouchEvent.TOUCH, diagonalResize);
			_botMidAnchor.addEventListener(TouchEvent.TOUCH, verticalResize);
			_botRightAnchor.addEventListener(TouchEvent.TOUCH, diagonalResize);
			//_rotationAnchor.addEventListener(TouchEvent.TOUCH, rotate);
			//we need to recalculate the pivot since we are altering the image.
			/*this.pivotX = this.width / 2;
			this.pivotY = this.height / 2;*/
		}
		
		private function rotate(e:TouchEvent):void {
			
			CustomMouse.setMouse("rotate");
			var anchor:Quad = Quad(e.currentTarget);
			var beganTouch:Touch = e.getTouch(anchor, TouchPhase.BEGAN);
			var hoverTouch:Touch = e.getTouch(anchor, TouchPhase.HOVER);
			var moveTouch:Touch = e.getTouch(anchor, TouchPhase.MOVED);
			var endedTouch:Touch = e.getTouch(anchor, TouchPhase.ENDED);
			
			if(beganTouch){
				
				var quad1:Quad = new Quad(5, 5, Color.BLUE);
				quad1.x = _image.pivotX;
				quad1.y = _image.pivotY;
				addChild(quad1);
				
				if(_image.pivotX == 0){
					_image.x += _image.width / 2;
					_image.y += _image.height / 2;
					_image.pivotX = _originalWidth / 2;
					_image.pivotY = _originalHeight / 2;
					
					_imageUI.pivotX = _originalWidth / 2;
					_imageUI.pivotY = _originalHeight / 2;
					_imageUI.x = _imageUI.pivotX
					_imageUI.y = _imageUI.pivotY
				}
				
				if(_image.pivotX == 100){
					_image.x -= _image.width / 2;
					_image.y += _image.height / 2;
					_image.pivotX = _originalWidth / 2;
					_image.pivotY = _originalHeight / 2;
				}
				
				
			}
			
			if(moveTouch){
				
				var xCoord:Number = moveTouch.getLocation(this.parent).x;
				var yCoord:Number = moveTouch.getLocation(this.parent).y;
				
				_rotationVector.x = xCoord;
				_rotationVector.y = yCoord;
				
				var diff:Point = _rotationVector.subtract(new Point(this.x + (_image.width - _originalWidth) / 2, 
																	this.y + (_image.height - _originalHeight) / 2)); 
				
				_image.rotation = Math.atan2(diff.y, diff.x) + PI / 2;
				
				_imageUI.rotation = _image.rotation;
				/*for(var i:int = 1; i <= 9; i++){
					if(i != 5){
						_anchorsArray[i].rotation = -this.rotation;
					}
				}*/
			}
			
			if(endedTouch){
				CustomMouse.setAuto();
			}
			
			_previousAnchor = anchor.name;
		}
		
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
			
			if(beganTouch){
				
				_finalWidth = 0;
				_previousAnchor = anchor.name;
				if(anchor.name == "midRight")
					_resizeDirectionX = 1;
				
				if(anchor.name == "midLeft")
					_resizeDirectionX = -1;
			}
			
			//resize
			if(moveTouch){
				
				var movementX:Number = moveTouch.getMovement(this.parent).x;
				var movementY:Number = moveTouch.getMovement(this.parent).y;
				
				/*transformedMovementX = movementX * Math.cos(_image.rotation); 
				transformedMovementY = movementY * Math.sin(_image.rotation);*/
				
				_finalWidth += movementX * _resizeDirectionX;
				
				updateBorder(anchor.name, movementX * _resizeDirectionX);
				
				if(anchor.name == "midLeft"){
					_topLeftAnchor.x += movementX;
					_midLeftAnchor.x += movementX;
					_botLeftAnchor.x += movementX; 
				}
				else {
					_topRightAnchor.x += movementX;
					_midRightAnchor.x += movementX;
					_botRightAnchor.x += movementX;
				}
				
				_topMidAnchor.x += movementX / 2;
				_botMidAnchor.x += movementX / 2;
				_rotationAnchor.x += movementX / 2;
			}
			
			if(endedTouch){
				CustomMouse.setAuto();
				_image.width += _finalWidth;
				_image.x += (_finalWidth / 2) * _resizeDirectionX;
			}
		}
		
		
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
			
			//configure the new pivot and position
			if(beganTouch){
				_finalHeight = 0;
				if(anchor.name != _previousAnchor || _previousAnchor == ""){
					if(anchor.name == "topMid"){
						_resizeDirectionY = -1;
					}
					
					if(anchor.name == "botMid"){
						_resizeDirectionY = 1;
					}
				}
				_previousAnchor = anchor.name;
			}
			
			//resize
			if(moveTouch){
				
				var movementX:Number = moveTouch.getMovement(this.parent).y;
				var movementY:Number = moveTouch.getMovement(this.parent).y;
				
				_finalHeight += movementY * _resizeDirectionY;
				
				updateBorder(anchor.name, 0, movementY * _resizeDirectionY);
				
				if(anchor.name == "topMid"){
					_topLeftAnchor.y += movementY;
					_topMidAnchor.y += movementY;
					_topRightAnchor.y += movementY;
				}
				else {
					_botLeftAnchor.y += movementY;
					_botMidAnchor.y += movementY;
					_botRightAnchor.y += movementY;
				}
				
				_midLeftAnchor.y += movementY / 2;
				_midRightAnchor.y += movementY / 2;
			}
			
			if(endedTouch){
				CustomMouse.setAuto();
				_image.height += _finalHeight;
				_image.y += (_finalHeight / 2) * _resizeDirectionY;
			}
				
			
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
				if(anchor.name == "topLeft" || anchor.name == "botRight" )
					CustomMouse.setMouse("resize_topleft");
				if(anchor.name == "topRight" || anchor.name == "botLeft")
					CustomMouse.setMouse("resize_topright");
			}
			
			//configure the new pivot and position
			if(beganTouch){
				
				_finalHeight = 0;
				_finalWidth = 0;
				
				if(anchor.name != _previousAnchor || _previousAnchor == ""){
					if(anchor.name == "topLeft"){
						_resizeDirectionX = -1;
						_resizeDirectionY = -1;
					}
					
					if(anchor.name == "topRight"){
						_resizeDirectionX = 1;
						_resizeDirectionY = -1;
					}
					
					if(anchor.name == "botLeft"){
						_resizeDirectionX = -1;
						_resizeDirectionY = 1;
					}
					
					if(anchor.name == "botRight"){
						_resizeDirectionX = 1;
						_resizeDirectionY = 1;
					}
				}
				_previousAnchor = anchor.name;
			}
			
			//resize
			if(moveTouch){
				
				var movementX:Number = moveTouch.getMovement(this.parent).x;
				var movementY:Number = moveTouch.getMovement(this.parent).y;
				
				_finalWidth += movementX * _resizeDirectionX;
				_finalHeight += movementY * _resizeDirectionY;
				
				updateBorder(anchor.name, movementX * _resizeDirectionX, movementY * _resizeDirectionY);
				
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
					_topLeftAnchor.y += movementY;
					_topMidAnchor.x += movementX / 2; _topMidAnchor.y += movementY;
					_topRightAnchor.y += movementY; _topRightAnchor.x += movementX;
					_midLeftAnchor.y += movementY / 2;
					_botMidAnchor.x += movementX / 2;
					_botRightAnchor.x += movementX;
					_midRightAnchor.x += movementX; _midRightAnchor.y += movementY / 2;
				}
				
				if(anchor.name == "botLeft"){ 
					_topLeftAnchor.x += movementX;
					_topMidAnchor.x += movementX / 2;
					_midLeftAnchor.x += movementX; _midLeftAnchor.y += movementY / 2;
					_botMidAnchor.x += movementX / 2; _botMidAnchor.y += movementY;
					_botLeftAnchor.y += movementY; _botLeftAnchor.x += movementX;
					_botRightAnchor.y += movementY;
					_midRightAnchor.y += movementY / 2;
				}
				
				if(anchor.name == "botRight"){ 
					_topRightAnchor.x += movementX;
					_topMidAnchor.x += movementX / 2;
					_midLeftAnchor.y += movementY / 2;
					_midRightAnchor.x += movementX; _midRightAnchor.y += movementY / 2;
					_botMidAnchor.x += movementX / 2; _botMidAnchor.y += movementY;
					_botRightAnchor.y += movementY; _botRightAnchor.x += movementX;
					_botLeftAnchor.y += movementY;
				}
			}
			
			if(endedTouch){
				CustomMouse.setAuto();
				_image.width += _finalWidth;
				_image.height += _finalHeight;
				_image.x += (_finalWidth / 2) * _resizeDirectionX;
				_image.y += (_finalHeight / 2) * _resizeDirectionY;
			}
			
		}
		
		
		//////////////////////////////////////////////////////
		
		
		
		
		
		
		
		
		
		
	
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}