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
			
			initLibrary();
				
		}
		
		private function initLibrary():void {
			
			//test
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
			
			
			
			
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}