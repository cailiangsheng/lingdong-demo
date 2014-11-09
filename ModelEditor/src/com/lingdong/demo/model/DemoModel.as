package com.lingdong.demo.model
{
	import com.lingdong.demo.model.events.DemoModelEvent;
	import com.lingdong.demo.model.events.DemoThemeEvent;
	import com.lingdong.demo.model.pages.DemoElement;
	import com.lingdong.demo.model.pages.DemoTheme;
	import com.lingdong.demo.model.traits.DemoPageSize;
	import com.lingdong.demo.service.DemoService;
	import com.lingdong.demo.util.DemoBrowserUtil;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.utils.URLUtil;
	
	public class DemoModel extends EventDispatcher
	{
		private static var _instance:DemoModel;
		
		public static function get instance():DemoModel
		{
			return _instance ||= new DemoModel();
		}
		
		private var _pageSize:DemoPageSize;
		
		public function get pageSize():DemoPageSize
		{
			return _pageSize;
		}
		
		private var _theme:DemoTheme;
		
		public function get theme():DemoTheme
		{
			return _theme;
		}
		
		private var _designer:DemoDesigner;
		
		public function get designer():DemoDesigner
		{
			return _designer;
		}
		
		private var _previewer:DemoPreviewer;
		
		public function DemoModel()
		{
			_pageSize = new DemoPageSize();
			_theme = new DemoTheme();
			_designer = new DemoDesigner();
			_previewer = new DemoPreviewer();
			
			this.update(this.requestedThemeId);
		}
		
		public function get requestedThemeId():String
		{
			var location:Object = DemoBrowserUtil.location;
			var str:String = String(location.search).substr(1);
			var param:Object = URLUtil.stringToObject(str, "&");
			return param.themeId;
		}
		
		public function update(themeId:String):void
		{
			if (themeId)
			{
				DemoService.themeService.fetchTheme(themeId, onFetchTheme, onFetchError);
			}
		}
		
		private function onFetchTheme(result:Object):void
		{
			var themeConfigJson:String = result.themeConfigJson;
			if (themeConfigJson)
			{
				var themeConfig:Object = JSON.parse(themeConfigJson);
				theme.readConfig(themeConfig);
			}
			
			this.designer.activeTheme = theme;
		}
		
		private function onFetchError(result:Object):void
		{
			trace("Failed to fetch theme!");
			this.designer.activeTheme = theme;
		}
	}
}

