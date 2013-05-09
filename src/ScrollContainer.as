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
	
	import utils.ScrollBar;

	public class ScrollContainer extends Sprite
	{
		private var _background:Quad;
		private var _content:Array;
		private var _dropDownElements:Vector.<DropDownContainer>;
		private var _blockingComponents:Boolean;
		private var _scrollBar:ScrollBar;
		private var _elementsHeight:Number = 0;
		
		public function ScrollContainer(width:int, height:int, color:uint)
		{
			_content = new Array();
			_dropDownElements = new Vector.<DropDownContainer>;
			
			_background = new Quad(width, height, color);	
			addChild(_background);
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			addEventListener("collapseOrExpand", onCollapseOrExpand);
			addEventListener("blockElements", blockElements);
			
			_scrollBar = new ScrollBar(500, _background.height);
			_scrollBar.x = 200;
			_scrollBar.addEventListener("scrollBarMoved", onScrollBarMoved);
			addChild(_scrollBar);		
		}
		
		private function onScrollBarMoved(e:Event, data:Object):void {
			
			
			
		}
		
		
		
		private function onAdded(e:Event):void {
			var line:Quad = new Quad(2, stage.stageHeight, 0x333333);
			line.x = 180;
			addChild(line);
		}
		
		private function onCollapseOrExpand(e:Event):void {
			
			var result:Vector.<DropDownContainer> = _dropDownElements.slice(_dropDownElements.indexOf(e.data) + 1);
			
			for each(var ddc:DropDownContainer in result){
				
				var tween:Tween = new Tween(ddc, 0.5, Transitions.EASE_IN_OUT);
				if(e.data.status == "collapsed") tween.animate("setY", ddc.y + e.data.getContentHeight()); 
				if(e.data.status == "expanded") tween.animate("setY", ddc.y - e.data.getContentHeight()); 
				Starling.juggler.add(tween);
			}
		}

		
		
		private function blockElements(e:Event, value:Boolean):void {
			for (var i:int = 0; i < _dropDownElements.length; i++){
				_dropDownElements[i].blocked = value;
			}
		}
		
		
		
		public function addElement(element:DisplayObject):void {
			
			_content.push(element);
			if(element is DropDownContainer){
				
				_dropDownElements.push(element)
				DropDownContainer(element).setY = (_dropDownElements.length - 1) * DropDownContainer(element).componentHeight + 1;
				_elementsHeight += DropDownContainer(element).getCurrentHeight();
				
			}
			
			addChild(element);
		}
		
		public function addElements(elements:Array):void {
			
			for (var i:int = 0; i < elements.length; i ++){
				addElement(elements[i]);
			}
		}
		
			
			
		
			
			
			
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
			
			
			
			
			
			
			
	}
}