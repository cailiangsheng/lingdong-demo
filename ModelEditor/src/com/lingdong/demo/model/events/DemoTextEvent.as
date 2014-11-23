package com.lingdong.demo.model.events
{
	import flash.events.Event;
	
	public class DemoTextEvent extends Event
	{
		public static const CONTENT_CHANGE:String = "contentChange";
		public static const COLOR_CHANGE:String = "colorChange";
		public static const FONT_SIZE_CHANGE:String = "fontSizeChange";
		public static const FONT_STYLE_CHANGE:String = "fontStyleChange";
		public static const TEXT_ALIGN_CHANGE:String = "textAlignChange";
		public static const VERTICAL_ALIGN_CHANGE:String = "verticalAlignChange";
		
		public function DemoTextEvent(type:String)
		{
			super(type);
		}
	}
}