package com.lingdong.demo.model.resources
{
	import com.lingdong.demo.model.IDemoConfig;

	public class DemoImage extends DemoFile implements IDemoConfig
	{
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
	}
}