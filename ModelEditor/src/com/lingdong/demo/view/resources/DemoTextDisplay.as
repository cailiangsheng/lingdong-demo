package com.lingdong.demo.view.resources
{
	import com.lingdong.demo.model.events.DemoTextEvent;
	import com.lingdong.demo.model.resources.DemoResource;
	import com.lingdong.demo.model.resources.DemoText;
	import com.lingdong.demo.util.DemoPoolUtil;
	
	import flash.events.Event;
	
	import mx.controls.Label;
	import mx.core.UIComponent;

	public class DemoTextDisplay extends DemoResourceDisplay
	{
		override public function get resource():DemoResource
		{
			return this.text;
		}
		
		override public function set resource(value:DemoResource):void
		{
			this.text = value as DemoText;
		}
		
		private var _text:DemoText;
		
		public function get text():DemoText
		{
			return _text;
		}
		
		public function set text(value:DemoText):void
		{
			if (_text != value)
			{
				_text && _text.removeEventListener(DemoTextEvent.COLOR_CHANGE, updateColor);
				_text && _text.removeEventListener(DemoTextEvent.CONTENT_CHANGE, updateContent);
				_text && _text.removeEventListener(DemoTextEvent.FONT_SIZE_CHANGE, updateFontSize);
				_text && _text.removeEventListener(DemoTextEvent.FONT_STYLE_CHANGE, updateFontStyle);
				
				_text = value;
				
				this.stage && update();
				
				_text && _text.addEventListener(DemoTextEvent.COLOR_CHANGE, updateColor);
				_text && _text.addEventListener(DemoTextEvent.CONTENT_CHANGE, updateContent);
				_text && _text.addEventListener(DemoTextEvent.FONT_SIZE_CHANGE, updateFontSize);
				_text && _text.addEventListener(DemoTextEvent.FONT_STYLE_CHANGE, updateFontStyle);
			}
		}
		
		public function DemoTextDisplay()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, update);
		}
		
		private var _textUI:Label;
		
		private function get textUI():Label
		{
			if (!_textUI)
			{
				_textUI = DemoPoolUtil.alloc(Label);
				_textUI.width = this.width;
				_textUI.height = this.height;
				this.addChild(_textUI);
			}
			
			return _textUI;
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			
			this.textUI.width = value;
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			
			this.textUI.height = value;
		}
		
		private function update(event:Event = null):void
		{
			if (text)
			{
				updateColor();
				updateContent();
				updateFontSize();
				updateFontStyle();
			}
			else
			{
				this.dispose();
			}
		}
		
		private function updateColor(event:Event = null):void
		{
			this.textUI.setStyle("color", text.color);
		}
		
		private function updateContent(event:Event = null):void
		{
			this.textUI.text = text.content;
		}
		
		private function updateFontSize(event:Event = null):void
		{
			this.textUI.setStyle("fontSize", text.fontSize);
		}
		
		private function updateFontStyle(event:Event = null):void
		{
			this.textUI.setStyle("fontFamily", text.fontStyle);
		}
		
		private function dispose():void
		{
			if (_textUI)
			{
				_textUI.text = "";
				this.removeChild(_textUI);
				
				DemoPoolUtil.free(_textUI);
				_textUI = null;
			}
		}
	}
}