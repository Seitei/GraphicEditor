package utils
{
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.display.Sprite;
	
	public class Border
	{
		
		public static function createBorder(width:Number, height:Number, color:uint, thickness:Number = 1, container:Sprite = null):Sprite {

			if(!container) 
				var container:Sprite = new Sprite(); 
			
			for (var i:int=0; i<4; ++i){
				
				var quad:Quad = new Quad(thickness, thickness, color);
				quad.touchable = false;
				container.addChild(quad);
			}
			
			var topLine:Quad    = container.getChildAt(container.numChildren - 4) as Quad;
			var rightLine:Quad  = container.getChildAt(container.numChildren - 3) as Quad;
			var bottomLine:Quad = container.getChildAt(container.numChildren - 2) as Quad;
			var leftLine:Quad   = container.getChildAt(container.numChildren - 1) as Quad;
			
			topLine.width    = width; topLine.height    = thickness;
			bottomLine.width = width; bottomLine.height = thickness;
			leftLine.width   = thickness;     leftLine.height   = height;
			rightLine.width  = thickness;     rightLine.height  = height;
			rightLine.x  = width  - thickness;
			bottomLine.y = height - thickness;
			topLine.color = rightLine.color = bottomLine.color = leftLine.color = color;
			
			return container;
			
		}
		
			
	}
}