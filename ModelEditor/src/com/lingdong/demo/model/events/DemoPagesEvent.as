package com.lingdong.demo.model.events
{
	import com.lingdong.demo.model.pages.DemoPage;
	
	import flash.events.Event;
	
	import mx.events.CollectionEvent;
	
	public class DemoPagesEvent extends CollectionEvent
	{
		public static const PAGES_CHANGE:String = "pagesChange";
		
		public function get pages():Vector.<DemoPage>
		{
			return Vector.<DemoPage>(this.items);
		}
		
		public function DemoPagesEvent(type:String)
		{
			super(type);
		}
		
		public static function fromCollectionEvent(event:CollectionEvent):DemoPagesEvent
		{
			var e:DemoPagesEvent = new DemoPagesEvent(DemoPagesEvent.PAGES_CHANGE);
			e.items = event.items;
			e.kind = event.kind;
			e.location = event.location;
			e.oldLocation = event.oldLocation;
			return e;
		}
	}
}