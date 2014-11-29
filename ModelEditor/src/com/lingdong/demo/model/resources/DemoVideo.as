package com.lingdong.demo.model.resources
{
	import com.lingdong.demo.model.IDemoConfig;
	
	import flash.net.FileFilter;
	
	import mx.collections.ArrayCollection;

	public class DemoVideo extends DemoFile implements IDemoConfig
	{
		public static var videoFilter:FileFilter = new FileFilter("Videos", "*.mp4;*.flv");
		
		override public function get type():String
		{
			return VIDEO;
		}
		
		public function DemoVideo()
		{
		}
		
		override public function readConfig(config:Object):void
		{
			if (config)
			{
				this.fileId = config.id;
				this.url = config.videoUrl;
			}
		}
		
		override protected function get fileFilter():Array
		{
			return [videoFilter];
		}
		
		override protected function readUploadConfig(config:Object):void
		{
			this.url = config.url;
			this.fileId = config.fileId;
		}
	}
}