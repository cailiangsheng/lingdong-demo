package com.lingdong.demo.view.pages
{
	import com.lingdong.demo.model.traits.DemoShowStyle;
	import com.lingdong.demo.util.DemoPoolUtil;
	import com.lingdong.demo.view.containers.CoverflowContainer;
	import com.lingdong.demo.view.containers.IDemoContainer;
	import com.lingdong.demo.view.containers.SingleContainer;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.containers.ViewStack;
	import mx.core.Container;
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.events.ChildExistenceChangedEvent;
	import mx.events.IndexChangedEvent;
	import mx.events.ResizeEvent;
	
	[Event(name="selectedIndexChange", type="flash.events.Event")]
	public class DemoContainerDisplay extends UIComponent
	{
		protected function allocContainer(showStyle:String):IDemoContainer
		{
			switch (showStyle)
			{
				case DemoShowStyle.SINGLE:
					return DemoPoolUtil.alloc(SingleContainer);
					
				case DemoShowStyle.COVER_FLOW:
					return DemoPoolUtil.alloc(CoverflowContainer);
			}
			
			return null;
		}
		
		private var _showStyle:String;
		
		public function get showStyle():String
		{
			return _showStyle;
		}
		
		public function set showStyle(value:String):void
		{
			if (_showStyle != value)
			{
				_showStyle = value;
				
				update();
			}
		}
		
		public function DemoContainerDisplay()
		{
			this.percentWidth = 100;
			this.percentHeight = 100;
			
			this.addEventListener(Event.ADDED_TO_STAGE, update);
			this.addEventListener(ResizeEvent.RESIZE, update);
		}
		
		protected var _containerUI:IDemoContainer;
		
		protected function get containerUI():IDemoContainer
		{
			if (!_containerUI)
			{
				_containerUI = allocContainer(showStyle);
				
				if (_containerUI)
				{
					_containerUI.addEventListener(IndexChangedEvent.CHANGE, updateSelectedIndex);
					_containerUI.width = this.width;
					_containerUI.height = this.height;
					this.addChild(_containerUI as DisplayObject);
				}
			}
			
			return _containerUI;
		}
		
		private function update(event:Event = null):void
		{
			if (!this.stage) return;
			
			if (_containerUI)
			{
				var selectedIndex:int = _containerUI.selectedIndex;
				var currentElements:Vector.<IVisualElement> = disposeContainer();
				
				for each (var element:IVisualElement in currentElements)
				{
					this.containerUI.addElement(element);
				}
				
				this.containerUI.selectedIndex = selectedIndex;
			}
		}
		
		public function getContainerElements():Vector.<IVisualElement>
		{
			var elements:Vector.<IVisualElement> = null;
			
			if (_containerUI)
			{
				elements = new Vector.<IVisualElement>();
				for (var i:int = 0; i < _containerUI.numElements; i++)
				{
					var element:IVisualElement = _containerUI.getElementAt(i);
					elements.push(element);
				
				}
			}
			
			return elements;
		}
		
		protected function disposeContainer():Vector.<IVisualElement>
		{
			var elements:Vector.<IVisualElement> = getContainerElements();
			
			if (_containerUI)
			{
				_containerUI.removeEventListener(IndexChangedEvent.CHANGE, updateSelectedIndex);
				
				_containerUI.removeAllElements();
				this.removeChild(_containerUI as DisplayObject);
				DemoPoolUtil.free(_containerUI);
				_containerUI = null;
			}
			
			return elements;
		}
		
		private var _selectedIndex:int;
		
		[Bindable("selectedIndexChange")]
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		public function set selectedIndex(value:int):void
		{
			if (_selectedIndex != value)
			{
				_selectedIndex = value;
				
				this.containerUI.selectedIndex = value;
				
				this.dispatchEvent(new Event("selectedIndexChange"));
			}
		}
		
		private function updateSelectedIndex(event:Event):void
		{
			this.selectedIndex = this.containerUI.selectedIndex;
		}
	}
}