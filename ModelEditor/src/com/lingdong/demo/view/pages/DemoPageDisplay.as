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
	import mx.core.UIComponent;
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
		
		protected function get backgroundUI():DemoBackgroundDisplay
		{
			if (!_backgroundUI)
			{
				_backgroundUI = DemoPoolUtil.alloc(DemoBackgroundDisplay);
				this.addChildAt(_backgroundUI, 0);
			}
			
			return _backgroundUI;
		}
		
		public function DemoPageDisplay()
		{
			this.horizontalScrollPolicy = ScrollPolicy.OFF;
			this.verticalScrollPolicy = ScrollPolicy.OFF;
			this.clipContent = true;
			
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
			this.elementLayer.width = this.width = size.x;
			this.elementLayer.height = this.height = size.y;
			this.scrollRect = new Rectangle(0, 0, this.width, this.height);
		}
		
		protected function update(event:Event = null):void
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
				addBackground();
			}
			else
			{
				removeBackground();
			}
		}
		
		protected function addBackground():void
		{
			updateSize();
			this.backgroundUI.background = page.background;
		}
		
		protected function removeBackground():void
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
			else if (this.elementLayer.numChildren == 0)
			{
				for each (element in page.elements.source)
				{
					addElementDisplay(element);
				}
			}
		}
		
		private var _elementLayer:UIComponent;
		
		private function get elementLayer():UIComponent
		{
			if (!_elementLayer)
			{
				_elementLayer = DemoPoolUtil.alloc(UIComponent);
				this.addChild(_elementLayer);
			}
			
			return _elementLayer;
		}
		
		protected function addElementDisplay(element:DemoElement):DemoElementDisplay
		{
			var elementUI:DemoElementDisplay = DemoPoolUtil.alloc(DemoElementDisplay);
			elementUI.element = element;
			this.elementLayer.addChild(elementUI);
			return elementUI;
		}
		
		private function clearElements():void
		{
			while (this.elementLayer.numChildren > 0)
			{
				var elementUI:DemoElementDisplay = this.elementLayer.getChildAt(0) as DemoElementDisplay;
				removeElementDisplay(elementUI);
			}
		}
		
		protected function removeElementDisplay(elementUI:DemoElementDisplay):void
		{
			if (!elementUI) return;
			
			if (this.elementLayer.contains(elementUI))
			{
				this.elementLayer.removeChild(elementUI);
			}
			
			elementUI.element = null;
			DemoPoolUtil.free(elementUI);
		}
		
		protected function dispose():void
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
			var elementUIs:Vector.<DemoElementDisplay> = new Vector.<DemoElementDisplay>();
			for (var i:int = 0, n:int = this.elementLayer.numChildren; i < n; i++)
			{
				elementUIs.push(this.elementLayer.getChildAt(i) as DemoElementDisplay);
			}
			return elementUIs;
		}
		
		public function getElement(element:DemoElement):DemoElementDisplay
		{
			if (element)
			{
				for (var i:int = 0, n:int = this.elementLayer.numChildren; i < n; i++)
				{
					var elementDisplay:DemoElementDisplay = this.elementLayer.getChildAt(i) as DemoElementDisplay;
					if (elementDisplay && elementDisplay.element == element) return elementDisplay;
				}
			}
			
			return null;
		}
	}
}