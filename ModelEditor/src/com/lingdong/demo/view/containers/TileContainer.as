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
	
	import spark.components.HGroup;
	
	public class TileContainer extends HBox
	{
		public function TileContainer(gap:int = 10)
		{
			this.percentHeight = 100;
			this.percentWidth = 100;
			
			this.horizontalScrollPolicy = ScrollPolicy.AUTO;
			this.verticalScrollPolicy = ScrollPolicy.AUTO;
			
			this.setStyle("paddingLeft", gap);
			this.setStyle("paddingRight", gap);
			this.setStyle("horizontalGap", gap);
		}
		
		override public function validateDisplayList():void
		{
			super.validateDisplayList();
			
			var viewportHeight:Number = this.height;
			
			viewportHeight -= this.horizontalScrollBar ? this.horizontalScrollBar.height : 0;
			
			for (var i:int = 0, n:int = this.numChildren; i < n; i++)
			{
				var child:DisplayObject = this.getChildAt(i);
				child.y = viewportHeight / 2 - child.height / 2;
			}
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
//			this.selectedIndex = this.getElementIndex(event.currentTarget as IVisualElement);
		}
	}
}