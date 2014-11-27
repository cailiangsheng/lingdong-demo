package com.lingdong.demo.view.resources
{
	import com.lingdong.demo.model.events.DemoBackgroundEvent;
	import com.lingdong.demo.model.events.DemoFileEvent;
	import com.lingdong.demo.model.pages.DemoElement;
	import com.lingdong.demo.model.resources.DemoBackground;
	import com.lingdong.demo.model.resources.DemoResource;
	
	import flash.events.Event;
	
	import mx.controls.Image;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	import mx.graphics.SolidColor;
	import mx.graphics.Stroke;
	
	public class DemoBackgroundDisplay extends DemoImageDisplay
	{
		override public function get resource():DemoResource
		{
			return this.background;
		}
		
		override public function set resource(value:DemoResource):void
		{
			this.background = value as DemoBackground;
		}
		
		private var _background:DemoBackground;
		
		public function get background():DemoBackground
		{
			return _background;
		}
		
		public function set background(value:DemoBackground):void
		{
			super.image = value;
			
			if (_background != value)
			{
				_background && _background.removeEventListener(DemoBackgroundEvent.COLOR_CHANGE, updateColor);
				
				_background = value;
				
				update();
				
				_background && _background.addEventListener(DemoBackgroundEvent.COLOR_CHANGE, updateColor);
			}
		}
		
		public function DemoBackgroundDisplay()
		{
		}
		
		override protected function update(event:Event=null):void
		{
			super.update(event);
			
			if (this.background)
			{
				updateColor();
			}
		}
		
		override public function set hasBorder(value:Boolean):void
		{
			super.hasBorder = true;
		}
		
		private function updateColor(event:Event = null):void
		{
			if (!this.stage) return;
			
			this.setStyle("borderVisible", true);
			this.setStyle("borderColor", 0x000000);
			this.setStyle("backgroundAlpha", 1);
			this.setStyle("backgroundColor", this.background.color);
		}
	}
}