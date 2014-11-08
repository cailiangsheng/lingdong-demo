package com.lingdong.demo.model.events
{
	import flash.events.Event;
	
	public class DemoBackgroundEvent extends Event
	{
		public static const COLOR_CHANGE:String = "colorChange";
		
		public function DemoBackgroundEvent(type:String)
		{
			super(type);
		}
	}
}