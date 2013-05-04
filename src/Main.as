package
{
	import flash.ui.Keyboard;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.utils.Color;
	
	import utils.Border;
	import utils.ResourceManager;

	public class Main extends Sprite
	{
		
		private var _libraryContainer:ScrollContainer;
		private var _layersContainer:ScrollContainer;
		private var _board:Sprite;
		
		public function Main() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
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
			
			addChildAt(_board, 0);
			
			addEventListener("addImage", onAddImage);
			addEventListener("deleteImage", onDeleteImage);
			initLibrary();
				
		}
		
		private function onDeleteImage(e:Event, image:EditableImage):void {
			_board.removeChild(image);
		}
		
		
		private function onAddImage(e:Event, image:Image):void {
			
			var edImage:EditableImage = new EditableImage(image);
			
			edImage.pivotX = edImage.width / 2;
			edImage.pivotY = edImage.height / 2;
			
			edImage.x = _board.width / 2;
			edImage.y = _board.height / 2;
			
			_board.addChild(edImage);
		}
		
		private function initLibrary():void {
			
			//Cars
			createCategory("Cars", ["car_1", "car_2", "car_3", "car_2", "car_4", "car_1", "car_2", "car_4", "car_3", "car_2", "car_4"]);
			
			//Toys
			createCategory("Toys", ["toy_1", "toy_2", "toy_3", "toy_2", "toy_4", "toy_1", "toy_2", "toy_4", "toy_3", "toy_2", "toy_4"]);
			
			//Fruits
			createCategory("Fruits", ["fruit_1", "fruit_2", "fruit_3", "fruit_2", "fruit_4", "fruit_1", "fruit_2", "fruit_4", "fruit_3", "fruit_2", "fruit_4"]);
			
			
			
		}
		
		private function createCategory(title:String, imageNames:Array):void {
			
			var images:Vector.<Image>;
			images = new Vector.<Image>;
			
			for(var i:int = 0; i < imageNames.length; i++){
				
				var image:Image = new Image(ResourceManager.getInstance().getTexture(imageNames[i]));
				image.name = imageNames[i];
				image.pivotX = image.width / 2; image.pivotY = image.height / 2;
				images.push(image);
				
			}
			
			var ddc:DropDownContainer = new DropDownContainer(title);
			ddc.setContent(images);
			_libraryContainer.addElement(ddc);
			
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}