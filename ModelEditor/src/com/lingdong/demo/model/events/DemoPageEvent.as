package com.lingdong.demo.model.events
{
	import flash.events.Event;
	
	public class DemoPageEvent extends Event
	{
		public static const BACKGROUND_CHANGE:String = "backgroundChange";
		public static const ELEMENTS_CHANGE:String = "elementsChange";
		public static const CHILD_CHANGE:String = "childChange";
		
		public function DemoPageEvent(type:String)
		{
			super(type);
		}
	}
}