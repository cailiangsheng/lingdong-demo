package com.lingdong.demo.view.pages
{
	import com.lingdong.demo.model.resources.DemoResource;
	import com.lingdong.demo.util.DemoPoolUtil;
	import com.lingdong.demo.view.resources.DemoResourceDisplay;
	
	import flash.events.Event;
	
	import mx.core.UIComponent;
	
	public class DemoComponentDisplay extends UIComponent
	{
		private var _resource:DemoResource;
		
		public function get resource():DemoResource
		{
			return _resource;
		}
		
		public function set resource(value:DemoResource):void
		{
			if (_resource != value)
			{
				this.dispose();
				
				_resource = value;
				
				this.stage && update();
			}
		}
		
		private var _resourceUI:DemoResourceDisplay;
		
		private function get resourceUI():DemoResourceDisplay
		{
			if (!_resourceUI)
			{
				_resourceUI = DemoResourceDisplay.getDisplay(resource.type);
				_resourceUI.resource = resource;
				this.addChild(_resourceUI);
			}
			
			return _resourceUI;
		}
		
		public function DemoComponentDisplay()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, update);
		}
		
		private function update(event:Event = null):void
		{
			this.resource && this.resourceUI;
		}
		
		protected function dispose():void
		{
			if (_resourceUI)
			{
				_resourceUI.resource = null;
				_resourceUI.percentWidth = NaN;
				_resourceUI.percentHeight = NaN;
				this.removeChild(_resourceUI);
				
				DemoPoolUtil.free(_resourceUI);
				_resourceUI = null;
			}
		}
	}
}