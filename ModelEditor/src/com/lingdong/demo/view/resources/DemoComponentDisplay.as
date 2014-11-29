package com.lingdong.demo.view.resources
{
	import com.lingdong.demo.model.resources.DemoBackground;
	import com.lingdong.demo.model.resources.DemoResource;
	import com.lingdong.demo.util.DemoPoolUtil;
	
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
				
				update();
			}
		}
		
		private var _resourceUI:DemoResourceDisplay;
		
		private function get resourceUI():DemoResourceDisplay
		{
			if (!_resourceUI)
			{
				_resourceUI = DemoResourceDisplay.getDisplay(resource.type);
				_resourceUI.maintainAspectRatio = this.maintainAspectRatio;
				_resourceUI.hasBorder = this.hasBorder;
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
			if (!this.stage) return;
			
			this.resource && this.resourceUI;
		}
		
		protected function dispose():void
		{
			if (_resourceUI)
			{
				_resourceUI.maintainAspectRatio = false;
				_resourceUI.hasBorder = false;
				_resourceUI.resource = null;
				this.removeChild(_resourceUI);
				
				DemoPoolUtil.free(_resourceUI);
				_resourceUI = null;
			}
		}
		
		private var _maintainAspectRatio:Boolean;
		
		public function get maintainAspectRatio():Boolean
		{
			return _maintainAspectRatio && !(this.resource is DemoBackground);
		}
		
		public function set maintainAspectRatio(value:Boolean):void
		{
			if (_maintainAspectRatio != value)
			{
				_maintainAspectRatio = value;
				
				if (_resourceUI)
				{
					_resourceUI.maintainAspectRatio = this.maintainAspectRatio;
				}
			}
		}
		
		private var _hasBorder:Boolean;
		
		public function get hasBorder():Boolean
		{
			return _hasBorder;
		}
		
		public function set hasBorder(value:Boolean):void
		{
			if (_hasBorder != value)
			{
				_hasBorder = value;
				
				if (_resourceUI)
				{
					_resourceUI.hasBorder = this.hasBorder;
				}
			}
		}
		
		public function get contentWidth():Number
		{
			return _resourceUI ? _resourceUI.contentWidth : this.width;
		}
		
		public function get contentHeight():Number
		{
			return _resourceUI ? _resourceUI.contentHeight : this.height;
		}
	}
}