package com.lingdong.demo.model
{
	import com.lingdong.demo.model.pages.DemoTheme;
	import com.lingdong.demo.model.traits.DemoPageSize;
	import com.lingdong.demo.service.DemoService;
	import com.lingdong.demo.util.DemoBrowserUtil;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.utils.URLUtil;
	
	[Event(name="change", type="flash.events.Event")]
	public class DemoModel extends EventDispatcher
	{
		private static var _instance:DemoModel;
		
		public static function get instance():DemoModel
		{
			return _instance ||= new DemoModel();
		}
		
		public var pageSize:DemoPageSize;
		
		public var theme:DemoTheme;
		
		private var _activeTheme:DemoTheme;
		
		public function get activeTheme():DemoTheme
		{
			return _activeTheme ? _activeTheme : theme;
		}
		
		public function DemoModel()
		{
			pageSize = new DemoPageSize();
			theme = new DemoTheme();
		}
		
		public function get requestedThemeId():String
		{
			var location:Object = DemoBrowserUtil.location;
			var str:String = String(location.search).substr(1);
			var param:Object = URLUtil.stringToObject(str, "&");
			return param.themeId;
		}
		
		public function initialize():void
		{
			update(requestedThemeId);
		}
		
		public function update(themeId:String = null):void
		{
			if (themeId)
			{
				DemoService.themeService.fetchTheme(themeId, onFetchTheme, onFetchError);
			}
		}
		
		private function onFetchTheme(result:Object):void
		{
			var themeConfig:Object = JSON.parse(result.themeConfigJson);
			theme.readConfig(themeConfig);
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function onFetchError(result:Object):void
		{
			trace("Fetch theme failed!");
		}
		
		public function finalize():void
		{
		}
	}
}

