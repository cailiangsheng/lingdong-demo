package com.lingdong.demo.view.pages
{
	import com.lingdong.demo.util.DemoPoolUtil;

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
	}
}