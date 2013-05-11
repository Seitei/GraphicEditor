package
{
	import flash.geom.Rectangle;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.errors.AbstractClassError;
	import starling.events.Event;
	import starling.extensions.ClippedSprite;
	
	import utils.ScrollBar;

	public class ScrollContainer extends ClippedSprite
	{
		private var _background:Quad;
		private var _content:Array;
		private var _dropDownElements:Vector.<DropDownContainer>;
		private var _blockingComponents:Boolean;
		private var _scrollBar:ScrollBar;
		private var _elementsHeight:Number = 0;
		private var _scrolledAmount:Number = 0;
		
		public function ScrollContainer(width:Number, height:Number, color:uint)
		{
			_content = new Array();
			_dropDownElements = new Vector.<DropDownContainer>;
			
			
			_background = new Quad(width, height, color);	
			addChild(_background);
			
			this.clipRect = new Rectangle(0, 0, width + 20, height);
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			addEventListener("collapseOrExpand", onCollapseOrExpand);
			addEventListener("DDTweenComplete", onDDTweenComplete);
				
		}
		
		private function onScrollBarMoved(e:Event, data:Object):void {
			
			for each(var ddc:DropDownContainer in _dropDownElements){
				ddc.setY -= data.amount;
			}
			
			_scrolledAmount -= data.amount;
			trace(_scrolledAmount);
			
		}
		
		
		private function onAdded(e:Event):void {
			var line:Quad = new Quad(2, stage.stageHeight, 0x333333);
			line.x = 180;
			addChild(line);
		}
		
		private function onCollapseOrExpand(e:Event):void {
			
			var result:Vector.<DropDownContainer> = _dropDownElements.slice(_dropDownElements.indexOf(e.data) + 1);
			
			if(e.data.status == "collapsed") _elementsHeight += e.data.getContentHeight();
			
			if(e.data.status == "expanded")  _elementsHeight -= e.data.getContentHeight();
			
			_scrollBar.update(_elementsHeight,  _background.height);
			
			//////////////////////////////////////////
			var amountToScroll:Number = 0;
			
			if(!_scrollBar.visible && _scrolledAmount != 0){
				amountToScroll = _scrolledAmount;
				_scrolledAmount = 0;								
			}
				
			for each(var ddc:DropDownContainer in _dropDownElements){
				
				var tween:Tween = new Tween(ddc, 0.5, Transitions.EASE_IN_OUT);
				trace(amountToScroll);
				if(result.indexOf(ddc) != -1){
					
					if(e.data.status == "collapsed") {
							tween.animate("setY", ddc.y + e.data.getContentHeight() - amountToScroll);
					}
					
					if(e.data.status == "expanded") {
							tween.animate("setY", ddc.y - e.data.getContentHeight() - amountToScroll);
					}
				}
				else {
					
					tween.animate("setY", ddc.y - amountToScroll);
					
				}
				
				Starling.juggler.add(tween);
			}
			
			
			
		}

		
		private function onDDTweenComplete(e:Event):void {
			
			for (var i:int = 0; i < _dropDownElements.length; i++){
				_dropDownElements[i].blocked = false;
			}
			
			/*if(!_scrollBar.visible && _scrolledAmount != 0){
				
				for each(var ddc:DropDownContainer in _dropDownElements){
					var tween:Tween = new Tween(ddc, 0.5, Transitions.EASE_IN_OUT);
					tween.animate("setY", ddc.y - _scrolledAmount);
					Starling.juggler.add(tween);
				}
				
				_scrolledAmount = 0;
			}*/
		}
		
		
		
		public function addElement(element:DisplayObject):void {
			
			_content.push(element);
			
			if(element is DropDownContainer){
				
				_dropDownElements.push(element)
				DropDownContainer(element).setY = (_dropDownElements.length - 1) * DropDownContainer(element).componentHeight;
				_elementsHeight += DropDownContainer(element).getCurrentHeight();
				
			}
			
			addChild(element);
			
		}
		
		public function addElements(elements:Array):void {
			
			for (var i:int = 0; i < elements.length; i ++){
				addElement(elements[i]);
			}
			
			_scrollBar = new ScrollBar(_elementsHeight, _background.height);
			_scrollBar.x = this.width;
			_scrollBar.addEventListener("scrollBarMoved", onScrollBarMoved);
			addChild(_scrollBar);	
			
		}
		
			
			
		
			
			
			
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
			
			
			
			
			
			
			
	}
}