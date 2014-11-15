package com.lingdong.demo.view.containers
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.containers.HBox;
	import mx.containers.ViewStack;
	import mx.core.Container;
	import mx.core.IVisualElement;
	import mx.core.ScrollPolicy;
	import mx.events.IndexChangedEvent;
	
	import spark.components.HGroup;
	
	public class TileContainer extends HBox implements IDemoContainer
	{
		private var focusColor:uint;
		
		public function TileContainer(gap:int = 10, focusColor:uint = 0x00ffff)
		{
			this.percentHeight = 100;
			this.percentWidth = 100;
			
			this.horizontalScrollPolicy = ScrollPolicy.AUTO;
			this.verticalScrollPolicy = ScrollPolicy.AUTO;
			
			this.setStyle("paddingLeft", gap);
			this.setStyle("paddingRight", gap);
			this.setStyle("horizontalGap", gap);
			
			this.focusColor = focusColor;
		}
		
		override public function validateDisplayList():void
		{
			super.validateDisplayList();
			
			layoutChildren();
			
			drawSelectedChild();
		}
		
		private function layoutChildren():void
		{
			var viewportHeight:Number = this.height;
			
			viewportHeight -= this.horizontalScrollBar ? this.horizontalScrollBar.height : 0;
			
			for (var i:int = 0, n:int = this.numChildren; i < n; i++)
			{
				var child:DisplayObject = this.getChildAt(i);
				child.y = viewportHeight / 2 - child.height / 2;
			}
		}
		
		private function drawSelectedChild():void
		{
			this.graphics.clear();
			
			if (this.selectedIndex >= 0)
			{
				var focusWeight:int = 2;
				var selectedChild:DisplayObject = this.getChildAt(this.selectedIndex);
				this.graphics.beginFill(this.focusColor);
				this.graphics.drawRect(
					selectedChild.x - focusWeight, 
					selectedChild.y - focusWeight, 
					selectedChild.width + focusWeight * 2,
					selectedChild.height + focusWeight * 2
				);
			}
		}
		
		private function validateSelectedIndex():void
		{
			if (this.selectedIndex >= 0)
			{
				if (this.numElements == 0)
				{
					this.selectedIndex = -1;
				}
			}
			else
			{
				if (this.numElements > 0)
				{
					this.selectedIndex = 0;
				}
			}
		}
		
		override public function addElement(element:IVisualElement):IVisualElement
		{
			element.addEventListener(MouseEvent.CLICK, onClickElement);
			
			var result:IVisualElement = super.addElement(element);
			
			validateSelectedIndex();
			
			return result;
		}
		
		override public function removeElement(element:IVisualElement):IVisualElement
		{
			element.removeEventListener(MouseEvent.CLICK, onClickElement);
			
			var result:IVisualElement = super.removeElement(element);
			
			validateSelectedIndex();
			
			return result;
		}
		
		private function onClickElement(event:MouseEvent):void
		{
			this.selectedIndex = this.getElementIndex(event.currentTarget as IVisualElement);
		}
		
		private var _selectedIndex:int = -1;
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		public function set selectedIndex(value:int):void
		{
			if (_selectedIndex != value && value < this.numChildren)
			{
				var event:IndexChangedEvent = new IndexChangedEvent(IndexChangedEvent.CHANGE);
				event.oldIndex = _selectedIndex;
				event.newIndex = value;
				event.relatedObject = value >= 0 ? this.getChildAt(value) : null;
				
				_selectedIndex = value;
				
				this.invalidateDisplayList();
				
				this.dispatchEvent(event);
			}
		}
	}
}