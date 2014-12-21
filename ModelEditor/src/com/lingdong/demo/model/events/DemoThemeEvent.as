package com.lingdong.demo.model.events
{
	import flash.events.Event;
	
	public class DemoThemeEvent extends Event
	{
		public static const SHOW_STYLE_CHANGE:String = "showStyleChange";
		
		public function DemoThemeEvent(type:String)
		{
			super(type);
		}
	}
}