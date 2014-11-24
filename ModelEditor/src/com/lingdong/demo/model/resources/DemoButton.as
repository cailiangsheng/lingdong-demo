package com.lingdong.demo.model.resources
{
	import com.lingdong.demo.model.IDemoConfig;

	public class DemoButton extends DemoImage implements IDemoConfig
	{
		override public function get type():String
		{
			return BUTTON;
		}
		
		public function DemoButton()
		{
		}
		
		override public function readConfig(config:Object):void
		{
			if (config)
			{
				this.fileId = config.id;
				this.url = config.backgroudImage;
			}
		}
	}
}