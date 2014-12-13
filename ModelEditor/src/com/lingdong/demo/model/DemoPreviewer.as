package com.lingdong.demo.model
{
	import com.lingdong.demo.model.events.DemoThemeEvent;
	import com.lingdong.demo.model.pages.DemoPage;
	import com.lingdong.demo.model.pages.DemoTheme;
	
	import flash.events.EventDispatcher;
	
	[Event(name="activeThemeChange", type="com.lingdong.demo.model.events.DemoModelEvent")]
	[Event(name="activePageChange", type="com.lingdong.demo.model.events.DemoModelEvent")]
	public class DemoPreviewer extends EventDispatcher
	{
		private var _activeTheme:DemoTheme;
		
		public function get activeTheme():DemoTheme
		{
			return _activeTheme;
		}
		
		public function set activeTheme(value:DemoTheme):void
		{
			if (_activeTheme != value)
			{
				_activeTheme = value;
				
				this.dispatchEvent(new DemoThemeEvent(DemoThemeEvent.ACTIVE_THEME_CHANGE));
			}
		}
		
		private var _activePage:DemoPage;
		
		public function get activePage():DemoPage
		{
			return _activePage ? _activePage : (this.activeTheme ? this.activeTheme.pages.getPageAt(0) : null);
		}
		
		public function set activePage(value:DemoPage):void
		{
			if (_activePage != value)
			{
				_activePage = value;
				
				this.dispatchEvent(new DemoThemeEvent(DemoThemeEvent.ACTIVE_PAGE_CHANGE));
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
			else
			{
				// TO DO
			}
		}
	}
}