package com.lingdong.demo.model.events
{
	import flash.events.Event;
	
	public class DemoElementEvent extends Event
	{
		public static const SELECTED_CHANGE:String = "selectedChange";
		public static const X_CHANGE:String = "xChange";
		public static const Y_CHANGE:String = "yChange";
		public static const WIDTH_CHANGE:String = "widthChange";
		public static const HEIGHT_CHANGE:String = "heightChange";
		public static const DEPTH_CHANGE:String = "depthChange";
		public static const ROTATION_CHANGE:String = "rotationChange";
		
		public function DemoElementEvent(type:String)
		{
			super(type);
		}
	}
}