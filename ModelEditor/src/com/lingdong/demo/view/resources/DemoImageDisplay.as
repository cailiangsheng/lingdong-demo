package com.lingdong.demo.view.resources
{
	import com.lingdong.demo.model.events.DemoBitmapEvent;
	import com.lingdong.demo.model.events.DemoFileEvent;
	import com.lingdong.demo.model.resources.DemoFile;
	import com.lingdong.demo.model.resources.DemoImage;
	import com.lingdong.demo.model.resources.DemoResource;
	import com.lingdong.demo.util.DemoPoolUtil;
	
	import flash.events.Event;
	
	import mx.controls.Image;
	import mx.core.UIComponent;
	
	import spark.primitives.BitmapImage;

	public class DemoImageDisplay extends DemoFileDisplay
	{
		override public function set file(value:DemoFile):void
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
			super.file = value;
			
			if (_image != value)
			{
				_image && _image.removeEventListener(DemoFileEvent.URL_CHANGE, updateURL);
				
				this.dispose();
				
				_image = value;
				
				update();
				
				_image && _image.addEventListener(DemoFileEvent.URL_CHANGE, updateURL);
			}
		}
		
		override protected function update(event:Event = null):void
		{
			super.update(event);
			
			if (image)
			{
				updateURL();
			}
		}
		
		override public function get contentWidth():Number
		{
			return _imageUI ? _imageUI.contentWidth : this.width;
		}
		
		override public function get contentHeight():Number
		{
			return _imageUI ? _imageUI.contentHeight : this.height;
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
				_imageUI.setStyle("horizontalAlign", "middle");
				_imageUI.setStyle("verticalAlign", "middle");
				_imageUI.maintainAspectRatio = super.maintainAspectRatio;
				_imageUI.percentWidth = 100;
				_imageUI.percentHeight = 100;
				this.addElement(_imageUI);
			}
			
			return _imageUI;
		}
		
		override protected function updateMaintainAspectRatio():void
		{
			if (_imageUI)
			{
				_imageUI.maintainAspectRatio = super.maintainAspectRatio;
			}
		}
		
		private function updateURL(event:Event = null):void
		{
			if (!this.stage) return;
			
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
		}
	}
}