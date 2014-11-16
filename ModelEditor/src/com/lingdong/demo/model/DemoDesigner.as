package com.lingdong.demo.model
{
	import com.lingdong.demo.model.events.DemoModelEvent;
	import com.lingdong.demo.model.pages.DemoElement;

	[Event(name="activeElementChange", type="com.lingdong.demo.model.events.DemoModelEvent")]
	public class DemoDesigner extends DemoPreviewer
	{
		private var _activeElement:DemoElement;
		
		public function get activeElement():DemoElement
		{
			return _activeElement;
		}
		
		public function set activeElement(value:DemoElement):void
		{
			if (_activeElement != value)
			{
				if (_activeElement) _activeElement.selected = false;
				
				_activeElement = value;
				
				if (_activeElement) _activeElement.selected = true;
				
				this.dispatchEvent(new DemoModelEvent(DemoModelEvent.ACTIVE_ELEMENT_CHANGE));
			}
		}
		
		public function DemoDesigner()
		{
		}
	}
}