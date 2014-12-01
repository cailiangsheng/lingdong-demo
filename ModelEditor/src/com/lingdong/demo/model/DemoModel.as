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
			_theme = new DemoTheme();
			_designer = new DemoDesigner();
			_previewer = new DemoPreviewer();
			
			this.fetchTheme(this.themeIdRequested);
		}
		
		public function get themeIdRequested():String
		{
			var location:Object = DemoBrowserUtil.location;
			var str:String = String(location.search).substr(1);
			var param:Object = URLUtil.stringToObject(str, "&");
			return param.themeId;
		}
		
		private var themeIdFetched:String;
		private var themeIdFetching:String;
		
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
				this.theme.readConfig(themeConfig);
			}
			
			this.themeIdFetched = this.themeIdFetching;
			this.themeIdFetching = null;
			
			this.designer.activeTheme = theme;
		}
		
		private function onFetchError(result:Object):void
		{
			trace("Failed to fetch theme!");
			
			this.themeIdFetching = null;
			
			this.designer.activeTheme = theme;
		}
		
		private var _saving:Boolean;
		
		private function get saving():Boolean
		{
			return _saving;
		}
		
		private function set saving(value:Boolean):void
		{
			if (_saving != value)
			{
				_saving = value;
				
				_saving ? CursorManager.setBusyCursor() : CursorManager.removeBusyCursor();
			}
		}
		
		public function saveTheme():void
		{
			if (saving) return;
			
			saving = true;
			
			var themeConfig:Object = {};
			var fileIds:Array = [];
			this.theme.writeConfig(themeConfig, fileIds);
			
			DemoService.themeService.saveTheme(themeId, themeConfig, fileIds, onSaveTheme, onSaveError);
		}
		
		private function onSaveTheme(result:Object):void
		{
			saving = false;
		}
		
		private function onSaveError(result:Object):void
		{
			saving = false;
		}
	}
}

