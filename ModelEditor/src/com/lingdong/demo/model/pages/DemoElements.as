package com.lingdong.demo.model.pages
{
	import com.lingdong.demo.model.events.DemoElementsEvent;
	
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	
	[Event(name="elementsChange", type="com.lingdong.demo.model.events.DemoElementsEvent")]
	public class DemoElements extends EventDispatcher
	{
		private var _elements:ArrayCollection;
		
		public function get source():Vector.<DemoElement>
		{
			return Vector.<DemoElement>(_elements.toArray());
		}
		
		public function addElement(element:DemoElement):void
		{
			_elements.addItem(element);
		}
		
		public function removeElement(element:DemoElement):void
		{
			var index:int = _elements.getItemIndex(element);
			_elements.removeItemAt(index);
		}
		
		public function removeAllElements():void
		{
			_elements.removeAll();
		}
		
		public function clearElements():void
		{
			_elements.removeAll();
		}
		
		public function DemoElements()
		{
			_elements = new ArrayCollection();
			_elements.addEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChange);
		}
		
		private function onCollectionChange(event:CollectionEvent):void
		{
			this.dispatchEvent(DemoElementsEvent.fromCollectionEvent(event));
		}
	}
}