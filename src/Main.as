package
{
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
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
			_libraryContainer = new ScrollContainer(180, stage.stageHeight, 0xD4D9DD);
			_libraryContainer.x = 0;
			addChild(_libraryContainer);
			
			//layers
			_layersContainer = new ScrollContainer(180, stage.stageHeight, 0xD4D9DD);
			_layersContainer.x = stage.stageWidth - _layersContainer.width;
			addChild(_layersContainer);
			
			_layersContainer.x = stage.stageWidth - _layersContainer.width;
			
			//here we draw the stuff
			_board = new Sprite();
			_board.addChild(new Quad(stage.width - _layersContainer.width - _libraryContainer.width, stage.height, 0xffffff));
			_board.x = _libraryContainer.width;
			addChildAt(_board, 0);
			
			addEventListener("addImage", onAddImage);
			
			initLibrary();
				
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
			
			//ddc1
			var images:Vector.<Image>;
			images = new Vector.<Image>;
			
			var image1:Image = new Image(ResourceManager.getInstance().getTexture("car_1")); image1.name = "car1";
			image1.pivotX = image1.width / 2; image1.pivotY = image1.height / 2;
			var image2:Image = new Image(ResourceManager.getInstance().getTexture("car_2")); image2.name = "car2"; 
			image2.pivotX = image2.width / 2; image2.pivotY = image2.height / 2;
			var image3:Image = new Image(ResourceManager.getInstance().getTexture("car_3")); image3.name = "car3"; 
			image3.pivotX = image3.width / 2; image3.pivotY = image3.height / 2;
			
			images.push(image1, image2, image3, image1, image2, image3, image2, image1, image3, image1);
			
			var ddc1:DropDownContainer = new DropDownContainer("Cars");
			ddc1.setContent(images);
			
			_libraryContainer.addElement(ddc1);
			
			//ddc2
			var images2:Vector.<Image>;
			images2 = new Vector.<Image>;
			
			var image4:Image = new Image(ResourceManager.getInstance().getTexture("toy_1")); image4.name = "toy1";
			image4.pivotX = image4.width / 2; image4.pivotY = image4.height / 2;
			var image5:Image = new Image(ResourceManager.getInstance().getTexture("toy_2")); image5.name = "toy2";
			image5.pivotX = image5.width / 2; image5.pivotY = image5.height / 2;
			var image6:Image = new Image(ResourceManager.getInstance().getTexture("toy_3")); image6.name = "toy3";
			image6.pivotX = image6.width / 2; image6.pivotY = image6.height / 2;
			
			images2.push(image4, image5, image6, image4, image4, image6, image6, image5, image5, image6);
			
			var ddc2:DropDownContainer = new DropDownContainer("Toys");
			ddc2.setContent(images2);
			
			_libraryContainer.addElement(ddc2);
			
			
			
			
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}