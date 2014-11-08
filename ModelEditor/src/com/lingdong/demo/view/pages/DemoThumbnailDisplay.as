package com.lingdong.demo.view.pages
{
	import com.lingdong.demo.model.DemoModel;
	import com.lingdong.demo.model.events.DemoImageEvent;
	import com.lingdong.demo.model.events.DemoPageEvent;
	import com.lingdong.demo.model.pages.DemoPage;
	import com.lingdong.demo.model.resources.DemoBackground;
	import com.lingdong.demo.model.resources.DemoImage;
	import com.lingdong.demo.model.traits.DemoPageSize;
	import com.lingdong.demo.util.DemoPoolUtil;
	import com.lingdong.demo.view.resources.DemoBackgroundDisplay;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	import mx.core.FlexBitmap;
	import mx.core.UIComponent;
	
	public class DemoThumbnailDisplay extends UIComponent
	{
		private var _thumbnail:DemoBackground;
		
		public function get thumbnail():DemoBackground
		{
			return _thumbnail;
		}
		
		public function set thumbnail(value:DemoBackground):void
		{
			if (_thumbnail != value)
			{
				this.dispose();
				
				_thumbnail = value;
				
				this.stage && update();
			}
		}
		
		private function update(event:Event = null):void
		{
			if (thumbnail)
			{
				this.backgroundUI.background = thumbnail;
			}
		}
		
		private var _backgroundUI:DemoBackgroundDisplay;
		
		private function get backgroundUI():DemoBackgroundDisplay
		{
			if (!_backgroundUI)
			{
				_backgroundUI = new DemoBackgroundDisplay();
				this.addChild(_backgroundUI);
			}
			
			return _backgroundUI;
		}
		
		private function dispose():void
		{
			if (_backgroundUI)
			{
				_backgroundUI.background = null;
				DemoPoolUtil.free(_backgroundUI);
				_backgroundUI = null;
			}
		}
			
		public function DemoThumbnailDisplay()
		{
			var thumbnailSize:Point = DemoModel.instance.pageSize.thumbnailSize;
			this.width = thumbnailSize.x;
			this.height = thumbnailSize.y;
			
			this.addEventListener(Event.ADDED_TO_STAGE, update);
		}
	}
}