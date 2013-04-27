package
{
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.ClippedSprite;
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	import utils.ExtendedButton;
	import utils.ResourceManager;
	
	public class DropDownContainer extends Sprite
	{
		//the direction the arrow is facing to
		private static const TO_THE_RIGHT:String = "toTheRight";
		private static const TO_THE_LEFT:String = "toTheLeft";
		
		private var _actionsSection:Sprite;
		private var _images:Vector.<Image>;
		private var _description:TextField;
		private var _direction:String = TO_THE_RIGHT; 
		private var _actionButtons:Array; 
		private var _arrow:Image;
		private var _imageThumbsContainer:ClippedSprite;
		private var _imageThumbs:Vector.<Image>;
		private var _imagePreviewContainer:Sprite;
		private var _componentWidth:int;
		private var _componentHeight:int;
		
		public function DropDownContainer(description:String, actionButtons:Vector.<ExtendedButton> = null)
		{
				
			var quad:Quad = new Quad(180, 25, 0xEEEDED);
			addChild(quad);
			
			_imageThumbs = new Vector.<Image>;
			
			_imagePreviewContainer = new Sprite()
			_imagePreviewContainer.addChild(new Image(ResourceManager.getInstance().getTexture("image_preview_container")));
			_imagePreviewContainer.pivotX = _imagePreviewContainer.width / 2;
			_imagePreviewContainer.pivotY = _imagePreviewContainer.height / 2;
			
			_arrow = new Image(ResourceManager.getInstance().getTexture("arrow"));
			_arrow.pivotX = _arrow.width / 2;
			_arrow.pivotY = _arrow.height / 2;
			
			_actionsSection = new Sprite();
			_actionButtons = new Array();
			
			//here we add the images
			_imageThumbsContainer = new ClippedSprite();
			addChild(_imageThumbsContainer);
			
			_description = new TextField(100, 25, description);
			_description.pivotY = _description.height / 2;
			
			setDirection(_direction);
			
		}
		
		//here we set the initial amount of images that the component will comprehend
		public function setContent(images:Vector.<Image>):void {
			_images = images;
			createThumbs();
		}
		
		//4 thumbs per row
		private function createThumbs():void {
			
			var counter:int = 0;
			var row:int = 0;
			_componentHeight = this.height;
			_componentWidth = this.width;
			
			for(var i:int; i < _images.length; i ++){
			
				if(counter == 4){
					counter = 0;
					row ++;
				}
				
				var image:Image = new Image(_images[i].texture);
				image.width = 45;
				image.height = 45;
				image.name = _images[i].name;
				
				image.addEventListener(TouchEvent.TOUCH, onImageTouch);
					
				image.x = counter * 45;
				image.y = row * 45 + _componentHeight;
				
				_imageThumbs.push(image);
				
				_imageThumbsContainer.addChild(_imageThumbs[i]);
				
				counter ++;	
			}
		}
		
		private function onImageTouch(e:TouchEvent):void {
			
			var touch:Touch = e.touches[0];
			var image:Image = Image(e.currentTarget);
			
			if(touch.phase == TouchPhase.HOVER){
				
				addChild(_imagePreviewContainer);
				_imagePreviewContainer.x = _componentWidth + 5;
				_imagePreviewContainer.y = image.y + image.height / 2;
				
				var previewImage:Image = getImageByName(image.name);
				
				_imagePreviewContainer.addChild(previewImage);
				
				
			}
			
			
			
		}
		
		private function getImageByName(name:String):Image {
			
			for(var i:int; i < _images.length; i ++){
				
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
			_description.y = this.height / 2;
			//_description.border = true;
			if(direction == TO_THE_LEFT){
				_arrow.x = 15;
				_arrow.rotation = Math.PI;
				_description.hAlign = HAlign.RIGHT;
				_description.pivotX = _description.width;
				_description.x = this.width - 5;
			}
			else {
				_description.x = 5;
				_arrow.x = this.width - 15;
				_description.hAlign = HAlign.LEFT;
			}
			
			addChild(_arrow);
			addChild(_description);
			
		}
		
		private function rotateArrow():void {
			
			
			
		}
		
		//proceed to show the images stored inside this component
		private function showImages():void {
			rotateArrow();
			
			
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}