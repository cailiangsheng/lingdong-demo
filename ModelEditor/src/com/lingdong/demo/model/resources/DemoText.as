package com.lingdong.demo.model.resources
{
	import com.lingdong.demo.model.IDemoConfig;
	import com.lingdong.demo.model.events.DemoTextEvent;
	
	import flash.text.Font;
	
	import flashx.textLayout.formats.TextAlign;
	import flashx.textLayout.formats.VerticalAlign;
	
	import mx.collections.ArrayCollection;

	[Event(name="contentChange", type="com.lingdong.demo.model.events.DemoTextEvent")]
	[Event(name="colorChange", type="com.lingdong.demo.model.events.DemoTextEvent")]
	[Event(name="fontSizeChange", type="com.lingdong.demo.model.events.DemoTextEvent")]
	[Event(name="fontStyleChange", type="com.lingdong.demo.model.events.DemoTextEvent")]
	[Event(name="textAlignChange", type="com.lingdong.demo.model.events.DemoTextEvent")]
	[Event(name="verticalAlignChange", type="com.lingdong.demo.model.events.DemoTextEvent")]
	public class DemoText extends DemoResource implements IDemoConfig
	{
		private var _content:String = "";
		
		public function get content():String
		{
			return _content;
		}
		
		public function set content(value:String):void
		{
			if (_content != value)
			{
				_content = value;
				
				this.dispatchTextEvent(DemoTextEvent.CONTENT_CHANGE);
			}
		}
		
		private var _color:uint;
		
		public function get color():uint
		{
			return _color;
		}
		
		public function set color(value:uint):void
		{
			if (_color != value)
			{
				_color = value;
				
				this.dispatchTextEvent(DemoTextEvent.COLOR_CHANGE);
			}
		}
		
		private var _fontSize:Number;
		
		public function get fontSize():Number
		{
			return _fontSize;
		}
		
		public function set fontSize(value:Number):void
		{
			if (_fontSize != value)
			{
				_fontSize = value;
				
				this.dispatchTextEvent(DemoTextEvent.FONT_SIZE_CHANGE);
			}
		}
		
		private var _fontStyle:String;
		
		public function get fontStyle():String
		{
			return _fontStyle;
		}
		
		public function set fontStyle(value:String):void
		{
			if (_fontStyle != value)
			{
				_fontStyle = value;
				
				this.dispatchTextEvent(DemoTextEvent.FONT_STYLE_CHANGE);
			}
		}
		
		private var _textAlign:String;
		
		public function get textAlign():String
		{
			return _textAlign;
		}
		
		public function set textAlign(value:String):void
		{
			if (_textAlign != value)
			{
				_textAlign = value;
				
				this.dispatchTextEvent(DemoTextEvent.TEXT_ALIGN_CHANGE);
			}
		}
		
		private var _verticalAlign:String;
		
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}
		
		public function set verticalAlign(value:String):void
		{
			if (_verticalAlign != value)
			{
				_verticalAlign = value;
				
				this.dispatchTextEvent(DemoTextEvent.VERTICAL_ALIGN_CHANGE);
			}
		}
		
		private function dispatchTextEvent(type:String):void
		{
			this.dispatchEvent(new DemoTextEvent(type));
		}
		
		override public function get type():String
		{
			return TEXT;
		}
		
		override public function get isValid():Boolean
		{
			return Boolean(this.content);
		}
		
		public function DemoText()
		{
		}
		
		override public function readConfig(config:Object):void
		{
			if (config)
			{
				this.color = config.color;
				this.content = config.content;
				this.fontSize = config.fontSize;
				this.fontStyle = config.fontStyle;
				this.textAlign = config.textAlign;
				this.verticalAlign = config.verticalAlign;
			}
		}
		
		override public function writeConfig(config:Object, fileIds:Array):void
		{
			if (config)
			{
				config.color = this.color;
				config.content = this.content;
				config.fontSize = this.fontSize;
				config.fontStyle = this.fontStyle;
				
				if (this.textAlign)
				{
					config.textAlign = this.textAlign;
				}
				
				if (this.verticalAlign)
				{
					config.verticalAlign = this.verticalAlign;
				}
			}
		}
		
		override public function compareResource(resource:DemoResource):Boolean
		{
			var text:DemoText = resource as DemoText;
			return text && this.fontStyle == text.fontStyle;
		}
		
		override public function clone():DemoResource
		{
			var text:DemoText = new DemoText();
			text.color = this.color;
			text.content = this.content;
			text.fontSize = this.fontSize;
			text.fontStyle = this.fontStyle;
			text.textAlign = this.textAlign;
			text.verticalAlign = this.verticalAlign;
			return text;
		}
	}
}