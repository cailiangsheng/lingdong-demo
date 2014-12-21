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
	
	import mx.managers.CursorManager;
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
			_designer = new DemoDesigner();
			_previewer = new DemoPreviewer();
		}
		
		public function initialize():void
		{
			this.clear();
			this.fetchTheme(this.themeIdRequested);
		}
		
		public function clear():void
		{
			update(null);
		}
		
		public function reset():void
		{
			update(this.lastThemeConfig);
		}
		
		private function update(themeConfig:Object):void
		{
			var activePageIndex:int = this.designer.activePage ? this.designer.activeTheme.pages.getPageIndex(this.designer.activePage) : -1;
			
			_theme = new DemoTheme(null);
			
			if (themeConfig)
			{
				this.theme.readConfig(themeConfig);
			}
			
			this.designer.activeTheme = this.theme;
			this.designer.activePage = this.theme.pages.getPageAt(activePageIndex);
		}
		
		public function get themeIdRequested():String
		{
			var location:Object = DemoBrowserUtil.location;
			var str:String = String(location.search).substr(1);
			var param:Object = URLUtil.stringToObject(str, "&");
			return param.themeId;
		}
		
		private var lastThemeConfig:Object;
		
		private var themeIdFetched:String;
		
		private var _themeIdFetching:String;
		
		private function get themeIdFetching():String
		{
			return _themeIdFetching;
		}
		
		private function set themeIdFetching(value:String):void
		{
			if (_themeIdFetching != value)
			{
				_themeIdFetching = value;
				
				_themeIdFetching ? CursorManager.setBusyCursor() : CursorManager.removeBusyCursor();
			}
		}
		
		public function get themeId():String
		{
			return this.themeIdFetched;
		}
		
		public function fetchTheme(themeId:String):void
		{
			if (themeId && !this.themeIdFetching)
			{
				this.themeIdFetching = themeId;
				DemoService.themeService.fetchTheme(themeId, onFetchTheme, onFetchError);
			}
		}
		
		private function onFetchTheme(result:Object):void
		{
			var themeConfigJson:String = result.themeConfigJson;
			if (themeConfigJson)
			{
				var themeConfig:Object = JSON.parse(themeConfigJson);
				this.lastThemeConfig = themeConfig;
			}
			else
			{
				this.lastThemeConfig = {};
			}
			
			this.themeIdFetched = this.themeIdFetching;
			this.themeIdFetching = null;
			this.reset();
		}
		
		private function onFetchError(result:Object):void
		{
			this.themeIdFetching = null;
			
			this.designer.activeTheme = theme;
		}
		
		private var _themeConfigSaving:Object;
		
		private function get themeConfigSaving():Object
		{
			return _themeConfigSaving;
		}
		
		private function set themeConfigSaving(value:Object):void
		{
			if (_themeConfigSaving != value)
			{
				_themeConfigSaving = value;
				
				_themeConfigSaving ? CursorManager.setBusyCursor() : CursorManager.removeBusyCursor();
			}
		}
		
		public function saveTheme():void
		{
			if (themeConfigSaving) return;
			
			var themeConfig:Object = this.themeConfigSaving = {};
			var fileIds:Array = [];
			this.theme.writeConfig(themeConfig, fileIds);
			
			DemoService.themeService.saveTheme(themeId, themeConfig, fileIds, onSaveTheme, onSaveError);
		}
		
		private function onSaveTheme(result:Object):void
		{
			this.lastThemeConfig = this.themeConfigSaving;
			this.themeConfigSaving = null;
		}
		
		private function onSaveError(result:Object):void
		{
			this.themeConfigSaving = null;
		}
	}
}

