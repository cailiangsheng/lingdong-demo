package com.lingdong.demo.view.pages
{
	import com.lingdong.demo.view.containers.TileContainer;
	
	import mx.containers.ViewStack;
	import mx.core.ScrollPolicy;

	public class DemoThumbnailDisplay extends DemoThemeDisplay
	{
		public function DemoThumbnailDisplay()
		{
			this.horizontalScrollPolicy = ScrollPolicy.AUTO;
			this.verticalScrollPolicy = ScrollPolicy.AUTO;
		}
		
		override protected function getContainer(showStyle:String):ViewStack
		{
			return new TileContainer();
		}
	}
}