package com.lingdong.demo.view.pages
{
	import com.lingdong.demo.util.DemoPoolUtil;
	import com.lingdong.demo.view.containers.IDemoContainer;
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
		
		override protected function getContainer(showStyle:String):IDemoContainer
		{
			return DemoPoolUtil.alloc(TileContainer);
		}
	}
}