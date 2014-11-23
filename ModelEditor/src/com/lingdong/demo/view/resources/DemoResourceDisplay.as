package com.lingdong.demo.view.resources
{
	import com.lingdong.demo.model.resources.DemoResource;
	import com.lingdong.demo.util.DemoPoolUtil;
	
	import flash.events.Event;
	
	import mx.core.UIComponent;
	import mx.events.ResizeEvent;
	
	import spark.components.BorderContainer;
	import spark.components.SkinnableContainer;
	
	public class DemoResourceDisplay extends SkinnableContainer
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
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.parent.addEventListener(ResizeEvent.RESIZE, updateSize);
			
			update();
		}
		
		private function onRemovedFromStage(event:Event):void
		{
			this.parent.removeEventListener(ResizeEvent.RESIZE, updateSize);
		}
		
		protected function update(event:Event = null):void
		{
			if (this.resource)
			{
				updateSize();
			}
		}
		
		protected function updateSize(event:ResizeEvent = null):void
		{
			if (!event || this.parent.width != event.oldWidth)
			{
				this.width = this.parent.width;
			}
			
			if (!event || this.parent.height != event.oldHeight)
			{
				this.height = this.parent.height;
			}
		}
	}
}