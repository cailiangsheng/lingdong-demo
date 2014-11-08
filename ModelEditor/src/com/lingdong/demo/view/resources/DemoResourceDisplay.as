package com.lingdong.demo.view.resources
{
	import com.lingdong.demo.model.resources.DemoResource;
	import com.lingdong.demo.util.DemoPoolUtil;
	
	import mx.core.UIComponent;
	
	public class DemoResourceDisplay extends UIComponent
	{
		public static function getDisplay(type:String):DemoResourceDisplay
		{
			var clazz:Class = getDisplayClass(type);
			return DemoPoolUtil.alloc(clazz);
		}
		
		private static function getDisplayClass(type:String):Class
		{
			switch (type)
			{
				case DemoResource.BACKGROUND:
					return DemoBackgroundDisplay;
				case DemoResource.BUTTON:
					return DemoButtonDisplay;
				case DemoResource.IMAGE:
					return DemoImageDisplay;
				case DemoResource.TEXT:
					return DemoTextDisplay;
				case DemoResource.VIDEO:
					return DemoVideoDisplay;
			}
			
			return null;
		}
		
		public function get resource():DemoResource
		{
			return null;
		}
		
		public function set resource(value:DemoResource):void
		{
			throw new Error("to be override");
		}
		
		public function DemoResourceDisplay()
		{
		}
	}
}