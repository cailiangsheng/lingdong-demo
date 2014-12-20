package com.lingdong.demo.view.containers
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
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
			var viewportHeight:Number = getViewportHeight();
			
			for (var i:int = 0, n:int = this.numChildren; i < n; i++)
			{
				var child:DisplayObject = this.getChildAt(i);
				child.y = viewportHeight / 2 - child.height / 2;
			}
		}
		
		private function getViewportWidth():Number
		{
			var viewportWidth:Number = this.width;
			viewportWidth -= this.verticalScrollBar ? this.verticalScrollBar.width : 0;
			
			return viewportWidth;
		}
		
		private function getViewportHeight():Number
		{
			var viewportHeight:Number = this.height;
			viewportHeight -= this.horizontalScrollBar ? this.horizontalScrollBar.height : 0;
			
			return viewportHeight;
		}
		
		private function drawSelectedChild():void
		{
			this.graphics.clear();
			
			if (this.selectedIndex >= 0 && this.selectedIndex < this.numChildren)
			{
				var focusWeight:int = 2;
				var selectedChild:DisplayObject = this.getChildAt(this.selectedIndex);
				
				var focusRect:Rectangle = new Rectangle(
					selectedChild.x - focusWeight - this.horizontalScrollPosition, 
					selectedChild.y - focusWeight - this.verticalScrollPosition, 
					selectedChild.width + focusWeight * 2,
					selectedChild.height + focusWeight * 2);
				
				var viewportRect:Rectangle = new Rectangle(0, 0, getViewportWidth(), getViewportHeight());
				
				var rect:Rectangle = focusRect.intersection(viewportRect);
				
				this.graphics.beginFill(this.focusColor);
				this.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
				this.graphics.endFill();
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
				
				validateDisplayList();
				
				scrollToSelectedChild();
				
				this.dispatchEvent(event);
			}
		}
		
		private function scrollToSelectedChild():void
		{
			if (this.selectedIndex >= 0)
			{
				var viewportWidth:Number = getViewportWidth();
				var viewportHeight:Number = getViewportHeight();
				var selectedChild:DisplayObject = this.getChildAt(this.selectedIndex);
				
				if (selectedChild.x < this.horizontalScrollPosition || 
					selectedChild.x + selectedChild.width > this.horizontalScrollPosition + viewportWidth)
				{
					this.horizontalScrollPosition = selectedChild.x + selectedChild.width / 2 - viewportWidth / 2;
				}
				
				if (selectedChild.y < this.verticalScrollPosition ||
					selectedChild.y + selectedChild.height > this.verticalScrollPosition + viewportHeight)
				{
					this.verticalScrollPosition = selectedChild.y + selectedChild.height / 2 - viewportHeight / 2;
				}
			}
		}
	}
}