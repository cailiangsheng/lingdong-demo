package com.lingdong.demo.model.pages
{
	import com.lingdong.demo.model.events.DemoPagesEvent;
	
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	
	[Event(name="pagesChange", type="com.lingdong.demo.model.events.DemoPagesEvent")]
	public class DemoPages extends EventDispatcher
	{
		private var _pages:ArrayCollection;
		
		public function get source():Vector.<DemoPage>
		{
			return Vector.<DemoPage>(_pages.toArray());
		}
		
		public function addPage(page:DemoPage):void
		{
			_pages.addItem(page);
		}
		
		public function removePage(page:DemoPage):void
		{
			var index:int = _pages.getItemIndex(page);
			_pages.removeItemAt(index);
		}
		
		public function removeAllPages():void
		{
			_pages.removeAll();
		}
		
		public function clearPages():void
		{
			_pages.removeAll();
		}
		
		public function get numPages():int
		{
			return _pages.length;
		}
		
		public function getPageIndex(page:DemoPage):int
		{
			return _pages.getItemIndex(page);
		}
		
		public function getPageAt(index:int):DemoPage
		{
			if (index >= 0 && index < this.numPages)
			{
				return _pages.getItemAt(index) as DemoPage;
			}
			
			return null;
		}
		
		public function DemoPages()
		{
			_pages = new ArrayCollection();
			_pages.addEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChange);
		}
		
		private function onCollectionChange(event:CollectionEvent):void
		{
			this.dispatchEvent(DemoPagesEvent.fromCollectionEvent(event));
		}
	}
}