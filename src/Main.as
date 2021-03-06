package
{
	import flash.ui.Keyboard;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.Color;
	
	import utils.Border;
	import utils.ResourceManager;

	public class Main extends Sprite
	{
		
		private var _libraryContainer:ScrollContainer;
		private var _layersContainer:ScrollContainer;
		private var _board:Sprite;
		private var _images:Vector.<EditableImage>;
		
		public function Main() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			_images = new Vector.<EditableImage>;
		}
		
		private function onAdded(e:Event):void {
			
			// main layout componentes //
			
			// library
			_libraryContainer = new ScrollContainer(180, stage.stageHeight, 0x494949);
			_libraryContainer.x = 0;
			addChild(_libraryContainer);
			
			//layers
			/*_layersContainer = new ScrollContainer(180, stage.stageHeight, 0x494949);
			_layersContainer.x = stage.stageWidth - _layersContainer.width;
			addChild(_layersContainer);
			
			_layersContainer.x = stage.stageWidth - _layersContainer.width;*/
			
			//here we draw the stuff
			_board = new Sprite();
			_board.addChild(new Quad(stage.stageWidth - _libraryContainer.width - 40, stage.stageHeight - 40, 0xffffff));
			Border.createBorder(_board.width, _board.height, Color.BLACK, 1, _board);
			_board.x = _libraryContainer.width + 20;
			_board.y = 20;
			_board.addEventListener(TouchEvent.TOUCH, onBoardTouched);
			addChildAt(_board, 0);
			
			addEventListener("addImage", onAddImage);
			addEventListener("deleteImage", onDeleteImage);
			addEventListener("imageSelected", onImageSelected);
			initLibrary();
		}
		
		private function onImageSelected(e:Event, image:EditableImage):void {
			deSelectImages(image);	
		}
		
		private function onBoardTouched(e:TouchEvent):void {
			var touch:Touch = e.touches[0];
			if(touch.phase == TouchPhase.BEGAN)
				deSelectImages();	
		}
		
		
		
		private function onDeleteImage(e:Event):void {
			for(var i:int = 0; i < _images.length; i++){
				if(_images[i].selected)
					_board.removeChild(_images[i], true);		
			}
		}
		
		public function deSelectImages(image:EditableImage = null):void {
			for(var i:int = 0; i < _images.length; i++){
				if(image != _images[i])
					_images[i].select(false);		
			}
		}
		
		private function onAddImage(e:Event, image:Image):void {
			
			var edImage:EditableImage = new EditableImage(image);
			
			edImage.pivotX = edImage.width / 2;
			edImage.pivotY = edImage.height / 2;
			
			edImage.x = _board.width / 2;
			edImage.y = _board.height / 2;
			
			_images.push(edImage);
			_board.addChild(edImage);
			deSelectImages(edImage);
		}
		
		private function initLibrary():void {
			
			var data:Array = new Array();
			//Cars
			data.push(["Cars", ["car_1", "car_2", "car_3", "car_2", "car_4", "car_1", "car_2", "car_4", "car_3", "car_2", "car_4",
								"car_1", "car_2", "car_3", "car_2", "car_4", "car_1", "car_2", "car_4", "car_3", "car_2", "car_4"]]);
			
			//Toys
			data.push(["Toys", ["toy_1", "toy_2", "toy_3", "toy_2", "toy_4", "toy_1", "toy_2", "toy_4", "toy_3", "toy_2", "toy_4", 
								"toy_1", "toy_2", "toy_3", "toy_2", "toy_4", "toy_1", "toy_2", "toy_4", "toy_3", "toy_2", "toy_4"]]);
			
			//Fruits
			data.push(["Fruits", ["fruit_1", "fruit_2", "fruit_3", "fruit_2", "fruit_4", "fruit_1", "fruit_2", "fruit_4", "fruit_3", "fruit_2", "fruit_4",
								  "fruit_1", "fruit_2", "fruit_3", "fruit_2", "fruit_4", "fruit_1", "fruit_2", "fruit_4", "fruit_3", "fruit_2", "fruit_4"]]);
			
			
			createCategory(data);
		
		}
		
		private function createCategory(data:Array):void {
			
			var elements:Array = new Array();
			
			for(var i:int = 0; i < data.length; i++){
				
				var images:Vector.<Image>;
				images = new Vector.<Image>;
				
				var ddc:DropDownContainer = new DropDownContainer(data[i][0]);
				
				for(var j:int = 1; j < data[i][1].length; j++){
					var image:Image = new Image(ResourceManager.getInstance().getTexture(data[i][1][j]));
					image.name = data[i][1][j];
					image.pivotX = image.width / 2; image.pivotY = image.height / 2;
					images.push(image);
				}
				
				ddc.setContent(images);
				
				elements.push(ddc);
				
			}
			
			_libraryContainer.addElements(elements);
			
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}