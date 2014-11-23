package com.lingdong.demo.view.resources
{
	import com.lingdong.demo.model.events.DemoFileEvent;
	import com.lingdong.demo.model.events.DemoImageEvent;
	import com.lingdong.demo.model.resources.DemoImage;
	import com.lingdong.demo.model.resources.DemoResource;
	import com.lingdong.demo.util.DemoPoolUtil;
	
	import flash.events.Event;
	
	import mx.controls.Image;
	import mx.core.FlexBitmap;
	import mx.core.UIComponent;
	
	import spark.primitives.BitmapImage;

	public class DemoImageDisplay extends DemoResourceDisplay
	{
		override public function get resource():DemoResource
		{
			return this.image;
		}
		
		override public function set resource(value:DemoResource):void
		{
			this.image = value as DemoImage;
		}
		
		private var _image:DemoImage;
		
		public function get image():DemoImage
		{
			return _image;
		}
		
		public function set image(value:DemoImage):void
		{
			if (_image != value)
			{
				_image && _image.removeEventListener(DemoImageEvent.BITMAP_DATA_CHANGE, updateBitmapData);
				_image && _image.removeEventListener(DemoFileEvent.URL_CHANGE, updateURL);
				
				this.dispose();
				
				_image = value;
				
				this.stage && update();
				
				_image && _image.addEventListener(DemoImageEvent.BITMAP_DATA_CHANGE, updateBitmapData);
				_image && _image.addEventListener(DemoFileEvent.URL_CHANGE, updateURL);
			}
		}
		
		override protected function update(event:Event = null):void
		{
			super.update(event);
			
			if (image)
			{
				updateBitmapData();
				updateURL();
			}
		}
		
		public function DemoImageDisplay()
		{
		}
		
		private var _imageUI:Image;
		
		private function get imageUI():Image
		{
			if (!_imageUI)
			{
				_imageUI = DemoPoolUtil.alloc(Image);
				_imageUI.maintainAspectRatio = false;
				_imageUI.percentWidth = 100;
				_imageUI.percentHeight = 100;
				this.addElement(_imageUI);
			}
			
			return _imageUI;
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
			this.bitmapUI.source = this.image.bitmapData;
		}
		
		private function updateURL(event:Event = null):void
		{
			this.imageUI.source = this.image.url;
		}
		
		private function dispose():void
		{
			if (_imageUI)
			{
				_imageUI.source = null;
				this.removeElement(_imageUI);
				
				DemoPoolUtil.free(_imageUI);
				_imageUI = null;
			}
			
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