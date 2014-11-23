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
				
				this.dispose();
				
				_background = value;
				
				this.stage && update();
				
				_background && _background.addEventListener(DemoBackgroundEvent.COLOR_CHANGE, updateColor);
			}
		}
		
		public function DemoBackgroundDisplay()
		{
		}
		
		override protected function updateSize(event:ResizeEvent=null):void
		{
			super.updateSize(event);
			
			updateColor();
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			
			updateColor();
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			
			updateColor();
		}
		
		private function updateColor(event:Event = null):void
		{
			var lineWeight:int = 1;
			this.graphics.clear();
			this.graphics.lineStyle(lineWeight, 0x000000);
			this.graphics.beginFill(this.background.color);
			this.graphics.drawRect(lineWeight / 2, lineWeight / 2, this.width - lineWeight, this.height - lineWeight);
			this.graphics.endFill();
		}
		
		private function dispose():void
		{
			this.graphics.clear();
		}
	}
}