package com.lingdong.demo.model.events
{
	import flash.events.Event;
	
	public class DemoModelEvent extends Event
	{
		public static const ACTIVE_THEME_CHANGE:String = "activeThemeChange";
		public static const ACTIVE_PAGE_CHANGE:String = "activePageChange";
		public static const ACTIVE_ELEMENT_CHANGE:String = "activeElementChange";
		
		public function DemoModelEvent(type:String)
		{
			super(type);
		}
	}
}