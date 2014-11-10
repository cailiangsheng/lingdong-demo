package com.lingdong.demo.view.pages
{
	import com.lingdong.demo.util.DemoPoolUtil;
	import com.lingdong.demo.view.containers.TileContainer;
	
	import mx.containers.ViewStack;

	public class DemoThumbnailDisplay extends DemoThemeDisplay
	{
		public function DemoThumbnailDisplay()
		{
		}
		
		override protected function getContainer(showStyle:String):ViewStack
		{
			return DemoPoolUtil.alloc(TileContainer);
		}
	}
}