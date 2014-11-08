package com.lingdong.demo.view.resources
{
	import com.lingdong.demo.model.resources.DemoButton;
	import com.lingdong.demo.model.resources.DemoResource;

	public class DemoButtonDisplay extends DemoImageDisplay
	{
		override public function get resource():DemoResource
		{
			return this.button;
		}
		
		override public function set resource(value:DemoResource):void
		{
			this.button = value as DemoButton;
		}
		
		private var _button:DemoButton;
		
		public function get button():DemoButton
		{
			return _button;
		}
		
		public function set button(value:DemoButton):void
		{
			super.image = value;
			
			_button = value;
		}
		
		public function DemoButtonDisplay()
		{
		}
	}
}