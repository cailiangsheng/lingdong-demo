package com.lingdong.demo.model
{
	import com.lingdong.demo.model.events.DemoModelEvent;
	import com.lingdong.demo.model.pages.DemoPage;
	import com.lingdong.demo.model.pages.DemoTheme;
	
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	
	[Event(name="activeThemeChange", type="com.lingdong.demo.model.events.DemoModelEvent")]
	[Event(name="activePageChange", type="com.lingdong.demo.model.events.DemoModelEvent")]
	public class DemoPreviewer extends EventDispatcher
	{
		private var _activeTheme:DemoTheme;
		
		[Bindable]
		public function get activeTheme():DemoTheme
		{
			return _activeTheme;
		}
		
		public function set activeTheme(value:DemoTheme):void
		{
			if (_activeTheme != value)
			{
				this.activePage = null;
				
				_activeTheme = value;
				
				this.dispatchEvent(new DemoModelEvent(DemoModelEvent.ACTIVE_THEME_CHANGE));
				
				this.activePage = this.activeTheme ? this.activeTheme.pages.getPageAt(0) : null;
			}
		}
		
		private var _activePage:DemoPage;
		
		public function get activePage():DemoPage
		{
			return _activePage;
		}
		
		public function set activePage(value:DemoPage):void
		{
			if (_activePage != value)
			{
				_activePage = value;
				
				this.dispatchEvent(new DemoModelEvent(DemoModelEvent.ACTIVE_PAGE_CHANGE));
			}
		}
		
		public function DemoPreviewer()
		{
		}
		
		public function activateChild(page:DemoPage = null):void
		{
			page ||= this.activePage;
			
			if (page && page.child)
			{
				this.activeTheme = page.child;
				this.activePage = this.activeTheme.pages.getPageAt(0);
			}
		}
		
		public function activateParent(page:DemoPage = null):void
		{
			page ||= this.activePage;
			
			var currentTheme:DemoTheme = page ? page.parent : this.activeTheme;
			var parentPage:DemoPage = currentTheme.parent;
			if (parentPage)
			{
				var parentTheme:DemoTheme = parentPage.parent;
				
				this.activeTheme = parentTheme;
				this.activePage = parentPage;
			}
			else if (ExternalInterface.available)
			{
				ExternalInterface.call("window.history.back");
			}
		}
	}
}