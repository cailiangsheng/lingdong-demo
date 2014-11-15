package com.lingdong.demo.view.containers
{
	import com.dougmccune.containers.CoverFlowContainer;
	
	import flash.events.Event;
	
	public class CoverflowContainer extends CoverFlowContainer implements IDemoContainer
	{
		public function CoverflowContainer()
		{
			super.segments = 6;
			super.reflectionEnabled = true;
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onRemovedFromStage(event:Event):void
		{
			super.maxChildWidth = NaN;
			super.maxChildHeight = NaN;
		}
	}
}