package com.lingdong.demo.model.events
{
	import flash.events.Event;
	
	public class DemoThemeEvent extends Event
	{
		public static const SHOW_STYLE_CHANGE:String = "showStyleChange";
		public static const ACTIVE_THEME_CHANGE:String = "activeThemeChange";
		public static const ACTIVE_PAGE_CHANGE:String = "activePageChange";
		
		public function DemoThemeEvent(type:String)
		{
			super(type);
		}
	}
}