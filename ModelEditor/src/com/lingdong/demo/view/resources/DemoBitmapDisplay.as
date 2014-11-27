package com.lingdong.demo.view.resources
{
	import com.lingdong.demo.model.resources.DemoBitmap;

	public class DemoBitmapDisplay extends DemoImageDisplay
	{
		override public function get resource():DemoResource
		{
			return this.bitmap;
		}
		
		override public function set resource(value:DemoResource):void
		{
			this.bitmap = value as DemoBitmap;
		}
		
		private var _bitmap:DemoBitmap;
		
		public function get bitmap():DemoImage
		{
			return _bitmap;
		}
		
		public function set bitmap(value:DemoImage):void
		{
			super.image = value;
			
			if (_bitmap != value)
			{
				_bitmap && _bitmap.removeEventListener(DemoBitmapEvent.BITMAP_DATA_CHANGE, updateBitmapData);
				
				this.dispose();
				
				_bitmap = value;
				
				update();
				
				_bitmap && _bitmap.addEventListener(DemoBitmapEvent.BITMAP_DATA_CHANGE, updateBitmapData);
			}
		}
		
		override protected function update(event:Event = null):void
		{
			super.update(event);
			
			if (bitmap)
			{
				updateBitmapData();
			}
		}
		
		public function DemoBitmapDisplay()
		{
		}
		
		private var _bitmapUI:BitmapImage;
		
		private function get bitmapUI():BitmapImage
		{
			if (!_bitmapUI)
			{
				_bitmapUI = DemoPoolUtil.alloc(BitmapImage);
				_bitmapUI.percentWidth = 100;
				_bitmapUI.percentHeight = 100;
				this.addElement(_bitmapUI);
			}
			
			return _bitmapUI;
		}
		
		private function updateBitmapData(event:Event = null):void
		{
			if (!this.stage) return;
			
			this.bitmapUI.source = this.bitmap.bitmapData;
		}
		
		private function dispose():void
		{
			if (_bitmapUI)
			{
				_bitmapUI.source = null;
				this.removeElement(_bitmapUI);
				
				DemoPoolUtil.free(_bitmapUI);
				_bitmapUI = null;
			}
		}
	}
}