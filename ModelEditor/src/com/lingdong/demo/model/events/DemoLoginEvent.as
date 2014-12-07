package com.lingdong.demo.model.events
{
	import flash.events.Event;
	
	public class DemoLoginEvent extends Event
	{
		public static const LOGIN_ERROR:String = "loginError";
		
		public var userName:String = "";
		public var password:String = "";
		
		public function DemoLoginEvent(type:String)
		{
			super(type);
		}
	}
}