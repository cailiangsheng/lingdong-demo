package com.lingdong.demo.model
{
	import com.lingdong.demo.model.events.DemoModelEvent;
	import com.lingdong.demo.model.pages.DemoElement;
	import com.lingdong.demo.model.pages.DemoPage;

	public class DemoDesigner extends DemoPreviewer
	{
		public function createPage():void
		{
			if (this.activeTheme)
			{
				var page:DemoPage = new DemoPage();
				
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
	}
}