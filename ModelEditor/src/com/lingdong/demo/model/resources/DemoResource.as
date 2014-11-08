package com.lingdong.demo.model.resources
{
	import com.lingdong.demo.model.IDemoConfig;
	
	import flash.events.EventDispatcher;

	public class DemoResource extends EventDispatcher implements IDemoConfig
	{
		public static const BACKGROUND:String = "background";
		public static const BUTTON:String = "button";
		public static const IMAGE:String = "image";
		public static const TEXT:String = "text";
		public static const VIDEO:String = "video";
		
		public static function getResource(type:String):DemoResource
		{
			switch (type)
			{
				case BACKGROUND:
					return new DemoBackground();
				case BUTTON:
					return new DemoButton();
				case IMAGE:
					return new DemoImage();
				case TEXT:
					return new DemoText();
				case VIDEO:
					return new DemoVideo();
			}
			
			return null;
		}
		
		protected var _type:String;
		
		public function get type():String
		{
			return _type;
		}
		
		public function DemoResource()
		{
			_type = type;
		}
		
		public function readConfig(config:Object):void
		{
			throw new Error("to be override");
		}
	}
}