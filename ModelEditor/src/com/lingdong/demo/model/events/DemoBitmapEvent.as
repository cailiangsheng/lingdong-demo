package com.lingdong.demo.model.events
{
	import flash.events.Event;

	public class DemoBitmapEvent extends Event
	{
		public static const BITMAP_DATA_CHANGE:String = "bitmapDataChange";
		
		public function DemoBitmapEvent(type:String)
		{
			super(type);
		}
	}
}