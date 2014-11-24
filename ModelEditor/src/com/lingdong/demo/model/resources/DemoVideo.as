package com.lingdong.demo.model.resources
{
	import com.lingdong.demo.model.IDemoConfig;
	
	import mx.collections.ArrayCollection;

	public class DemoVideo extends DemoFile implements IDemoConfig
	{
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
	}
}