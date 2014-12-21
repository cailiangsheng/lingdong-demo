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
		
		override protected function get fileFilter():Array
		{
			return [videoFilter];
		}
		
		override protected function readUploadConfig(config:Object):void
		{
			this.fileId = config.fileId;
			this.url = config.url;
		}
		
		override public function compareResource(resource:DemoResource):Boolean
		{
			var video:DemoVideo = resource as DemoVideo;
			return super.compareResource(resource) && video;
		}
		
		override public function clone():DemoResource
		{
			var video:DemoVideo = new DemoVideo();
			video.fileId = this.fileId;
			video.url = this.url;
			return video;
		}
	}
}