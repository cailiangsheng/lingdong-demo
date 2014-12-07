package com.lingdong.demo.service
{
	import com.lingdong.demo.model.events.DemoLoginEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class DemoService
	{
		private static var _loginService:DemoLoginService;
		private static var _themeService:DemoThemeService;
		private static var _uploadService:DemoUploadService;
		
		public static function get loginService():DemoLoginService
		{
			return _loginService ||= new DemoLoginService();
		}
		
		public static function get themeService():DemoThemeService
		{
			return _themeService ||= new DemoThemeService();
		}
		
		public static function get uploadService():DemoUploadService
		{
			return _uploadService ||= new DemoUploadService();
		}
		
		public function DemoService()
		{
		}
	}
}