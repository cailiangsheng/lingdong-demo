package com.lingdong.demo.model.pages
{
	import com.lingdong.demo.model.IDemoConfig;
	import com.lingdong.demo.model.events.DemoPagesEvent;
	import com.lingdong.demo.model.events.DemoThemeEvent;
	import com.lingdong.demo.model.traits.DemoPageSize;
	import com.lingdong.demo.model.traits.DemoShowStyle;
	
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
			if (this.parent && this.parent.parent)
			{
				return this.parent.parent.showStyle;
			}
			
			return _showStyle;
		}
		
		public function set showStyle(value:String):void
		{
			if (this.parent && this.parent.parent)
			{
				this.parent.parent.showStyle = value;
			}
			else if (_showStyle != value)
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
		
		private var _parent:DemoPage;
		
		public function get parent():DemoPage
		{
			return _parent;
		}
		
		public function DemoTheme(parent:DemoPage)
		{
			_parent = parent;
			_pages = new DemoPages();
			_pages.addPage(new DemoPage(this));
		}
		
		public function readConfig(config:Object):void
		{
			if (config)
			{
				if (!this.parent)
				{
					this.showStyle = config.showStyle;
				}
				
				this.pages.removeAllPages();
				for each (var pageConfig:Object in config.pages)
				{
					var page:DemoPage = new DemoPage(this);
					page.readConfig(pageConfig);
					
					this.pages.addPage(page);
				}
			}
		}
		
		public function writeConfig(config:Object, fileIds:Array):void
		{
			if (config)
			{
				if (!this.parent)
				{
					config.showStyle = this.showStyle;
				}
				
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