package com.lingdong.demo.service
{
	public class DemoThemeService extends DemoSessionService
	{
		public static const FETCH_THEME:String = "getThemeConfigJson";
		public static const SAVE_THEME:String = "setThemeConfigJson";
		
		public function DemoThemeService()
		{
		}
		
		public function fetchTheme(themeId:String, onFetchTheme:Function, onError:Function):void
		{
			if (themeId)
			{
				call(FETCH_THEME, {themeId: themeId}, onFetchTheme, onError);
			}
		}
		
		public function saveTheme(themeId:String, themeConfig:Object, fileIds:Array, onSaveTheme:Function, onError:Function):void
		{
			var themeConfigJson:String = JSON.stringify(themeConfig);
			call(SAVE_THEME, {themeId: themeId, themeConfigJson: themeConfigJson, fileIds: fileIds}, onSaveTheme, onError);
		}
	}
}