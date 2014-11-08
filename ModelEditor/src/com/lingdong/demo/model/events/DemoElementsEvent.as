package com.lingdong.demo.model.events
{
	import com.lingdong.demo.model.pages.DemoElement;
	
	import mx.events.CollectionEvent;
	
	public class DemoElementsEvent extends CollectionEvent
	{
		public static const ELEMENTS_CHANGE:String = "elementsChange";
		
		public function get elements():Vector.<DemoElement>
		{
			return Vector.<DemoElement>(this.items);
		}
		
		public function DemoElementsEvent(type:String)
		{
			super(type);
		}
		
		public static function fromCollectionEvent(event:CollectionEvent):DemoElementsEvent
		{
			var e:DemoElementsEvent = new DemoElementsEvent(DemoElementsEvent.ELEMENTS_CHANGE);
			e.items = event.items;
			e.kind = event.kind;
			e.location = event.location;
			e.oldLocation = event.oldLocation;
			return e;
		}
	}
}