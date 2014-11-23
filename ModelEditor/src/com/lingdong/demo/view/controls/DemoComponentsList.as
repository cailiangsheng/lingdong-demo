package com.lingdong.demo.view.controls
{
	import com.lingdong.demo.model.resources.DemoResource;
	import com.lingdong.demo.util.DemoPoolUtil;
	import com.lingdong.demo.view.resources.DemoComponentDisplay;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import flashx.textLayout.container.ScrollPolicy;
	
	import mx.collections.ArrayCollection;
	import mx.containers.VBox;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	public class DemoComponentsList extends VBox
	{
		private var _resources:ArrayCollection;
		
		public function get resources():ArrayCollection
		{
			return _resources;
		}
		
		public function set resources(value:ArrayCollection):void
		{
			if (_resources != value)
			{
				_resources && _resources.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onResourcesChange);
				
				this.dispose();
				
				_resources = value;
				
				this.stage && this.update();
				
				_resources && _resources.addEventListener(CollectionEvent.COLLECTION_CHANGE, onResourcesChange);
			}
		}
		
		public function DemoComponentsList(gap:int = 10)
		{
			this.percentHeight = 100;
			this.percentWidth = 100;
			
			this.horizontalScrollPolicy = ScrollPolicy.AUTO;
			this.verticalScrollPolicy = ScrollPolicy.AUTO;
			
			this.setStyle("paddingTop", gap);
			this.setStyle("paddingBottom", gap);
			this.setStyle("verticalGap", gap);
			
			this.addEventListener(Event.ADDED_TO_STAGE, update);
		}
		
		override public function validateDisplayList():void
		{
			super.validateDisplayList();
			
			layoutChildren();
		}
		
		private function layoutChildren():void
		{
			var viewportWidth:Number = getViewportWidth();
			
			for (var i:int = 0, n:int = this.numChildren; i < n; i++)
			{
				var child:DisplayObject = this.getChildAt(i);
				child.x = viewportWidth / 2 - child.width / 2;
			}
		}
		
		private function getViewportWidth():Number
		{
			var viewportWidth:Number = this.width;
			viewportWidth -= this.verticalScrollBar ? this.verticalScrollBar.width : 0;
			
			return viewportWidth;
		}
		
		private function getViewportHeight():Number
		{
			var viewportHeight:Number = this.height;
			viewportHeight -= this.horizontalScrollBar ? this.horizontalScrollBar.height : 0;
			
			return viewportHeight;
		}
		
		private function onResourcesChange(event:CollectionEvent):void
		{
			this.dispose();
			
			update();
		}
		
		private function update(event:Event = null):void
		{
			for each (var resource:DemoResource in this.resources)
			{
				var component:DemoComponentDisplay = DemoPoolUtil.alloc(DemoComponentDisplay);
				component.width = 100;
				component.height = 100;
				component.resource = resource;
				this.addElement(component);
			}
		}
		
		private function dispose():void
		{
			for (var i:int = 0, n:int = this.numChildren; i < n; i++)
			{
				var component:DemoComponentDisplay = this.getChildAt(i) as DemoComponentDisplay;
				component.resource = null;
				DemoPoolUtil.free(component);
			}
			
			this.removeAllElements();
		}
	}
}