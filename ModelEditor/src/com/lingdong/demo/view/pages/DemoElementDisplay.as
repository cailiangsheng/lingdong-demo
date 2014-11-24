package com.lingdong.demo.view.pages
{
	import com.lingdong.demo.model.events.DemoElementEvent;
	import com.lingdong.demo.model.pages.DemoElement;
	import com.lingdong.demo.model.resources.DemoResource;
	import com.lingdong.demo.util.DemoPoolUtil;
	import com.lingdong.demo.view.resources.DemoComponentDisplay;
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
				_element && _element.removeEventListener(DemoElementEvent.SCALE_X_CHANGE, updateScaleX);
				_element && _element.removeEventListener(DemoElementEvent.SCALE_Y_CHANGE, updateScaleY);
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
				_element && _element.addEventListener(DemoElementEvent.SCALE_X_CHANGE, updateScaleX);
				_element && _element.addEventListener(DemoElementEvent.SCALE_Y_CHANGE, updateScaleY);
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
				updateScaleX();
				updateScaleY();
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
		
		private function updateScaleX(event:Event = null):void
		{
			this.scaleX = element.scaleX;
		}
		
		private function updateScaleY(event:Event = null):void
		{
			this.scaleY = element.scaleY;
		}
		
		private function updateWidth(event:Event = null):void
		{
			this.width = element.width * this.parent.width;
		}
		
		private function updateHeight(event:Event = null):void
		{
			this.height = element.height * this.parent.height;
		}
		
		private function updateRotation(event:Event = null):void
		{
			this.rotation = element.rotation;
		}
		
		private function updateDepth(event:Event = null):void
		{
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