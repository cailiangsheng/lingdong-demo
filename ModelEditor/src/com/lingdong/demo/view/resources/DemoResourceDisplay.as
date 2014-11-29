package com.lingdong.demo.view.resources
{
	import com.lingdong.demo.model.resources.DemoResource;
	import com.lingdong.demo.util.DemoPoolUtil;
	
	import flash.events.Event;
	
	import mx.core.UIComponent;
	import mx.events.ResizeEvent;
	
	import spark.components.BorderContainer;
	import spark.components.SkinnableContainer;
	
	public class DemoResourceDisplay extends BorderContainer
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
		
		public function get hasBorder():Boolean
		{
			return this.getStyle("borderVisible");
		}
		
		public function set hasBorder(value:Boolean):void
		{
			this.setStyle("borderVisible", value);
		}
		
		public function get hasBackground():Boolean
		{
			return this.getStyle("backgroundAlpha");
		}
		
		public function set hasBackground(value:Boolean):void
		{
			this.setStyle("backgroundAlpha", value ? 1 : 0);
		}
		
		public function get contentWidth():Number
		{
			return this.width;
		}
		
		public function get contentHeight():Number
		{
			return this.height;
		}
		
		public function DemoResourceDisplay()
		{
			this.hasBorder = false;
			this.hasBackground = false;
			
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
			updateSize();
		}
		
		protected function updateSize(event:ResizeEvent = null):void
		{
			if (!this.stage) return;
			
			if (!event || this.parent.width != event.oldWidth)
			{
				this.width = this.parent.width;
			}
			
			if (!event || this.parent.height != event.oldHeight)
			{
				this.height = this.parent.height;
			}
		}
		
		private var _maintainAspectRatio:Boolean;
		
		public function get maintainAspectRatio():Boolean
		{
			return _maintainAspectRatio;
		}
		
		public function set maintainAspectRatio(value:Boolean):void
		{
			if (_maintainAspectRatio != value)
			{
				_maintainAspectRatio = value;
				
				updateMaintainAspectRatio();
			}
		}
		
		protected function updateMaintainAspectRatio():void
		{
			throw new Error("to be override!");
		}
	}
}