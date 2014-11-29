package com.lingdong.demo.model.resources
{
	import com.lingdong.demo.model.IDemoConfig;
	
	import flash.events.EventDispatcher;
	import flash.text.Font;
	import flash.utils.Dictionary;
	
	import flashx.textLayout.formats.TextAlign;
	import flashx.textLayout.formats.VerticalAlign;
	
	import mx.collections.ArrayCollection;

	public class DemoResource extends EventDispatcher implements IDemoConfig
	{
		public static const BACKGROUND:String = "background";
		public static const BUTTON:String = "button";
		public static const IMAGE:String = "image";
		public static const TEXT:String = "text";
		public static const VIDEO:String = "video";
		public static const BITMAP:String = "bitmap";
		
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
		
		public function get type():String
		{
			return null;
		}
		
		public function DemoResource()
		{
		}
		
		public function readConfig(config:Object):void
		{
			throw new Error("to be override");
		}
		
		private static var _resources:Dictionary = new Dictionary();
		
		private static function getResourceList(clazz:Class):ArrayCollection
		{
			return _resources[clazz] ||= new ArrayCollection();
		}
		
		public static function addResource(resource:DemoResource):void
		{
			if (resource)
			{
				var clazz:Class = Object(resource).constructor;
				var list:ArrayCollection = getResourceList(clazz);
				if (list.getItemIndex(resource) == -1)
				{
					list.addItem(resource);
				}
			}
		}
		
		public static function removeResource(resource:DemoResource):void
		{
			if (resource)
			{
				var clazz:Class = Object(resource).constructor;
				var list:ArrayCollection = getResourceList(clazz);
				var index:int = list.getItemIndex(resource);
				if (index >= 0)
				{
					list.removeItemAt(index);
				}
			}
		}
		
		public static function get backgrounds():ArrayCollection
		{
			return getResourceList(DemoBackground);
		}
		
		public static function get images():ArrayCollection
		{
			return getResourceList(DemoImage);
		}
		
		public static function get videos():ArrayCollection
		{
			return getResourceList(DemoVideo);
		}
		
		private static var _texts:ArrayCollection;
		
		public static function get texts():ArrayCollection
		{
			if (!_texts)
			{
				_texts = new ArrayCollection()
				
				var fonts:Array = Font.enumerateFonts(true);
				for each (var font:Object in fonts)
				{
					var text:DemoText = new DemoText();
					text.fontStyle = font.fontName;
					text.content = font.fontName + "\nAaBbCc";
					text.fontSize = 24;
					text.color = 0x000000;
					text.textAlign = TextAlign.CENTER;
					text.verticalAlign = VerticalAlign.MIDDLE;
					
					_texts.addItem(text);
				}
			}
			
			return _texts;
		}
	}
}