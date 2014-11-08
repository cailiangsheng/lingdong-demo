package com.lingdong.demo.model.events
{
	import flash.events.Event;

	public class DemoImageEvent extends Event
	{
		public static const BITMAP_DATA_CHANGE:String = "bitmapDataChange";
		
		public function DemoImageEvent(type:String)
		{
			super(type);
		}
	}
}