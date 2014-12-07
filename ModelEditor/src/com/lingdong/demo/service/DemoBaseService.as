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

	public class DemoBaseService extends EventDispatcher
	{
		public static const BASE_URL:String = "http://182.92.102.35:8080/lingdongServer/visit/";
		
		protected function getURL(path:String):String
		{
			return BASE_URL + path + ".do";
		}
		
		public function DemoBaseService()
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
	}
}