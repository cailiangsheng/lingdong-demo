package com.lingdong.demo.view.pages
{
	import com.lingdong.demo.model.events.DemoElementEvent;
	import com.lingdong.demo.model.pages.DemoElement;
	import com.lingdong.demo.model.resources.DemoResource;
	import com.lingdong.demo.util.DemoPoolUtil;
	import com.lingdong.demo.view.resources.DemoResourceDisplay;
	
	import flash.events.Event;
	
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.events.ResizeEvent;

	public class DemoElementDisplay extends DemoComponentDisplay
	{
		private var _element:DemoElement;
		
		public function get element():DemoElement
		{
			return _element;
		}
		
		public function set element(value:DemoElement):void
		{
			if (_element != value)
			{
				_element && _element.removeEventListener(DemoElementEvent.X_CHANGE, updateX);
				_element && _element.removeEventListener(DemoElementEvent.Y_CHANGE, updateY);
				_element && _element.removeEventListener(DemoElementEvent.WIDTH_CHANGE, updateWidth);
				_element && _element.removeEventListener(DemoElementEvent.HEIGHT_CHANGE, updateHeight);
				_element && _element.removeEventListener(DemoElementEvent.DEPTH_CHANGE, updateDepth);
				_element && _element.removeEventListener(DemoElementEvent.ROTATION_CHANGE, updateRotation);
				
				this.dispose();
				
				_element = value;
				
				if (_element)
				{
					super.resource = _element.resource;
				}
				
				this.stage && update();
				
				_element && _element.addEventListener(DemoElementEvent.X_CHANGE, updateX);
				_element && _element.addEventListener(DemoElementEvent.Y_CHANGE, updateY);
				_element && _element.addEventListener(DemoElementEvent.WIDTH_CHANGE, updateWidth);
				_element && _element.addEventListener(DemoElementEvent.HEIGHT_CHANGE, updateHeight);
				_element && _element.addEventListener(DemoElementEvent.DEPTH_CHANGE, updateDepth);
				_element && _element.addEventListener(DemoElementEvent.ROTATION_CHANGE, updateRotation);
			}	
		}
		
		public function DemoElementDisplay()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onAddedToStage(event:Event = null):void
		{
			this.parent.addEventListener(ResizeEvent.RESIZE, updateSize);
			
			update();
		}
		
		private function onRemovedFromStage(event:Event = null):void
		{
			this.parent.removeEventListener(ResizeEvent.RESIZE, updateSize);
		}
		
		private function updateSize(event:Event = null):void
		{
			if (this.element)
			{
				updateX();
				updateY();
				updateWidth();
				updateHeight();
			}
		}
		
		private function update(event:Event = null):void
		{
			if (this.element)
			{
				updateSize();
				updateDepth();
				updateRotation();
			}
		}
		
		private function updateX(event:Event = null):void
		{
			this.x = element.x * this.parent.width;
		}
		
		private function updateY(event:Event = null):void
		{
			this.y = element.y * this.parent.height;
		}
		
		private function updateWidth(event:Event = null):void
		{
			this.width = Math.abs(element.width * this.parent.width / this.scaleX);
			this.scaleX *= sign(this.scaleX) * sign(element.width);
		}
		
		private function updateHeight(event:Event = null):void
		{
			this.height = Math.abs(element.height * this.parent.height / this.scaleY);
			this.scaleY *= sign(this.scaleY) * sign(element.height);
		}
		
		private static function sign(value:Number):int
		{
			return value >= 0 ? 1 : -1;
		}
		
		private function updateDepth(event:Event = null):void
		{
		}
		
		private function updateRotation(event:Event = null):void
		{
			this.rotation = element.rotation;
		}
		
		override protected function dispose():void
		{
			this.x = 0;
			this.y = 0;
			this.scaleX = 1;
			this.scaleY = 1;
			this.rotation = 0;
			
			super.dispose();
		}
	}
}