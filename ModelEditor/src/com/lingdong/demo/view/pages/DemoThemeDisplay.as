package com.lingdong.demo.view.pages
{
	import com.lingdong.demo.model.events.DemoPagesEvent;
	import com.lingdong.demo.model.events.DemoThemeEvent;
	import com.lingdong.demo.model.pages.DemoElement;
	import com.lingdong.demo.model.pages.DemoPage;
	import com.lingdong.demo.model.pages.DemoTheme;
	import com.lingdong.demo.model.traits.DemoShowStyle;
	import com.lingdong.demo.util.DemoPoolUtil;
	
	import flash.events.Event;
	
	import mx.containers.Tile;
	import mx.containers.VBox;
	import mx.containers.ViewStack;
	import mx.core.Container;
	import mx.core.IVisualElement;
	import mx.core.ScrollPolicy;
	import mx.core.UIComponent;
	import mx.events.CollectionEventKind;
	
	public class DemoThemeDisplay extends DemoContainerDisplay
	{
		private var _theme:DemoTheme;
		
		public function get theme():DemoTheme
		{
			return _theme;
		}
		
		public function set theme(value:DemoTheme):void
		{
			if (_theme != value)
			{
				_theme && _theme.removeEventListener(DemoThemeEvent.SHOW_STYLE_CHANGE, updateShowStyle);
				_theme && _theme.pages.removeEventListener(DemoPagesEvent.PAGES_CHANGE, updatePages);
				
				this.dispose();
				
				_theme = value;
				
				update();
				
				_theme && _theme.addEventListener(DemoThemeEvent.SHOW_STYLE_CHANGE, updateShowStyle);
				_theme && _theme.pages.addEventListener(DemoPagesEvent.PAGES_CHANGE, updatePages);
			}
		}
		
		public function get activePage():DemoPage
		{
			var pages:Vector.<DemoPageDisplay> = getPages();
			if (this.selectedIndex >= 0 && this.selectedIndex < pages.length)
			{
				return pages[this.selectedIndex].page;
			}
			
			return null;
		}
		
		public function set activePage(value:DemoPage):void
		{
			if (this.theme && value)
			{
				this.selectedIndex = this.theme.pages.getPageIndex(value);
			}
			else
			{
				this.selectedIndex = -1;
			}
		}
		
		public function DemoThemeDisplay()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, update);
		}
		
		private function update(event:Event = null):void
		{
			if (this.theme)
			{
				updateShowStyle();
				updatePages();
			}
		}
		
		private function updateShowStyle(event:Event = null):void
		{
			if (!this.stage) return;
			
			super.showStyle = theme.showStyle;
		}
		
		private function updatePages(event:DemoPagesEvent = null):void
		{
			if (!this.stage) return;
			
			if (event)
			{
				switch (event.kind)
				{
					case CollectionEventKind.ADD:
						for each (var page:DemoPage in event.items)
						{
							addPage(page);
						}
						break;
					case CollectionEventKind.REMOVE:
						for each (page in event.items)
						{
							var pageUI:DemoPageDisplay = getPage(page);
							this.containerUI.removeElement(pageUI);
							disposePage(pageUI);
						}
						break;
				}
			}
			else if (this.containerUI.numElements == 0)
			{
				for each (page in theme.pages.source)
				{
					addPage(page);
				}
			}
		}
		
		protected function allocPageDisplay():DemoPageDisplay
		{
			return DemoPoolUtil.alloc(DemoPageDisplay);
		}
		
		private function addPage(page:DemoPage):void
		{
			var pageComponent:DemoPageDisplay = allocPageDisplay();
			pageComponent.page = page;
			containerUI.addElement(pageComponent);
		}
		
		private function dispose():Vector.<IVisualElement>
		{
			if (_containerUI)
			{
				var pages:Vector.<DemoPageDisplay> = Vector.<DemoPageDisplay>(super.disposeContainer());
				
				for each (var page:DemoPageDisplay in pages)
				{
					disposePage(page);
				}
			}
			
			return null;
		}
		
		private function disposePage(page:DemoPageDisplay):void
		{
			var pageUI:DemoPageDisplay = DemoPageDisplay(page);
			pageUI.page = null;
			DemoPoolUtil.free(pageUI);
		}
		
		public function getPages():Vector.<DemoPageDisplay>
		{
			return Vector.<DemoPageDisplay>(super.getContainerElements());
		}
		
		public function getPage(page:DemoPage):DemoPageDisplay
		{
			if (page)
			{
				var pages:Vector.<DemoPageDisplay> = getPages();
				for each (var pageDisplay:DemoPageDisplay in pages)
				{
					if (pageDisplay.page == page) return pageDisplay;
				
				}
			}
			
			return null;
		}
		
		public function getElement(element:DemoElement):DemoElementDisplay
		{
			if (element)
			{
				var pages:Vector.<DemoPageDisplay> = getPages();
				for each (var pageDisplay:DemoPageDisplay in pages)
				{
					var elements:Vector.<DemoElementDisplay> = pageDisplay.getElements();
					for each (var elementDisplay:DemoElementDisplay in elements)
					{
						if (elementDisplay.element == element) return elementDisplay;
					}
				}
			}
			
			return null;
		}
	}
}