package com.lingdong.demo.view.pages
{
	import com.lingdong.demo.util.DemoPoolUtil;
	import com.lingdong.demo.view.containers.IDemoContainer;
	import com.lingdong.demo.view.containers.SingleContainer;

	public class DemoThemeDesignDisplay extends DemoThemeDisplay
	{
		public function DemoThemeDesignDisplay()
		{
			super();
		}
		
		override protected function allocPageDisplay():DemoPageDisplay
		{
			return DemoPoolUtil.alloc(DemoPageDesignDisplay);
		}
		
		override protected function allocContainer(showStyle:String):IDemoContainer
		{
			return DemoPoolUtil.alloc(SingleContainer);
		}
	}
}