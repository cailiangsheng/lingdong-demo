package com.lingdong.demo.model
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;

	[Event(name="invalidSession", type="flash.events.Event")]
	public class DemoSessionModel extends EventDispatcher
	{
		public static const INVALID_SESSION:String = "invalidSession";
		
		public function DemoSessionModel()
		{
		}
		
		private function get hasSessionID():void
		{
			if (ExternalInterface.available)
			{
				var cookie:String = ExternalInterface.call("document.cookie");
				return cookie && cookie.indexOf("JSESSIONID") >= 0;
			}
		}
		
		public function initialize():void
		{
			if (!hasSessionID)
			{
				dispatchEvent(new Event(INVALID_SESSION));
			}
		}
	}
}