package
{
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;

	public class ScrollContainer extends Sprite
	{
		private var _background:Quad;
		private var _content:Array;
		
		public function ScrollContainer(width:int, height:int, color:uint)
		{
			
			_content = new Array();
			_background = new Quad(width, height, color);	
			addChild(_background);
			
			
		}
		
		public function setColor(color:uint):void{
			
			_background.color = color;
			
		}
		
		public function addElement(element:DisplayObject):void {
			
			_content.push(element);
			addChild(element);
			
		}
		
		
		
	}
}