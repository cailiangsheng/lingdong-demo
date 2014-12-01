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
		
		override public function readConfig(config:Object):void
		{
			if (config)
			{
				this.fileId = config.name;
				this.url = config.urlBig;
			}
		}
		
		override public function writeConfig(config:Object, fileIds:Array):void
		{
			if (config)
			{
				if (this.url)
				{
					config.urlBig = this.url;
				}
				
				if (this.fileId)
				{
					config.name = this.fileId;
					
					if (fileIds)
					{
						fileIds.push(this.fileId);
					}
				}
			}
		}
		
		override protected function get fileFilter():Array
		{
			return [imageFilter];
		}
		
		override protected function readUploadConfig(config:Object):void
		{
			this.fileId = config.name;
			this.url = config.url;//config.thubImageUrl;
		}
	}
}