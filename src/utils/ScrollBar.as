package utils
{
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.Color;
	
	public class ScrollBar extends Sprite
	{
		
		private var _totalLength:Number;
		private var _visibleLength:Number;
		private var _bar:Quad;
		private var _background:Quad;
		
		public function ScrollBar(totalLength:Number, visibleLength:Number)
		{
			_totalLength = totalLength;
			_visibleLength = visibleLength;
			
			//background
			_background = new Quad(10, _visibleLength, 0x353535);
			addChild(_background);
			
			//the bar
			_bar = new Quad(10, 1, 0x909090);
			addChild(_bar);
			
			setDimensions();
			
			_bar.useHandCursor = true;
			_bar.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function setDimensions():void {
			
			if(_totalLength <= _visibleLength){
				this.visible = false;
				_bar.y = 0;
			}
			else{
				this.visible = true;
			}
			
			_background.height = _visibleLength;
			
			_bar.height = (_visibleLength / _totalLength) * _visibleLength;
		}
		
		public function update(totalLength:Number, visibleLength:Number):void {
			
			_totalLength = totalLength;
			_visibleLength = visibleLength;
			
			setDimensions();
			
		}
		
		
		private function onTouch(e:TouchEvent):void {
		
			var movedTouch:Touch = e.getTouch(DisplayObject(e.currentTarget), TouchPhase.MOVED);
			var endedTouch:Touch = e.getTouch(DisplayObject(e.currentTarget), TouchPhase.ENDED);
			
			if(movedTouch){
				
				var movementY:Number = movedTouch.getMovement(this).y;
				
				var scrollingDirection:int = movementY / Math.abs(movementY);
				var previousPosition:Number = _bar.y;
				
				if(scrollingDirection == 1){
					if(_bar.y + movementY > this.height - _bar.height)
						_bar.y = this.height - _bar.height;
					else{
						_bar.y += movementY;
					}
				}
				else {
					if(_bar.y + movementY < 0)
						_bar.y = 0;
					else{
						_bar.y += movementY;
					}
				}
				
				var relativeScrolledValue:Number = (_bar.y - previousPosition) / (_visibleLength / _totalLength);
					
				dispatchEventWith("scrollBarMoved", false, {"axis": "y", "amount": relativeScrolledValue});
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}