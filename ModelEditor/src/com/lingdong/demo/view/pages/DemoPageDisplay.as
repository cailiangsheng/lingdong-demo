package com.lingdong.demo.view.pages
{
	import com.lingdong.demo.model.DemoModel;
	import com.lingdong.demo.model.events.DemoPageEvent;
	import com.lingdong.demo.model.pages.DemoElement;
	import com.lingdong.demo.model.pages.DemoPage;
	import com.lingdong.demo.model.resources.DemoBackground;
	import com.lingdong.demo.util.DemoPoolUtil;
	import com.lingdong.demo.view.resources.DemoBackgroundDisplay;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	import mx.core.Container;
	import mx.core.ScrollPolicy;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	
	public class DemoPageDisplay extends Container
	{
		private var _page:DemoPage;
		
		public function get page():DemoPage
		{
			return _page;
		}
		
		public function set page(value:DemoPage):void
		{
			if (_page != value)
			{
				_page && _page.removeEventListener(DemoPageEvent.BACKGROUND_CHANGE, updateBackground);
				_page && _page.removeEventListener(DemoPageEvent.ELEMENTS_CHANGE, updateElements);
				
				this.dispose();
				
				_page = value;
				
				this.stage && update();
				
				_page && _page.addEventListener(DemoPageEvent.BACKGROUND_CHANGE, updateBackground);
				_page && _page.addEventListener(DemoPageEvent.ELEMENTS_CHANGE, updateElements);
			}
		}
		
		private var _backgroundUI:DemoBackgroundDisplay;
		
		private function get backgroundUI():DemoBackgroundDisplay
		{
			if (!_backgroundUI)
			{
				_backgroundUI = DemoPoolUtil.alloc(DemoBackgroundDisplay);
				this.addChild(_backgroundUI);
			}
			
			return _backgroundUI;
		}
		
		protected var elementUIs:Vector.<DemoElementDisplay>;
		
		public function DemoPageDisplay()
		{
			this.horizontalScrollPolicy = ScrollPolicy.OFF;
			this.verticalScrollPolicy = ScrollPolicy.OFF;
			this.clipContent = true;
			
			elementUIs = new Vector.<DemoElementDisplay>();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			this.addEventListener(Event.RENDER, updateThumbnail);
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
		
		protected function updateSize(event:Event = null):void
		{
			var size:Point = DemoModel.instance.pageSize.getFitSize(this.parent);
			this.width = size.x;
			this.height = size.y;
		}
		
		private function update(event:Event = null):void
		{
			if (page)
			{
				updateBackground();
				updateElements();
			}
		}
		
		private function updateBackground(event:Event = null):void
		{
			if (page.background)
			{
				updateSize();
				this.backgroundUI.background = page.background;
			}
			else
			{
				removeBackground();
			}
		}
		
		private function removeBackground():void
		{
			if (_backgroundUI)
			{
				_backgroundUI.background = null;
				DemoPoolUtil.free(_backgroundUI);
				_backgroundUI = null;
			}
		}
		
		protected function updateElements(event:Event = null):void
		{
			clearElements();
			
			if (!page) return;
			
			for each (var element:DemoElement in page.elements.source)
			{
				var elementUI:DemoElementDisplay = DemoPoolUtil.alloc(DemoElementDisplay);
				elementUI.element = element;
				elementUIs.push(elementUI);
				this.addChild(elementUI);
			}
		}
		
		protected function clearElements():void
		{
			for each (var elementUI:DemoElementDisplay in elementUIs)
			{
				this.removeChild(elementUI);
				elementUI.element = null;
				DemoPoolUtil.free(elementUI);
			}
			
			elementUIs.length = 0;
		}
		
		protected function dispose():void
		{
			removeBackground();
			clearElements();
		}
		
		private function updateThumbnail(event:Event = null):void
		{
			page.thumbnail.draw(this, DemoModel.instance.pageSize.thumbnailSize);
		}
		
		public function getElements():Vector.<DemoElementDisplay>
		{
			return elementUIs
		}
		
		public function getElement(element:DemoElement):DemoElementDisplay
		{
			if (element)
			{
				for each (var elementDisplay:DemoElementDisplay in elementUIs)
				{
					if (elementDisplay.element == element) return elementDisplay;
				
				}
			}
			
			return null;
		}
	}
}