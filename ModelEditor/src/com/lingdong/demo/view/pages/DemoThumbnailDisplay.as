package com.lingdong.demo.view.pages
{
	import com.lingdong.demo.util.DemoPoolUtil;
	import com.lingdong.demo.view.containers.IDemoContainer;
	import com.lingdong.demo.view.containers.TileContainer;
	
	import flash.events.Event;
	
	import mx.containers.ViewStack;
	import mx.core.Container;
	import mx.core.IVisualElement;
	import mx.events.ChildExistenceChangedEvent;
	import mx.events.ResizeEvent;

	public class DemoThumbnailDisplay extends DemoThemeDisplay
	{
		public function DemoThumbnailDisplay()
		{
		}
		
		override protected function getContainer(showStyle:String):IDemoContainer
		{
			var container:TileContainer = DemoPoolUtil.alloc(TileContainer);
			container.addEventListener(ChildExistenceChangedEvent.CHILD_ADD, onAddChild);
			container.addEventListener(ChildExistenceChangedEvent.CHILD_REMOVE, onRemoveChild);
			return container;
		}
		
		private function onAddChild(event:ChildExistenceChangedEvent):void
		{
			DemoPageDisplay(event.relatedObject).mouseChildren = false;
		}
		
		private function onRemoveChild(event:ChildExistenceChangedEvent):void
		{
			DemoPageDisplay(event.relatedObject).mouseChildren = true;
		}
		
		override protected function disposeContainer():Vector.<IVisualElement>
		{
			if (_containerUI)
			{
				_containerUI.removeEventListener(ChildExistenceChangedEvent.CHILD_ADD, onAddChild);
				_containerUI.removeEventListener(ChildExistenceChangedEvent.CHILD_REMOVE, onRemoveChild);
				
				var pages:Vector.<DemoPageDisplay> = super.getPages();
				for each (var page:DemoPageDisplay in pages)
				{
					page.mouseChildren = true;
				}
			}
			
			return super.disposeContainer();
		}
	}
}