package com.lingdong.demo.model
{
	import com.lingdong.demo.model.events.DemoModelEvent;
	import com.lingdong.demo.model.events.DemoPageEvent;
	import com.lingdong.demo.model.pages.DemoElement;
	import com.lingdong.demo.model.pages.DemoPage;
	import com.lingdong.demo.model.pages.DemoTheme;
	import com.lingdong.demo.model.resources.DemoResource;
	
	import flash.events.Event;
	
	[Event(name="activeResourceChange", type="com.lingdong.demo.model.events.DemoModelEvent")]
	[Event(name="activeElementChange", type="com.lingdong.demo.model.events.DemoModelEvent")]
	public class DemoDesigner extends DemoPreviewer
	{
		private var _activeResource:DemoResource;
		
		public function get activeResource():DemoResource
		{
			return _activeResource;
		}
		
		public function setActiveResource(value:DemoResource):void
		{
			if (_activeResource != value)
			{
				_activeResource = value;
				
				this.dispatchEvent(new DemoModelEvent(DemoModelEvent.ACTIVE_RESOURCE_CHANGE));
			}
		}
		
		private function updateActiveResource(event:Event = null):void
		{
			if (this.activeElement)
			{
				this.setActiveResource(this.activeElement.resource);
			}
			else if (this.activePage)
			{
				this.setActiveResource(this.activePage.background);
			}
			else
			{
				this.setActiveResource(null);
			}
		}
		
		private var _activeElement:DemoElement;
		
		public function get activeElement():DemoElement
		{
			return _activeElement;
		}
		
		public function set activeElement(value:DemoElement):void
		{
			if (_activeElement != value)
			{
				_activeElement = value;
				
				updateActiveResource();
				
				this.dispatchEvent(new DemoModelEvent(DemoModelEvent.ACTIVE_ELEMENT_CHANGE));
			}
		}
		
		override public function set activePage(value:DemoPage):void
		{
			if (super.activePage != value)
			{
				this.activePage && this.activePage.removeEventListener(DemoPageEvent.BACKGROUND_CHANGE, updateActiveResource);
				
				this.activeElement = null;
				
				super.activePage = value;
				
				updateActiveResource();
				
				this.activePage && this.activePage.addEventListener(DemoPageEvent.BACKGROUND_CHANGE, updateActiveResource);
			}
		}
		
		public function createPage():void
		{
			if (this.activeTheme)
			{
				var page:DemoPage = new DemoPage(this.activeTheme);
				
				this.activeTheme.pages.addPage(page);
				
				this.activePage = page;
			}
		}
		
		public function deletePage():void
		{
			if (this.activeTheme && this.activePage)
			{
				var numPages:int = this.activeTheme.pages.numPages;
				var activePageIndex:int = this.activeTheme.pages.getPageIndex(this.activePage);
				var prevPageIndex:int = Math.min(Math.max(activePageIndex - 1, 0), numPages - 1);
				
				this.activeTheme.pages.removePage(this.activePage);
				this.activePage = this.activeTheme.pages.getPageAt(prevPageIndex);;
			}
		}
		
		override public function activateChild(page:DemoPage = null):void
		{
			page ||= this.activePage;
			
			if (page && !page.child)
			{
				page.child = new DemoTheme(page);
			}
			
			super.activateChild(page);
		}
	}
}