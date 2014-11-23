package com.lingdong.demo.model.resources
{
	import com.lingdong.demo.model.IDemoConfig;
	
	import mx.collections.ArrayCollection;

	public class DemoVideo extends DemoFile implements IDemoConfig
	{
		private static var _instances:ArrayCollection;
		
		public static function get instances():ArrayCollection
		{
			return _instances ||= new ArrayCollection();
		}
		
		public function DemoVideo()
		{
			super._type = VIDEO;
			
			instances.addItem(this);
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