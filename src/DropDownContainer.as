package
{
	import flash.geom.Rectangle;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.ClippedSprite;
	import starling.text.TextField;
	import starling.utils.Color;
	import starling.utils.HAlign;
	
	import utils.Border;
	import utils.ExtendedButton;
	import utils.ResourceManager;
	
	public class DropDownContainer extends Sprite
	{
		//the direction the arrow is facing to
		private static const TO_THE_RIGHT:String = "toTheRight";
		private static const TO_THE_LEFT:String = "toTheLeft";
		private static const COLLAPSED:String = "collapsed";
		private static const EXPANDED:String = "expanded";
		
		private var _actionsSection:Sprite;
		private var _images:Vector.<Image>;
		private var _descriptionTxt:TextField;
		private var _direction:String = TO_THE_RIGHT; 
		private var _actionButtons:Array; 
		private var _arrow:Image;
		private var _imageThumbsContainer:ClippedSprite;
		private var _imageThumbs:Array;
		private var _imagePreviewContainer:Sprite;
		private var _componentWidth:int;
		private var _componentHeight:int;
		private var _previewing:Boolean;
		private var _previewImageSlot:Sprite;
		private var _status:String;
		private var _description:String;
		private var _hoverQuad:Quad;
		
		public function DropDownContainer(description:String, actionButtons:Vector.<ExtendedButton> = null)
		{
			_status = COLLAPSED;
			_description = description;		
			var quad:Quad = new Quad(180, 25, 0xEEEDED);
			addChild(quad);
			quad.useHandCursor = true;
			quad.addEventListener(TouchEvent.TOUCH, onComponentTouched);
			
			_hoverQuad = new Quad(quad.width, quad.height, 0xffffff);
			_hoverQuad.alpha = 0.2;
			addChild(_hoverQuad);
			_hoverQuad.visible = false;
			_hoverQuad.touchable = false;
			
			_componentHeight = this.height;
			_componentWidth = this.width;
			
			_imageThumbs = new Array();
			
			_imagePreviewContainer = new Sprite();
			var image:Image = new Image(ResourceManager.getInstance().getTexture("image_preview_container"));
			_imagePreviewContainer.addChild(image);
			_previewImageSlot = new Sprite();
			_imagePreviewContainer.addChild(_previewImageSlot);
			_imagePreviewContainer.pivotY = _imagePreviewContainer.height / 2;
			
			_arrow = new Image(ResourceManager.getInstance().getTexture("arrow"));
			_arrow.pivotX = _arrow.width / 2;
			_arrow.pivotY = _arrow.height / 2;
			
			_actionsSection = new Sprite();
			_actionButtons = new Array();
			
			//here we add the images
			_imageThumbsContainer = new ClippedSprite();
			addChild(_imageThumbsContainer);
			
			_descriptionTxt = new TextField(100, 25, description);
			_descriptionTxt.pivotY = _descriptionTxt.height / 2;
			_descriptionTxt.touchable = false;
			
			setDirection(_direction);
		}
		
		public function getContentHeight():int {
			return Math.ceil(_images.length / 4) * 45 + 1;
		}
		
		//we dispatch an event when we click the body of the component

		public function get componentHeight():int {
			return _componentHeight;
		}

		public function collapse():void {
			var cTween:Tween = new Tween(_imageThumbsContainer.clipRect, 0.5, Transitions.EASE_IN_OUT);
			cTween.animate("height", 1);
			Starling.juggler.add(cTween);
			
			var aTween:Tween = new Tween(_arrow, 0.2, Transitions.LINEAR);
			aTween.animate("rotation", 0);
			Starling.juggler.add(aTween);
		}
		
		public function expand():void {
			var eTween:Tween = new Tween(_imageThumbsContainer.clipRect, 0.5, Transitions.EASE_IN_OUT);
			eTween.animate("height", Math.ceil(_images.length / 4) * 45 + 1);
			Starling.juggler.add(eTween);
			
			var aTween:Tween = new Tween(_arrow, 0.2, Transitions.LINEAR);
			aTween.animate("rotation", Math.PI / 2);
			Starling.juggler.add(aTween);
		}
		
		public function get description():String
		{
			return _description;
		}

		public function set setY(y:int):void {
			this.y = y;
			_imageThumbsContainer.clipRect.y = y + _componentHeight - 1;
		}
		
		public function get setY():int {
			return this.y;
		}
		
		
		private function onComponentTouched(e:TouchEvent):void {
			
			var quad:Quad = Quad(e.currentTarget);
			var beganTouch:Touch = e.getTouch(quad, TouchPhase.BEGAN);
			var hoverTouch:Touch = e.getTouch(quad, TouchPhase.HOVER);
			//var moveTouch:Touch = e.getTouch(quad, TouchPhase.MOVED); 
			
			if(beganTouch){
				if(_status == COLLAPSED){
					dispatchEventWith("expand", true, this);
					_status = EXPANDED;						
				}
				else{
					dispatchEventWith("collapse", true, this);
					_status = COLLAPSED;
				}
			}
			
			if(hoverTouch){
				_hoverQuad.visible = true;
			}
			else{
				_hoverQuad.visible = false;
			}
			
		}
		
		//here we set the initial amount of images that the component will comprehend
		public function setContent(images:Vector.<Image>):void {
			_images = images;
			_imageThumbsContainer.clipRect = new Rectangle(this.x, this.y + _componentHeight - 1, _componentWidth, 1); 
			createThumbs();
		}
		
		//4 thumbs per row
		private function createThumbs():void {
			
			var counter:int = 0;
			var row:int = 0;
			
			for(var i:int; i < _images.length; i ++){
			
				if(counter == 4){
					counter = 0;
					row ++;
				}
				
				var thumbContainer:Sprite = new Sprite();
				var image:Image = new Image(_images[i].texture);
				image.width = 45;
				image.height = 45;
				image.name = _images[i].name;
				thumbContainer.addChild(image);
				image.useHandCursor = true;
				image.addEventListener(TouchEvent.TOUCH, onImageTouch);
					
				thumbContainer.x = counter * 45;
				thumbContainer.y = row * 45 + _componentHeight;
				
				_imageThumbs.push(thumbContainer);
				
				_imageThumbsContainer.addChild(_imageThumbs[i]);
				
				counter ++;	
			}
		}
		
		private function onImageTouch(e:TouchEvent):void {
			
			var image:Image = Image(e.currentTarget);
			var beganTouch:Touch = e.getTouch(image, TouchPhase.BEGAN);
			var hoverTouch:Touch = e.getTouch(image, TouchPhase.HOVER);
			
			if(hoverTouch && !_previewing){
				
				_previewing = true;
				
				Border.createBorder(image.width, image.height, Color.BLACK, 1, Sprite(image.parent));
				
				_previewImageSlot.removeChildren();
				addChild(_imagePreviewContainer);
				_imagePreviewContainer.x = _componentWidth + 5;
				_imagePreviewContainer.y = image.parent.y + image.height / 2;
				
				var previewImage:Image = getImageByName(image.name);
				previewImage.x = _imagePreviewContainer.width / 2;
				previewImage.y = _imagePreviewContainer.height / 2;
				
				_previewImageSlot.addChild(previewImage);
				
			}
			
			if(!hoverTouch) {
				_previewing = false;
				image.parent.removeChildren(1, -1, true);
				removeChild(_imagePreviewContainer);
			}
			
			//we dispatch here that we need to add an image to the board
			if(beganTouch){
				var clickedImage:Image = getImageByName(image.name);
				dispatchEventWith("addImage", true, new Image(clickedImage.texture));
			}
			
			
			
		}
		
		private function getImageByName(name:String):Image {
			
			for(var i:int; i < _images.length; i ++){
				//trace(_images[i].name);
				if(_images[i].name == name)
					return _images[i];
				
			}
			
			return null;
			
		}
		
		
		
		
		
		public function setDirection(direction:String):void {
			_direction = direction;
			arrangeComponents(_direction);
		}
		
		private function arrangeComponents(direction:String):void {
			
			_arrow.y = this.height / 2;
			_descriptionTxt.y = this.height / 2;
			//_description.border = true;
			if(direction == TO_THE_LEFT){
				_arrow.x = 15;
				_arrow.rotation = Math.PI;
				_descriptionTxt.hAlign = HAlign.RIGHT;
				_descriptionTxt.pivotX = _descriptionTxt.width;
				_descriptionTxt.x = this.width - 5;
			}
			else {
				_descriptionTxt.x = 5;
				_arrow.x = this.width - 15;
				_descriptionTxt.hAlign = HAlign.LEFT;
			}
			
			addChild(_arrow);
			addChild(_descriptionTxt);
			
		}
		
		private function rotateArrow():void {
			
			
			
		}
		
		//proceed to show the images stored inside this component
		private function showImages():void {
			rotateArrow();
			
			
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}