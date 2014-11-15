package com.lingdong.demo.view.pages
{
	import com.lingdong.demo.model.events.DemoPagesEvent;
	import com.lingdong.demo.model.events.DemoThemeEvent;
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
				
				this.stage && this.update();
				
				_theme && _theme.addEventListener(DemoThemeEvent.SHOW_STYLE_CHANGE, updateShowStyle);
				_theme && _theme.pages.addEventListener(DemoPagesEvent.PAGES_CHANGE, updatePages);
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
			super.showStyle = theme.showStyle;
		}
		
		private function updatePages(event:DemoPagesEvent = null):void
		{
			if (event)
			{
				// to do
				switch (event.kind)
				{
					case CollectionEventKind.ADD:
						break;
					case CollectionEventKind.REMOVE:
						break;
					case CollectionEventKind.MOVE:
						break;
				}
			}
			else
			{
				for each (var page:DemoPage in theme.pages.source)
				{
					var pageComponent:DemoPageDisplay = DemoPoolUtil.alloc(DemoPageDisplay);
					pageComponent.page = page;
					containerUI.addElement(pageComponent);
				}
				
//				this.selectedIndex = 0;
			}
		}
		
		override protected function dispose():Vector.<IVisualElement>
		{
			if (_containerUI)
			{
				var currentElements:Vector.<IVisualElement> = super.dispose();
				
				for each (var element:IVisualElement in currentElements)
				{
					var pageUI:DemoPageDisplay = DemoPageDisplay(element);
					pageUI.page = null;
					DemoPoolUtil.free(pageUI);
				}
			}
			
			return null;
		}
	}
}