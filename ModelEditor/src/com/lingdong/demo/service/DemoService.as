package com.lingdong.demo.service
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	public class DemoService
	{
		public static const BASE_URL:String = "http://182.92.102.35:8080/lingdongServer/visit/";
		
		protected function getURL(path:String):String
		{
			return BASE_URL + path + ".do";
		}
		
		private static var _eventDispatcher:EventDispatcher;
		private static var _loginService:DemoLoginService;
		private static var _themeService:DemoThemeService;
		private static var _uploadService:DemoUploadService;
		
		public static function get eventDispatcher():EventDispatcher
		{
			return _eventDispatcher ||= new EventDispatcher();
		}
		
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
		
		protected function getRequest(path:String):URLRequest
		{
			var url:String = getURL(path);
			var request:URLRequest = new URLRequest(url);
			request.method = URLRequestMethod.POST;
			return request;
		}
		
		protected function call(path:String, 
							   param:Object, 
							   onComplete:Function = null, 
							   onError:Function = null):void
		{
			var request:URLRequest = getRequest(path);
			var loader:URLLoader = new URLLoader(request);
			var variables:URLVariables = new URLVariables();
			variables.param = JSON.stringify(param);
			request.data = variables;
			
			onError && loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			onError && loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			onComplete && loader.addEventListener(Event.COMPLETE, function(event:Event):void
			{
				var result:Object = JSON.parse(loader.data);
				(result.success == 1 ? onComplete : onError)(result);
			});
			
			loader.load(request);
		}
		
		internal static function dispatchSecurityErrorEvent():void
		{
			DemoService.eventDispatcher.dispatchEvent(new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR));
		}
	}
}