package com.lingdong.demo.view.pages
{
	import com.greensock.events.TransformEvent;
	import com.greensock.transform.TransformItem;
	import com.greensock.transform.TransformManager;
	import com.lingdong.demo.model.events.DemoElementsEvent;
	import com.lingdong.demo.model.pages.DemoElement;
	import com.lingdong.demo.model.resources.DemoBackground;
	import com.lingdong.demo.model.resources.DemoResource;
	import com.lingdong.demo.view.resources.DemoComponentDisplay;
	
	import flash.events.Event;
	
	import mx.events.DragEvent;
	import mx.managers.DragManager;

	public class DemoPageDesignDisplay extends DemoPageDisplay
	{
		private var _transformManager:TransformManager;
		
		private function get transformManager():TransformManager
		{
			if (!_transformManager)
			{
				_transformManager = new TransformManager();
				_transformManager.forceSelectionToFront = false;
				_transformManager.arrowKeysMove = true;
				_transformManager.allowMultiSelect = true;
				_transformManager.hideCenterHandle = true;
				_transformManager.allowDelete = true;
				_transformManager.handleFillColor = 0xffffff;
				_transformManager.handleSize = 8;
				_transformManager.lineColor = 0xff8719;
				_transformManager.lockRotation = false;
				_transformManager.addEventListener(TransformEvent.MOVE, onTransform);
				_transformManager.addEventListener(TransformEvent.ROTATE, onTransform);
				_transformManager.addEventListener(TransformEvent.SCALE, onTransform);
				_transformManager.addEventListener(TransformEvent.DELETE, onDelete);
			}
			
			return _transformManager;
		}
		
		private function onTransform(event:TransformEvent):void
		{
			for each(var item:TransformItem in event.items)
			{
				transformElement(item);
			}
		}
		
		private function transformElement(item:TransformItem):void
		{
			var elementDisplay:DemoElementDisplay = item.targetObject as DemoElementDisplay;
			elementDisplay.element.x = elementDisplay.x / this.width;
			elementDisplay.element.y = elementDisplay.y / this.height;
			elementDisplay.element.scaleX = elementDisplay.scaleX;
			elementDisplay.element.scaleY = elementDisplay.scaleY;
			elementDisplay.element.rotation = elementDisplay.rotation;
		}
		
		private function onDelete(event:TransformEvent):void
		{
			for each(var item:TransformItem in event.items)
			{
				var elementDisplay:DemoElementDisplay = item.targetObject as DemoElementDisplay;
				this.page.elements.removeElement(elementDisplay.element);
			}
		}
		
		public function DemoPageDesignDisplay()
		{
			this.addEventListener(DragEvent.DRAG_ENTER, onDragEnter);
			this.addEventListener(DragEvent.DRAG_DROP, onDragDrop);
		}
		
		private function onDragEnter(event:DragEvent):void
		{
			var component:DemoComponentDisplay = DemoComponentDisplay(event.dragInitiator);
			if (component && component.resource)
			{
				DragManager.acceptDragDrop(this);
			}
		}
		
		private function onDragDrop(event:DragEvent):void
		{
			var component:DemoComponentDisplay = DemoComponentDisplay(event.dragInitiator);
			var background:DemoBackground = component.resource as DemoBackground;
			if (background)
			{
				this.page.background = background;
			}
			else
			{
				var element:DemoElement = new DemoElement(component.resource);
				element.width = component.width / this.width;
				element.height = component.height / this.height;
				element.x = event.localX / this.width - element.width / 2;
				element.y = event.localY / this.height - element.height / 2;
				this.page.elements.addElement(element);
			}
		}
		
		override protected function removeElementDisplay(elementUI:DemoElementDisplay):void
		{
			super.removeElementDisplay(elementUI);
			
			this.transformManager.removeItem(elementUI);
		}
		
		override protected function addElementDisplay(element:DemoElement):DemoElementDisplay
		{
			var elementUI:DemoElementDisplay = super.addElementDisplay(element);
			
			this.transformManager.addItem(elementUI);
			
			return elementUI;
		}
	}
}