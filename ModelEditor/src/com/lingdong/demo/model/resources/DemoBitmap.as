package com.lingdong.demo.model.resources
{
	import com.lingdong.demo.model.events.DemoBitmapEvent;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	[Event(name="bitmapDataChange", type="com.lingdong.demo.model.events.DemoBitmapEvent")]
	public class DemoBitmap extends DemoImage
	{
		private var _bitmapData:BitmapData;
		
		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}
		
		public function set bitmapData(value:BitmapData):void
		{
			if (_bitmapData != value)
			{
				_bitmapData = value;
				
				dispatchEvent(new DemoBitmapEvent(DemoBitmapEvent.BITMAP_DATA_CHANGE));
			}
		}
		
		override public function get type():String
		{
			return BITMAP;
		}
		
		override public function get isValid():Boolean
		{
			return this.url || this.bitmapData;
		}
		
		public function DemoBitmap()
		{
		}
		
		public function draw(view:DisplayObject, size:Point):void
		{
			if (!_bitmapData)
			{
				_bitmapData = new BitmapData(size.x, size.y);
			}
			
			var scale:Number = _bitmapData.height / view.height;
			var matrix:Matrix = new Matrix();
			matrix.scale(scale, scale);
			_bitmapData.draw(view, matrix);
			
			dispatchEvent(new DemoBitmapEvent(DemoBitmapEvent.BITMAP_DATA_CHANGE));
		}
	}
}