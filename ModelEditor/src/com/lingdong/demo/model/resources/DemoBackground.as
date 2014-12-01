package com.lingdong.demo.model.resources
{
	import com.lingdong.demo.model.IDemoConfig;
	import com.lingdong.demo.model.events.DemoBackgroundEvent;
	
	import mx.collections.ArrayCollection;

	[Event(name="colorChange", type="com.lingdong.demo.model.events.DemoBackgroundEvent")]
	public class DemoBackground extends DemoImage implements IDemoConfig
	{
		public static const DEFAULT_COLOR:uint = 0xffffff;
		
		public static var _instance:DemoBackground;
		
		public static function get instance():DemoBackground
		{
			return _instance ||= new DemoBackground();
		}
		
		private var _color:uint = DEFAULT_COLOR;
		
		public function get color():uint
		{
			return _color;
		}
		
		public function set color(value:uint):void
		{
			if (_color != value)
			{
				_color = value;
				
				this.dispatchEvent(new DemoBackgroundEvent(DemoBackgroundEvent.COLOR_CHANGE));
			}
		}
		
		override public function get type():String
		{
			return BACKGROUND;
		}
		
		public function DemoBackground()
		{
		}
		
		override public function readConfig(config:Object):void
		{
			super.readConfig(config);
			
			if (config)
			{
				this.color = color;
			}
		}
		
		override public function writeConfig(config:Object, fileIds:Array):void
		{
			super.writeConfig(config, fileIds);
			
			if (config)
			{
				config.color = this.color;
			}
		}
	}
}