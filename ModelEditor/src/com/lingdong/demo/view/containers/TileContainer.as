package com.lingdong.demo.view.containers
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.containers.ViewStack;
	import mx.core.IVisualElement;
	
	public class TileContainer extends ViewStack
	{
		public var gap:uint = 5;
		
		public function TileContainer()
		{
			super();
		}
		
		override public function addElement(element:IVisualElement):IVisualElement
		{
			element.addEventListener(MouseEvent.CLICK, onClickElement);
			
			return super.addElement(element);
		}
		
		override public function removeElement(element:IVisualElement):IVisualElement
		{
			element.removeEventListener(MouseEvent.CLICK, onClickElement);
			
			return super.removeElement(element);
		}
		
		private function onClickElement(event:MouseEvent):void
		{
			this.selectedIndex = this.getElementIndex(event.currentTarget as IVisualElement);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var maxHeight:int = 0;
			var lastX:Number = 0;
			for (var i:int = 0, n:int = this.numChildren; i < n; i++)
			{
				var child:DisplayObject = this.getChildAt(i);
				child.y = gap;
				child.x = lastX + gap;
				child.visible = true;
				lastX = child.x + child.width;
				maxHeight = Math.max(maxHeight, gap * 2 + child.height);
			}
			
			if (selectedIndex != -1)
			{
				var selectedChild:Sprite = this.getChildAt(selectedIndex) as Sprite;
				this.graphics.clear();
				this.graphics.beginFill(0x00ffff);
				this.graphics.drawRect(
					selectedChild.x - 1, 
					selectedChild.y - 1,
					selectedChild.width + 2,
					selectedChild.height + 2);
			}
			
			this.width = lastX + gap;
			this.height = maxHeight;
		}
	}
}