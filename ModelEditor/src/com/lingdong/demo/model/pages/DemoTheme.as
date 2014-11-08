package com.lingdong.demo.model.pages
{
	import com.lingdong.demo.model.IDemoConfig;
	import com.lingdong.demo.model.traits.DemoPageSize;
	import com.lingdong.demo.model.traits.DemoShowStyle;
	import com.lingdong.demo.service.DemoService;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	[Event(name="change", type="flash.events.Event")]
	public class DemoTheme extends EventDispatcher implements IDemoConfig
	{
		public var id:String;
		public var name:String;
		public var pages:Vector.<DemoPage>;
		public var showStyle:DemoShowStyle;
		
		public function DemoTheme()
		{
			showStyle = new DemoShowStyle();
			pages = new Vector.<DemoPage>();
		}
		
		public function readConfig(config:Object):void
		{
			if (config)
			{
				this.id = config.id;
				this.name = config.name;
				this.showStyle.type = config.showStyle;
				
				for each (var pageConfig:Object in config.pages)
				{
					var page:DemoPage = new DemoPage();
					page.readConfig(pageConfig);
					
					this.pages.push(page);
				}
				
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		public function finalize():void
		{
			
		}
	}
}