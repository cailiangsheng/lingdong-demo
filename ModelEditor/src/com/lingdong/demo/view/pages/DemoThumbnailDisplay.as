package com.lingdong.demo.view.pages
{
	import com.lingdong.demo.util.DemoPoolUtil;
	import com.lingdong.demo.view.containers.TileContainer;
	
	import flash.events.Event;
	
	import mx.containers.ViewStack;
	import mx.core.Container;
	import mx.core.IVisualElement;
	import mx.events.ResizeEvent;

	public class DemoThumbnailDisplay extends DemoThemeDisplay
	{
		public function DemoThumbnailDisplay()
		{
		}
		
		override protected function getContainer(showStyle:String):Container
		{
			var container:TileContainer = DemoPoolUtil.alloc(TileContainer);
			container.addEventListener(ResizeEvent.RESIZE, onContainerResize);
			return container;
		}
		
		private function onContainerResize(event:Event):void
		{
			var container:TileContainer = event.currentTarget as TileContainer;
			this.width = container.width;
			this.height = container.height;
		}
		
		override protected function dispose():Vector.<IVisualElement>
		{
			if (super._containerUI)
			{
				_containerUI.removeEventListener(ResizeEvent.RESIZE, onContainerResize);
			}
			
			return super.dispose();
		}
	}
}