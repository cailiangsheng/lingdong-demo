package com.lingdong.demo.model.resources
{
	import com.lingdong.demo.model.IDemoConfig;
	
	import flash.net.FileFilter;

	public class DemoImage extends DemoFile implements IDemoConfig
	{
		public static var imageFilter:FileFilter = new FileFilter("Image(*.jpg;*.gif;*.png)", "*.jpg;*.gif;*.png");
		
		override public function get type():String
		{
			return IMAGE;
		}
		
		public function DemoImage()
		{
		}
		
		override protected function get fileFilter():Array
		{
			return [imageFilter];
		}
		
		override protected function readUploadConfig(config:Object):void
		{
			this.fileId = config.fileId;
			this.url = config.url;//config.thubImageUrl;
		}
		
		override public function compareResource(resource:DemoResource):Boolean
		{
			var image:DemoImage = resource as DemoImage;
			return super.compareResource(resource) && image;
		}
		
		override public function clone():DemoResource
		{
			var image:DemoImage = new DemoImage();
			image.fileId = this.fileId;
			image.url = this.url;
			return image;
		}
	}
}