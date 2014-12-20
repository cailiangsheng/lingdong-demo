package com.lingdong.demo.model.resources
{
	import com.lingdong.demo.model.IDemoConfig;
	
	import flash.net.FileFilter;
	
	import mx.collections.ArrayCollection;

	public class DemoVideo extends DemoFile implements IDemoConfig
	{
		public static var videoFilter:FileFilter = new FileFilter("Video(*.mp4;*.flv)", "*.mp4;*.flv");
		
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
				this.fileId = config.name;
				this.url = config.videoUrl;
			}
		}
		
		override public function writeConfig(config:Object, fileIds:Array):void
		{
			if (config)
			{
				config.name = this.fileId;
				config.videoUrl = this.url;
				
				if (fileIds && this.fileId)
				{
					fileIds.push(this.fileId);
				}
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
		
		override public function compareResource(resource:DemoResource):Boolean
		{
			var video:DemoVideo = resource as DemoVideo;
			return super.compareResource(resource) && video;
		}
	}
}