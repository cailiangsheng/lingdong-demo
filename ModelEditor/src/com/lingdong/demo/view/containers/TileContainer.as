package com.lingdong.demo.view.containers
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.containers.HBox;
	import mx.containers.ViewStack;
	import mx.core.IVisualElement;
	
	import spark.components.HGroup;
	
	public class TileContainer extends HBox
	{
		public function TileContainer()
		{
			this.horizontalScrollPolicy = "off";
			this.verticalScrollPolicy = "off";
//			this.percentHeight = 100;
//			this.percentWidth = 100;
			var gap:int = 10;
			this.setStyle("paddingLeft", gap);
			this.setStyle("paddingRight", gap);
			this.setStyle("horizontalGap", 100);
			this.setStyle("verticalAlign", "middle");
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