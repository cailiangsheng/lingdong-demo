package com.lingdong.demo.model.events
{
	import flash.events.Event;

	public class DemoFileEvent extends Event
	{
		public static const FILE_ID_CHANGE:String = "fileIdChange";
		public static const URL_CHANGE:String = "urlChange";
		
		public function DemoFileEvent(type:String)
		{
			super(type);
		}
	}
}