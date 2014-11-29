package com.lingdong.demo.model.resources
{
	import com.lingdong.demo.model.IDemoConfig;
	
	import flash.net.FileFilter;

	public class DemoImage extends DemoFile implements IDemoConfig
	{
		public static var imageFilter:FileFilter = new FileFilter("Images", "*.jpg;*.gif;*.png");
		
		override public function get type():String
		{
			return IMAGE;
		}
		
		public function DemoImage()
		{
		}
		
		override public function readConfig(config:Object):void
		{
			if (config)
			{
				this.fileId = config.id;
				this.url = config.urlBig;
			}
		}
		
		override protected function get fileFilter():Array
		{
			return [imageFilter];
		}
		
		override protected function readUploadConfig(config:Object):void
		{
			this.url = config.thubImageUrl;
			this.fileId = config.fileId;
		}
	}
}