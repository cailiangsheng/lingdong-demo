package com.lingdong.demo.view.pages
{
	import com.greensock.events.TransformEvent;
	import com.greensock.transform.TransformItem;
	import com.greensock.transform.TransformManager;
	
	import flash.events.Event;

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
				_transformManager.allowDelete = false;
				_transformManager.handleFillColor = 0xFFFFFF;
				_transformManager.handleSize = 8;
				_transformManager.lineColor = 16746265;
				_transformManager.lockRotation = false;
				_transformManager.addEventListener(TransformEvent.FINISH_INTERACTIVE_MOVE, onTransform);
				_transformManager.addEventListener(TransformEvent.FINISH_INTERACTIVE_ROTATE, onTransform);
				_transformManager.addEventListener(TransformEvent.FINISH_INTERACTIVE_SCALE, onTransform);
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
			elementDisplay.element.x = item.x / this.width;
			elementDisplay.element.y = item.y / this.height;
			elementDisplay.element.width = elementDisplay.resourceWidth * item.scaleX / this.width;
			elementDisplay.element.height = elementDisplay.resourceHeight * item.scaleY / this.height;
			elementDisplay.element.rotation = item.rotation;
		}
		
		public function DemoPageDesignDisplay()
		{
		}
		
		override protected function clearElements():void
		{
			for each (var elementUI:DemoElementDisplay in elementUIs)
			{
				this.transformManager.removeItem(elementUI);
			}
			
			super.clearElements();
		}
		
		override protected function updateElements(event:Event=null):void
		{
			super.updateElements(event);
			
			for each (var elementUI:DemoElementDisplay in elementUIs)
			{
				this.transformManager.addItem(elementUI);
			}
		}
	}
}