package com.lingdong.demo.view.pages
{
	import com.lingdong.demo.model.events.DemoElementEvent;
	import com.lingdong.demo.model.pages.DemoElement;
	import com.lingdong.demo.model.resources.DemoResource;
	import com.lingdong.demo.util.DemoPoolUtil;
	import com.lingdong.demo.view.resources.DemoResourceDisplay;
	
	import flash.events.Event;
	
	import mx.core.UIComponent;

	public class DemoElementDisplay extends UIComponent
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
				
				_element = value;
				
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
			this.addEventListener(Event.ADDED_TO_STAGE, update);
		}
		
		private function update(event:Event = null):void
		{
			if (this.element)
			{
				updateX();
				updateY();
				updateWidth();
				updateHeight();
				updateDepth();
				updateRotation();
			}
		}
		
		private var _resourceUI:DemoResourceDisplay;
		
		private function get resourceUI():DemoResourceDisplay
		{
			if (!_resourceUI)
			{
				_resourceUI = DemoResourceDisplay.getDisplay(element.resource.type);
				_resourceUI.resource = element.resource;
				this.addChild(_resourceUI);
			}
			
			return _resourceUI;
		}
		
		private function updateX(event:Event = null):void
		{
			resourceUI.x = element.x * this.parent.width;
		}
		
		private function updateY(event:Event = null):void
		{
			resourceUI.y = element.y * this.parent.height;
		}
		
		private function updateWidth(event:Event = null):void
		{
			resourceUI.width = element.width * this.parent.width;
		}
		
		private function updateHeight(event:Event = null):void
		{
			resourceUI.height = element.height * this.parent.height;
		}
		
		private function updateDepth(event:Event = null):void
		{
		}
		
		private function updateRotation(event:Event = null):void
		{
		}
		
		private function dispose():void
		{
			if (_resourceUI)
			{
				_resourceUI.resource = null;
				this.removeChild(_resourceUI);
				
				DemoPoolUtil.free(_resourceUI);
				_resourceUI = null;
			}
		}
	}
}