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
		
		private static function newResource(type:String):DemoResource
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
		
		public static function getBackground(config:Object):DemoBackground
		{
			return getResource(config, BACKGROUND) as DemoBackground;
		}
		
		public static function getResource(config:Object, type:String = null):DemoResource
		{
			if (!config) return null;
			
			var resource:DemoResource = newResource(type || config.type);
			if (resource)
			{
				resource.readConfig(config);
				addResource(resource);
			}
			
			return resource;
		}
		
		public function get type():String
		{
			return null;
		}
		
		public function get isValid():Boolean
		{
			return false;
		}
		
		public function DemoResource()
		{
		}
		
		public function readConfig(config:Object):void
		{
			throw new Error("to be override");
		}
		
		public function writeConfig(config:Object, fileIds:Array):void
		{
			throw new Error("to be override");
		}
		
		public function compareResource(resource:DemoResource):Boolean
		{
			throw new Error("to be override");
			return false;
		}
		
		private static var _resources:Dictionary = new Dictionary();
		
		private static function getResourceList(clazz:Class):ArrayCollection
		{
			return _resources[clazz] ||= new ArrayCollection();
		}
		
		private static function getListForResource(resource:DemoResource):ArrayCollection
		{
			return resource ? getResourceList(Object(resource).constructor) : null;
		}
		
		internal static function addResource(resource:DemoResource):void
		{
			var list:ArrayCollection = getListForResource(resource);
			if (list && getResourceIndex(resource) == -1)
			{
				var text:DemoText = resource as DemoText;
				if (text)
				{
					resource = newTextResource(text.fontStyle);
				}
				
				list.addItem(resource);
			}
		}
		
		private static function getResourceIndex(resource:DemoResource):int
		{
			var list:ArrayCollection = getListForResource(resource);
			if (list)
			{
				for (var i:int = 0, n:int = list.length; i < n; i++)
				{
					var item:DemoResource = list.getItemAt(i) as DemoResource;
					if (item === resource || item.compareResource(resource))
					{
						return i;
					}
				}
			}
			
			return -1;
		}
		
		internal static function removeResource(resource:DemoResource):void
		{
			var list:ArrayCollection = getListForResource(resource);
			var index:int = getResourceIndex(resource);
			if (list && index >= 0)
			{
				list.removeItemAt(index);
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
				_texts = getResourceList(DemoText);
				
				var fonts:Array = Font.enumerateFonts(true);
				for each (var font:Object in fonts)
				{
					var text:DemoText = newTextResource(font.fontName);
					_texts.addItem(text);
				}
			}
			
			return _texts;
		}
		
		private static function newTextResource(fontName:String):DemoText
		{
			var text:DemoText = new DemoText();
			text.fontStyle = fontName;
			text.content = fontName + "\nAaBbCc";
			text.fontSize = 0.2;
			text.color = 0x000000;
			text.textAlign = TextAlign.CENTER;
			text.verticalAlign = VerticalAlign.MIDDLE;
			return text;
		}
	}
}