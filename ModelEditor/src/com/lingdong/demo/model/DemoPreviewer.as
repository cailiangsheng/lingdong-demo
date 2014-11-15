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
			return _activePage;
		}
		
		public function set activePage(value:DemoPage):void
		{
			if (_activePage != value)
			{
				_activePage = value;
				
				this.dispatchEvent(new DemoThemeEvent(DemoThemeEvent.ACTIVE_PAGE_CHANGE));
			}
		}
		
		public function get activePageIndex():int
		{
			return this.activeTheme.pages.getPageIndex(this.activePage);
		}
		
		public function set activePageIndex(value:int):void
		{
			this.activePage = this.activeTheme.pages.getPageAt(value);
		}
		
		public function DemoPreviewer()
		{
		}
	}
}