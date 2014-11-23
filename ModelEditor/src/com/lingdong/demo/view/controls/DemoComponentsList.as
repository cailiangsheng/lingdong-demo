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
			this.update();
			return;
			
			switch (event.kind)
			{
				case CollectionEventKind.ADD:
					for each (var resource:DemoResource in event.items)
					{
						addComponent(resource);
					}
					break;
				case CollectionEventKind.MOVE:
					var components:Vector.<DemoComponentDisplay> = new Vector.<DemoComponentDisplay>();
					for each (resource in event.items)
					{
						var index:int = resources.getItemIndex(resource);
						var component:DemoComponentDisplay = disposeComponentAt(index);
						components.push(component);
					}
					
					for each (component in components)
					{
						this.removeElement(component);
					}
					break;
			}
		}
		
		private function update(event:Event = null):void
		{
			for each (var resource:DemoResource in this.resources)
			{
				addComponent(resource);
			}
		}
		
		private function addComponent(resource:DemoResource):void
		{
			var component:DemoComponentDisplay = DemoPoolUtil.alloc(DemoComponentDisplay);
			component.maintainAspectRatio = true;
			component.hasBorder = true;
			component.buttonMode = true;
			component.width = 160;
			component.height = 120;
			component.resource = resource;
			this.addElement(component);
		}
		
		private function disposeComponentAt(index:int):DemoComponentDisplay
		{
			var component:DemoComponentDisplay = this.getChildAt(index) as DemoComponentDisplay;
			component.buttonMode = false;
			component.resource = null;
			DemoPoolUtil.free(component);
			
			return component;
		}
		
		private function dispose():void
		{
			for (var i:int = 0, n:int = this.numChildren; i < n; i++)
			{
				disposeComponentAt(i);
			}
			
			this.removeAllElements();
		}
	}
}