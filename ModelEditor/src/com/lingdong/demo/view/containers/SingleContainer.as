package com.lingdong.demo.view.containers
{
	import flash.display.DisplayObject;
	
	import mx.containers.ViewStack;
	
	public class SingleContainer extends ViewStack implements IDemoContainer
	{
		public function SingleContainer()
		{
			super();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if (selectedIndex != -1)
			{
				var selectedChild:DisplayObject = this.getChildAt(selectedIndex);
				selectedChild.x = unscaledWidth / 2 - selectedChild.width / 2;
				selectedChild.y = unscaledHeight / 2 - selectedChild.height / 2;
				selectedChild.visible = true;
			}
		}
	}
}