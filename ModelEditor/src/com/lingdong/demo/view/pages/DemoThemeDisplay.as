package com.lingdong.demo.view.pages
{
	import com.dougmccune.containers.CoverFlowContainer;
	import com.lingdong.demo.model.events.DemoPagesEvent;
	import com.lingdong.demo.model.events.DemoThemeEvent;
	import com.lingdong.demo.model.pages.DemoPage;
	import com.lingdong.demo.model.pages.DemoTheme;
	import com.lingdong.demo.model.traits.DemoShowStyle;
	import com.lingdong.demo.util.DemoPoolUtil;
	
	import flash.events.Event;
	
	import mx.containers.ViewStack;
	import mx.core.Container;
	import mx.core.ScrollPolicy;
	import mx.core.UIComponent;
	import mx.events.CollectionEventKind;
	
	public class DemoThemeDisplay extends Container
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
			this.horizontalScrollPolicy = ScrollPolicy.OFF;
			this.verticalScrollPolicy = ScrollPolicy.OFF;
			this.percentWidth = 100;
			this.percentHeight = 100;
			
			this.addEventListener(Event.ADDED_TO_STAGE, update);
		}
		
		public function update(event:Event = null):void
		{
			if (this.theme)
			{
				updateShowStyle();
				updatePages();
			}
		}
		
		private static function getContainer(showStyle:String):ViewStack
		{
			switch (showStyle)
			{
				case DemoShowStyle.COVER_FLOW:
					var coverflow:CoverFlowContainer = DemoPoolUtil.alloc(CoverFlowContainer);
					coverflow.segments = 6;
					coverflow.reflectionEnabled = true;
					return coverflow;
			}
			
			return null;
		}
		
		private var _containerUI:ViewStack;
		
		private function get containerUI():ViewStack
		{
			if (!_containerUI)
			{
				_containerUI = getContainer(theme.showStyle);
				this.addChild(_containerUI);
			}
			
			_containerUI.width = this.width;
			_containerUI.height = this.height;
			return _containerUI;
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			
			this.containerUI.width = value;
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			
			this.containerUI.height = value;
		}
		
		private function updateShowStyle(event:Event = null):void
		{
			if (_containerUI)
			{
				var selectedIndex:int = _containerUI.selectedIndex;
				var pagesUI:Vector.<DemoPageDisplay> = new Vector.<DemoPageDisplay>();
				for (var i:int = 0; i < _containerUI.numElements; i++)
				{
					var pageUI:DemoPageDisplay = DemoPageDisplay(_containerUI.getElementAt(i));
					pagesUI.push(pageUI);
				}
				
				_containerUI.removeAllElements();
				this.removeChild(_containerUI);
				DemoPoolUtil.free(_containerUI);
				_containerUI = null;
				
				for each (pageUI in pagesUI)
				{
					this.containerUI.addElement(pageUI);
				}
				
				this.numPages = this.containerUI.numElements;
				this.selectedIndex = selectedIndex;
			}
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
				
				this.numPages = this.containerUI.numElements;
				this.selectedIndex = 0;
			}
		}
		
		private function dispose():void
		{
			if (_containerUI)
			{
				this.removeChild(_containerUI);
				
				for (var i:int = 0; i < _containerUI.numElements; i++)
				{
					var pageUI:DemoPageDisplay = DemoPageDisplay(_containerUI.getElementAt(i));
					pageUI.page = null;
					DemoPoolUtil.free(pageUI);
				}
				
				_containerUI.removeAllElements();
				DemoPoolUtil.free(_containerUI);
				_containerUI = null;
			}
		}
		
		private var _selectedIndex:int;
		
		[Bindable]
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		public function set selectedIndex(value:int):void
		{
			if (_selectedIndex != value)
			{
				_selectedIndex = value;
				
				this.containerUI.selectedIndex = value;
				
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		[Bindable]
		public var numPages:int;
	}
}