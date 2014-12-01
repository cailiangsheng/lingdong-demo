package com.lingdong.demo.model.pages
{
	import com.lingdong.demo.model.IDemoConfig;
	import com.lingdong.demo.model.events.DemoPagesEvent;
	import com.lingdong.demo.model.events.DemoThemeEvent;
	import com.lingdong.demo.model.traits.DemoPageSize;
	import com.lingdong.demo.model.traits.DemoShowStyle;
	import com.lingdong.demo.service.DemoService;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	
	[Event(name="showStyleChange", type="com.lingdong.demo.model.events.DemoThemeEvent")]
	public class DemoTheme extends EventDispatcher implements IDemoConfig
	{
		private var _showStyle:String = DemoShowStyle.DEFAULT;
		
		public function get showStyle():String
		{
			return _showStyle;
		}
		
		public function set showStyle(value:String):void
		{
			if (_showStyle != value)
			{
				_showStyle = value;
				
				this.dispatchEvent(new DemoThemeEvent(DemoThemeEvent.SHOW_STYLE_CHANGE));
			}
		}
		
		private var _pages:DemoPages;
		
		public function get pages():DemoPages
		{
			return _pages;
		}
		
		public function DemoTheme()
		{
			_pages = new DemoPages();
			_pages.addPage(new DemoPage());
		}
		
		public function readConfig(config:Object):void
		{
			if (config)
			{
				this.showStyle = config.showStyle;
				
				this.pages.removeAllPages();
				for each (var pageConfig:Object in config.pages)
				{
					var page:DemoPage = new DemoPage();
					page.readConfig(pageConfig);
					
					this.pages.addPage(page);
				}
			}
		}
		
		public function writeConfig(config:Object, fileIds:Array):void
		{
			if (config)
			{
				config.showStyle = this.showStyle;
				
				var pagesConfig:Array = [];
				config.pages = pagesConfig;
				for each (var page:DemoPage in this.pages.source)
				{
					var pageConfig:Object = {};
					page.writeConfig(pageConfig, fileIds);
					pagesConfig.push(pageConfig);
				}
			}
		}
	}
}