package com.lingdong.demo.view.pages
{
	import com.greensock.transform.TransformManager;
	
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class DemoPageDesignDisplay extends DemoPageDisplay
	{
		private var _transformMananger:TransformManager;
		
		private function get transformManager():TransformManager
		{
			if (!_transformMananger)
			{
				_transformMananger = new TransformManager();
				_transformMananger.forceSelectionToFront = false;
				_transformMananger.arrowKeysMove = true;
				_transformMananger.allowMultiSelect = true;
				_transformMananger.hideCenterHandle = true;
				_transformMananger.allowDelete = false;
				_transformMananger.handleFillColor = 0xFFFFFF;
				_transformMananger.handleSize = 8;
				_transformMananger.lineColor = 16746265;
				_transformMananger.lockRotation = false;
			}
			
			return _transformMananger;
		}
		
		public function DemoPageDesignDisplay()
		{
			super();
		}
		
		override protected function clearElements():void
		{
			for each (var elementUI:DemoElementDisplay in elementUIs)
			{
				this.transformManager.removeItem(elementUI);
				
				elementUI.x = 0;
				elementUI.y = 0;
				elementUI.scaleX = 1;
				elementUI.scaleY = 1;
				elementUI.rotation = 0;
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
		
		override protected function updateSize(event:Event=null):void
		{
			super.updateSize(event);
			
			this.scrollRect = new Rectangle(0, 0, this.width, this.height);
		}
		
		override protected function dispose():void
		{
			super.dispose();
			
			this.scrollRect = null;
		}
	}
}