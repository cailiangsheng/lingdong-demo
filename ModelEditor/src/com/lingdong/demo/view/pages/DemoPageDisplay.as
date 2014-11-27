package com.lingdong.demo.view.pages
{
	import com.lingdong.demo.model.DemoModel;
	import com.lingdong.demo.model.events.DemoElementsEvent;
	import com.lingdong.demo.model.events.DemoPageEvent;
	import com.lingdong.demo.model.pages.DemoElement;
	import com.lingdong.demo.model.pages.DemoPage;
	import com.lingdong.demo.model.resources.DemoBackground;
	import com.lingdong.demo.util.DemoPoolUtil;
	import com.lingdong.demo.view.resources.DemoBackgroundDisplay;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.Container;
	import mx.core.ScrollPolicy;
	import mx.events.CollectionEventKind;
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
				_page && _page.elements && _page.elements.removeEventListener(DemoElementsEvent.ELEMENTS_CHANGE, updateElements);
				
				this.dispose();
				
				_page = value;
				
				update();
				
				_page && _page.addEventListener(DemoPageEvent.BACKGROUND_CHANGE, updateBackground);
				_page && _page.elements && _page.elements.addEventListener(DemoElementsEvent.ELEMENTS_CHANGE, updateElements);
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
		
		private function updateSize(event:Event = null):void
		{
			var size:Point = DemoModel.instance.pageSize.getFitSize(this.parent);
			this.width = size.x;
			this.height = size.y;
			this.scrollRect = new Rectangle(0, 0, this.width, this.height);
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
			if (!this.stage) return;
			
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
		
		private function updateElements(event:DemoElementsEvent = null):void
		{
			if (!this.stage) return;
			
			if (event)
			{
				switch (event.kind)
				{
					case CollectionEventKind.ADD:
						for each (var element:DemoElement in event.items)
						{
							addElementDisplay(element);
						}
						break;
					case CollectionEventKind.REMOVE:
						for each (element in event.items)
						{
							var elementUI:DemoElementDisplay = getElement(element);
							removeElementDisplay(elementUI);
						}
						break;
				}
			}
			else if (elementUIs.length == 0)
			{
				for each (element in page.elements.source)
				{
					addElementDisplay(element);
				}
			}
		}
		
		protected function addElementDisplay(element:DemoElement):DemoElementDisplay
		{
			var elementUI:DemoElementDisplay = DemoPoolUtil.alloc(DemoElementDisplay);
			elementUI.element = element;
			elementUIs.push(elementUI);
			this.addChild(elementUI);
			return elementUI;
		}
		
		private function clearElements():void
		{
			for each (var elementUI:DemoElementDisplay in elementUIs)
			{
				removeElementDisplay(elementUI);
			}
			
			elementUIs.length = 0;
		}
		
		protected function removeElementDisplay(elementUI:DemoElementDisplay):void
		{
			var index:int = elementUIs.indexOf(elementUI);
			if (index >= 0)
			{
				elementUIs.splice(index, 1);
			}
			
			if (this.contains(elementUI))
			{
				this.removeChild(elementUI);
			}
			
			elementUI.element = null;
			DemoPoolUtil.free(elementUI);
		}
		
		private function dispose():void
		{
			removeBackground();
			clearElements();
			
			this.scrollRect = null;
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