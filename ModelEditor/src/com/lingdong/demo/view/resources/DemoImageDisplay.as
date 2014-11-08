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
				
				_image = value;
				
				this.stage && update();
				
				_image && _image.addEventListener(DemoImageEvent.BITMAP_DATA_CHANGE, updateBitmapData);
				_image && _image.addEventListener(DemoFileEvent.URL_CHANGE, updateURL);
			}
		}
		
		private function update(event:Event = null):void
		{
			if (image)
			{
				updateBitmapData();
				updateURL();
			}
			else
			{
				this.dispose();
			}
		}
		
		public function DemoImageDisplay()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, update);
		}
		
		private var _imageUI:Image;
		
		private function get imageUI():Image
		{
			if (!_imageUI)
			{
				_imageUI = DemoPoolUtil.alloc(Image);
				this.addChild(_imageUI);
			}
			
			_imageUI.width = this.width;
			_imageUI.height = this.height;
			return _imageUI;
		}
		
		private var _bitmapUI:FlexBitmap;
		
		private function get bitmapUI():FlexBitmap
		{
			if (!_bitmapUI)
			{
				_bitmapUI = DemoPoolUtil.alloc(FlexBitmap);
				this.addChild(_bitmapUI);
			}
			
			_bitmapUI.width = this.width;
			_bitmapUI.height = this.height;
			return _bitmapUI;
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			
			this.imageUI.width = value;
			this.bitmapUI.width = value;
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			
			this.imageUI.height = value;
			this.bitmapUI.height = value;
		}
		
		private function updateBitmapData(event:Event = null):void
		{
			this.bitmapUI.bitmapData = this.image.bitmapData;
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
				this.removeChild(_imageUI);
				
				DemoPoolUtil.free(_imageUI);
				_imageUI = null;
			}
			
			if (_bitmapUI)
			{
				_bitmapUI.bitmapData = null;
				this.removeChild(_bitmapUI);
				
				DemoPoolUtil.free(_bitmapUI);
				_bitmapUI = null;
			}
		}
	}
}