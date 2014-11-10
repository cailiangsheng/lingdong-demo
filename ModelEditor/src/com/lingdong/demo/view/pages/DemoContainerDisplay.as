package com.lingdong.demo.view.pages
{
	import com.dougmccune.containers.CoverFlowContainer;
	import com.lingdong.demo.model.traits.DemoShowStyle;
	import com.lingdong.demo.util.DemoPoolUtil;
	import com.lingdong.demo.view.containers.SingleContainer;
	
	import flash.events.Event;
	
	import mx.containers.ViewStack;
	import mx.core.Container;
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.events.ChildExistenceChangedEvent;
	import mx.events.IndexChangedEvent;
	
	public class DemoContainerDisplay extends UIComponent
	{
		protected function getContainer(showStyle:String):ViewStack
		{
			switch (showStyle)
			{
				case DemoShowStyle.SINGLE:
					return DemoPoolUtil.alloc(SingleContainer);
					
				case DemoShowStyle.COVER_FLOW:
					var coverflow:CoverFlowContainer = DemoPoolUtil.alloc(CoverFlowContainer);
					coverflow.segments = 6;
					coverflow.reflectionEnabled = true;
					return coverflow;
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
				this.dispose();
				
				_showStyle = value;
				
				this.stage && update();
			}
		}
		
		public function DemoContainerDisplay()
		{
			this.percentWidth = 100;
			this.percentHeight = 100;
			
			this.addEventListener(Event.ADDED_TO_STAGE, update);
		}
		
		protected var _containerUI:ViewStack;
		
		protected function get containerUI():ViewStack
		{
			if (!_containerUI)
			{
				_containerUI = getContainer(showStyle);
				_containerUI.addEventListener(IndexChangedEvent.CHANGE, updateSelectedIndex);
				_containerUI.addEventListener(ChildExistenceChangedEvent.CHILD_ADD, updateChildrenCount);
				_containerUI.addEventListener(ChildExistenceChangedEvent.CHILD_REMOVE, updateChildrenCount);
				this.addChild(_containerUI);
			}
			
			_containerUI.width = this.width;
			_containerUI.height = this.height;
			return _containerUI;
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			
			this.containerUI.width = value;
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			
			this.containerUI.height = value;
		}
		
		private function update(event:Event = null):void
		{
			if (_containerUI)
			{
				var selectedIndex:int = _containerUI.selectedIndex;
				var currentElements:Vector.<IVisualElement> = this.dispose();
				
				for each (var element:IVisualElement in currentElements)
				{
					this.containerUI.addElement(element);
				}
				
				this.containerUI.selectedIndex = selectedIndex;
			}
		}
		
		protected function dispose():Vector.<IVisualElement>
		{
			var elements:Vector.<IVisualElement> = null;
			
			if (_containerUI)
			{
				_containerUI.removeEventListener(IndexChangedEvent.CHANGE, updateSelectedIndex);
				_containerUI.removeEventListener(ChildExistenceChangedEvent.CHILD_ADD, updateChildrenCount);
				_containerUI.removeEventListener(ChildExistenceChangedEvent.CHILD_REMOVE, updateChildrenCount);
				
				elements = new Vector.<IVisualElement>();
				for (var i:int = 0; i < _containerUI.numElements; i++)
				{
					var element:IVisualElement = _containerUI.getElementAt(i);
					elements.push(element);
				}
				
				_containerUI.removeAllElements();
				this.removeChild(_containerUI);
				DemoPoolUtil.free(_containerUI);
				_containerUI = null;
			}
			
			return elements;
		}
		
		private var _selectedIndex:int;
		
		[Bindable]
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
				
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		private function updateSelectedIndex(event:Event):void
		{
			this.selectedIndex = this.containerUI.selectedIndex;
		}
		
		private var _numElements:int;
		
		[Bindable]
		public var numElements:int
		
		private function updateChildrenCount(event:Event):void
		{
			this.numElements = this.containerUI.numElements;
		}
	}
}