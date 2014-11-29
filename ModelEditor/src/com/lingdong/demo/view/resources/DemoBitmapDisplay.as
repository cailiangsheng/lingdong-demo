package com.lingdong.demo.view.resources
{
	import com.lingdong.demo.model.resources.DemoBitmap;
	import com.lingdong.demo.model.resources.DemoImage;

	public class DemoBitmapDisplay extends DemoImageDisplay
	{
		override public function set image(value:DemoImage):void
		{
			this.bitmap = value;
		}
		
		private var _bitmap:DemoBitmap;
		
		public function get bitmap():DemoBitmap
		{
			return _bitmap;
		}
		
		public function set bitmap(value:DemoBitmap):void
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