package utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.ui.MouseCursorData;
	import flash.utils.Dictionary;

	public class CustomMouse
	{
		[Embed(source = "../assets/move_cursor.png")]
		private static const MoveCursor:Class;
		
		[Embed(source = "../assets/resize_vertical.png")]
		private static const ResizeVerticalCursor:Class;
		
		[Embed(source = "../assets/resize_horizontal.png")]
		private static const ResizeHorizontalCursor:Class;
		
		[Embed(source = "../assets/resize_topleft.png")]
		private static const ResizeTopleft:Class;
		
		[Embed(source = "../assets/resize_topright.png")]
		private static const ResizeTopright:Class;
		
		[Embed(source = "../assets/rotate.png")]
		private static const Rotate:Class;
		
		private static var Cursors:Dictionary = new Dictionary();
		Cursors["move_cursor"] = MoveCursor;
		Cursors["resize_vertical"] = ResizeVerticalCursor;
		Cursors["resize_horizontal"] = ResizeHorizontalCursor;
		Cursors["resize_topleft"] = ResizeTopleft;
		Cursors["resize_topright"] = ResizeTopright;
		Cursors["rotate"] = Rotate;
		
		public static function setMouse(cursor:String):void {

			if(cursor == Mouse.cursor) return;
			
			// Create a MouseCursorData object
			var cursorData:MouseCursorData = new MouseCursorData();
			// Specify the hotspot
			cursorData.hotSpot = new Point(8, 8);
			// Pass the cursor bitmap to a BitmapData Vector
			var bitmapDatas:Vector.<BitmapData> = new Vector.<BitmapData>(1, true);
			// Create the bitmap cursor 
			// The bitmap must be 32x32 pixels or smaller, due to an OS limitation
			var bitmap:Bitmap = new Cursors[cursor];
			// Pass the value to the bitmapDatas vector
			bitmapDatas[0] = bitmap.bitmapData;
			// Assign the bitmap to the MouseCursor object
			cursorData.data = bitmapDatas;
			// Register the MouseCursorData to the Mouse object with an alias
			Mouse.registerCursor(cursor, cursorData);
			// When needed for display, pass the alias to the existing cursor property
			Mouse.cursor = cursor;
		}

		public static function setAuto():void {
			Mouse.cursor = MouseCursor.AUTO;
		}
			
			
			
			
			
	}
}