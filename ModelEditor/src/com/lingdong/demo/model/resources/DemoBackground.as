package com.lingdong.demo.model.resources
{
	import com.lingdong.demo.model.IDemoConfig;
	import com.lingdong.demo.model.events.DemoBackgroundEvent;
	
	import mx.collections.ArrayCollection;

	[Event(name="colorChange", type="com.lingdong.demo.model.events.DemoBackgroundEvent")]
	public class DemoBackground extends DemoImage implements IDemoConfig
	{
		public static const DEFAULT_COLOR:uint = 0xffffff;
		
		private static var _instances:ArrayCollection;
		
		public static function get instances():ArrayCollection
		{
			return _instances ||= new ArrayCollection();
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
		
		public function DemoBackground()
		{
			super._type = BACKGROUND;
			
			instances.addItem(this);
		}
		
		override public function readConfig(config:Object):void
		{
			super.readConfig(config);
			
			if (config)
			{
				this.color = color;
			}
		}
	}
}