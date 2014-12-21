package com.lingdong.demo.view.pages
{
	import com.greensock.events.TransformEvent;
	import com.greensock.transform.TransformItem;
	import com.greensock.transform.TransformManager;
	import com.lingdong.demo.model.DemoModel;
	import com.lingdong.demo.model.events.DemoElementsEvent;
	import com.lingdong.demo.model.events.DemoPageEvent;
	import com.lingdong.demo.model.pages.DemoElement;
	import com.lingdong.demo.model.pages.DemoPage;
	import com.lingdong.demo.model.resources.DemoBackground;
	import com.lingdong.demo.model.resources.DemoResource;
	import com.lingdong.demo.util.DemoPoolUtil;
	import com.lingdong.demo.view.resources.DemoComponentDisplay;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.managers.DragManager;
	
	import spark.components.Button;

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
				_transformManager.autoDeselect = false;
				_transformManager.addEventListener(TransformEvent.MOVE, onTransform);
				_transformManager.addEventListener(TransformEvent.ROTATE, onTransform);
				_transformManager.addEventListener(TransformEvent.SCALE, onTransform);
				_transformManager.addEventListener(TransformEvent.DELETE, onDelete);
				_transformManager.addEventListener(TransformEvent.SELECTION_CHANGE, onSelectionChange);
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
				this.removeElementDisplay(elementDisplay);
			}
		}
		
		private function onSelectionChange(event:TransformEvent):void
		{
			var selectedTargetObjects:Array = this.transformManager.selectedTargetObjects;
			if (selectedTargetObjects && selectedTargetObjects.length > 0)
			{
				var elementDisplay:DemoElementDisplay = selectedTargetObjects[0] as DemoElementDisplay;
				DemoModel.instance.designer.activeElement = elementDisplay.element;
			}
			else
			{
				DemoModel.instance.designer.activeElement = null;
			}
		}
		
		public function DemoPageDesignDisplay()
		{
			this.addEventListener(DragEvent.DRAG_ENTER, onDragEnter);
			this.addEventListener(DragEvent.DRAG_DROP, onDragDrop);
			this.addEventListener(FlexEvent.HIDE, deselectAllElements);
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
			var resource:DemoResource = component.resource.clone();
			var background:DemoBackground = resource as DemoBackground;
			if (background)
			{
				this.page.background = background;
			}
			else
			{
				var element:DemoElement = new DemoElement(resource);
				element.width = component.contentWidth / this.width;
				element.height = component.contentHeight / this.height;
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
		
		override protected function addBackground():void
		{
			super.addBackground();
			
			super.backgroundUI.addEventListener(MouseEvent.CLICK, deselectAllElements);
		}
		
		override protected function removeBackground():void
		{
			super.backgroundUI.removeEventListener(MouseEvent.CLICK, deselectAllElements);
			
			super.removeBackground();
		}
		
		private function deselectAllElements(event:Event = null):void
		{
			this.transformManager.deselectAll();
		}
		
		override public function set page(value:DemoPage):void
		{
			if (super.page != value)
			{
				if (super.page)
				{
					super.page.removeEventListener(DemoPageEvent.CHILD_CHANGE, updateChild);
				}
				
				this.dispose();
				
				super.page = value;
				
				updateChild();
				
				if (super.page)
				{
					super.page.addEventListener(DemoPageEvent.CHILD_CHANGE, updateChild);
				}
			}
		}
		
		override protected function update(event:Event=null):void
		{
			super.update(event);
			
			updateChild(event);
		}
		
		private function updateChild(event:Event = null):void
		{
			if (this.page && !this.page.isChildPage)
			{
				this.buttonUI.label = "详情" + (this.page.child && this.page.child.pages.numPages > 0 ? ">>" : "+");
				this.setChildIndex(this.buttonUI, this.numChildren - 1);
			}
		}
		
		override protected function updateSize(event:Event=null):void
		{
			super.updateSize(event);
			
			transformManager.updateSelection();
			
			if (this.page && !this.page.isChildPage)
			{
				this.buttonUI.width = 80;
				this.buttonUI.height = 30;
				this.buttonUI.x = this.width - this.buttonUI.width - 20;
				this.buttonUI.y = this.height - this.buttonUI.height - 20;
			}
		}
		
		private var _buttonUI:Button;
		
		private function get buttonUI():Button
		{
			if (!_buttonUI)
			{
				_buttonUI = DemoPoolUtil.alloc(Button);
				_buttonUI.addEventListener(MouseEvent.CLICK, onButtonClick);
				this.addChild(_buttonUI);
			}
			
			return _buttonUI;
		}
		
		private function onButtonClick(event:MouseEvent):void
		{
			DemoModel.instance.designer.activateChild(this.page);
		}
		
		override protected function dispose():void
		{
			super.dispose();
			
			if (_buttonUI)
			{
				_buttonUI.removeEventListener(MouseEvent.CLICK, onButtonClick);
				this.removeChild(_buttonUI);
				DemoPoolUtil.free(_buttonUI);
				_buttonUI = null;
			}
		}
	}
}