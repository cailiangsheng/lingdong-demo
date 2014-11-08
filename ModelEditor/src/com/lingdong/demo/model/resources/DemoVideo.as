package com.lingdong.demo.model.resources
{
	import com.lingdong.demo.model.IDemoConfig;

	public class DemoVideo extends DemoFile implements IDemoConfig
	{
		public function DemoVideo()
		{
			super._type = VIDEO;
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