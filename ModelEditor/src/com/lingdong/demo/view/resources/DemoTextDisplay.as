package com.lingdong.demo.view.resources
{
	import com.lingdong.demo.model.events.DemoTextEvent;
	import com.lingdong.demo.model.resources.DemoResource;
	import com.lingdong.demo.model.resources.DemoText;
	import com.lingdong.demo.util.DemoPoolUtil;
	
	import flash.events.Event;
	
	import mx.core.UIComponent;
	
	import spark.components.Label;

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
				_text && _text.removeEventListener(DemoTextEvent.TEXT_ALIGN_CHANGE, updateTextAlign);
				_text && _text.removeEventListener(DemoTextEvent.VERTICAL_ALIGN_CHANGE, updateVerticalAlign);
				
				this.dispose();
				
				_text = value;
				
				update();
				
				_text && _text.addEventListener(DemoTextEvent.COLOR_CHANGE, updateColor);
				_text && _text.addEventListener(DemoTextEvent.CONTENT_CHANGE, updateContent);
				_text && _text.addEventListener(DemoTextEvent.FONT_SIZE_CHANGE, updateFontSize);
				_text && _text.addEventListener(DemoTextEvent.FONT_STYLE_CHANGE, updateFontStyle);
				_text && _text.addEventListener(DemoTextEvent.TEXT_ALIGN_CHANGE, updateTextAlign);
				_text && _text.addEventListener(DemoTextEvent.VERTICAL_ALIGN_CHANGE, updateVerticalAlign);
			}
		}
		
		public function DemoTextDisplay()
		{
		}
		
		private var _textUI:Label;
		
		private function get textUI():Label
		{
			if (!_textUI)
			{
				_textUI = DemoPoolUtil.alloc(Label);
				_textUI.percentWidth = 100;
				_textUI.percentHeight = 100;
				this.addElement(_textUI);
			}
			
			return _textUI;
		}
		
		override protected function updateMaintainAspectRatio():void
		{
			
		}
		
		override protected function update(event:Event = null):void
		{
			super.update(event);
			
			if (text)
			{
				updateColor();
				updateContent();
				updateFontSize();
				updateFontStyle();
				updateTextAlign();
				updateVerticalAlign();
			}
		}
		
		private function updateColor(event:Event = null):void
		{
			if (!this.stage) return;
			
			this.textUI.setStyle("color", text.color);
		}
		
		private function updateContent(event:Event = null):void
		{
			if (!this.stage) return;
			
			this.textUI.text = text.content;
		}
		
		private function updateFontSize(event:Event = null):void
		{
			if (!this.stage) return;
			
			this.textUI.setStyle("fontSize", text.fontSize);
		}
		
		private function updateFontStyle(event:Event = null):void
		{
			if (!this.stage) return;
			
			this.textUI.setStyle("fontFamily", text.fontStyle);
		}
		
		private function updateTextAlign(event:Event = null):void
		{
			if (!this.stage) return;
			
			this.textUI.setStyle("textAlign", text.textAlign);
		}
		
		private function updateVerticalAlign(event:Event = null):void
		{
			if (!this.stage) return;
			
			this.textUI.setStyle("verticalAlign", text.verticalAlign);
		}
		
		private function dispose():void
		{
			if (_textUI)
			{
				_textUI.text = "";
				this.removeElement(_textUI);
				
				DemoPoolUtil.free(_textUI);
				_textUI = null;
			}
		}
	}
}