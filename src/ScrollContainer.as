package
{
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.errors.AbstractClassError;
	import starling.events.Event;

	public class ScrollContainer extends Sprite
	{
		private var _background:Quad;
		private var _content:Array;
		private var _dropDownElements:Vector.<DropDownContainer>;
		
		public function ScrollContainer(width:int, height:int, color:uint)
		{
			
			_content = new Array();
			_dropDownElements = new Vector.<DropDownContainer>;
			
			_background = new Quad(width, height, color);	
			addChild(_background);
			
			addEventListener("collapse", onCollapse);
			addEventListener("expand", onExpand);
			
		}
		
		private function onCollapse(e:Event):void {
			e.data.collapse();
			
			var result:Vector.<DropDownContainer> = _dropDownElements.slice(_dropDownElements.indexOf(e.data) + 1);
			
			for each(var ddc:DropDownContainer in result){
				
				var tween:Tween = new Tween(ddc, 0.7, Transitions.EASE_IN_OUT);
				tween.animate("setY", ddc.y - e.data.getContentHeight());
				Starling.juggler.add(tween);
			}
		}

		private function onExpand(e:Event):void {
		
			e.data.expand();
			
			var result:Vector.<DropDownContainer> = _dropDownElements.slice(_dropDownElements.indexOf(e.data) + 1);
			
			for each(var ddc:DropDownContainer in result){
				
				var tween:Tween = new Tween(ddc, 0.7, Transitions.EASE_IN_OUT);
				tween.animate("setY", ddc.y + e.data.getContentHeight());
				Starling.juggler.add(tween);
			}
		}

		public function addElement(element:DisplayObject):void {
			
			_content.push(element);
			
			if(element is DropDownContainer){
				
				_dropDownElements.push(element)
				DropDownContainer(element).setY = (_dropDownElements.length - 1) * DropDownContainer(element).componentHeight;
				
			}
			
			addChild(element);
			
		}
		
			
			
		
			
			
			
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
			
			
			
			
			
			
			
	}
}