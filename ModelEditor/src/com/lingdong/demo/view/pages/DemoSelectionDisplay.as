package com.lingdong.demo.view.pages
{
	import flash.events.Event;
	
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	
	public class DemoSelectionDisplay extends UIComponent
	{
		private var _selected:Boolean;
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if (_selected != value)
			{
				this.dispose();
				
				_selected = value;
				
				this.stage && update();
			}
		}
		
		protected function get selectionTarget():IVisualElement
		{
			return null;
		}
		
		public function DemoSelectionDisplay()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, update);
		}
		
		private function update(event:Event = null):void
		{
			this.graphics.clear();
			
			if (this.selectionTarget && this.selected)
			{
				var borderWeight:int = 2;
				this.graphics.beginFill(0x00ffff);
				this.graphics.drawRect(
					this.selectionTarget.x - borderWeight, 
					this.selectionTarget.y - borderWeight, 
					this.selectionTarget.width + borderWeight * 2, 
					this.selectionTarget.height + borderWeight * 2);
				this.graphics.endFill();
			}
		}
		
		private function dispose():void
		{
			this.graphics.clear();
		}
	}
}