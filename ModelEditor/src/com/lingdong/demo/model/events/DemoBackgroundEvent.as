package com.lingdong.demo.model.events
{
	import flash.events.Event;
	
	public class DemoBackgroundEvent extends Event
	{
		public static const COLOR_CHANGE:String = "colorChange";
		public static const COMMENT_CHANGE:String = "commentChange";
		
		public function DemoBackgroundEvent(type:String)
		{
			super(type);
		}
	}
}