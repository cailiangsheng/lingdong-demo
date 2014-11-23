package com.lingdong.demo.model.resources
{
	import com.lingdong.demo.model.IDemoConfig;
	import com.lingdong.demo.model.events.DemoImageEvent;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;

	[Event(name="bitmapDataChange", type="com.lingdong.demo.model.events.DemoImageEvent")]
	public class DemoImage extends DemoFile implements IDemoConfig
	{
		private static var _instances:ArrayCollection;
		
		public static function get instances():ArrayCollection
		{
			return _instances ||= new ArrayCollection();
		}
		
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
				
				dispatchEvent(new DemoImageEvent(DemoImageEvent.BITMAP_DATA_CHANGE));
			}
		}
		
		public function DemoImage()
		{
			super._type = IMAGE;
			
			instances.addItem(this);
		}
		
		override public function readConfig(config:Object):void
		{
			if (config)
			{
				this.fileId = config.id;
				this.url = config.urlBig;
			}
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
			
			dispatchEvent(new DemoImageEvent(DemoImageEvent.BITMAP_DATA_CHANGE));
		}
	}
}