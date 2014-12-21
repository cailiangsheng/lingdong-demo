package com.lingdong.demo.model.resources
{
	import com.lingdong.demo.model.IDemoConfig;
	import com.lingdong.demo.model.events.DemoBackgroundEvent;
	
	import mx.collections.ArrayCollection;

	[Event(name="colorChange", type="com.lingdong.demo.model.events.DemoBackgroundEvent")]
	[Event(name="commentChange", type="com.lingdong.demo.model.events.DemoBackgroundEvent")]
	public class DemoBackground extends DemoImage implements IDemoConfig
	{
		public static const DEFAULT_COLOR:uint = 0xffffff;
		
		public function get isDefault():Boolean
		{
			return !this.url && this.color == DEFAULT_COLOR;
		}
		
		private var _color:uint = DEFAULT_COLOR;
		
		public function get color():uint
		{
			return _color;
		}
		
		public function set color(value:uint):void
		{
			if (_color != value)
			{
				_color = value;
				
				this.dispatchEvent(new DemoBackgroundEvent(DemoBackgroundEvent.COLOR_CHANGE));
			}
		}
		
		private var _comment:String = "";
		
		public function get comment():String
		{
			return _comment;
		}
		
		public function set comment(value:String):void
		{
			if (_comment != value)
			{
				_comment = value;
				
				this.dispatchEvent(new DemoBackgroundEvent(DemoBackgroundEvent.COMMENT_CHANGE));
			}
		}
		
		override public function get type():String
		{
			return BACKGROUND;
		}
		
		public function DemoBackground()
		{
		}
		
		override public function clone():DemoResource
		{
			var background:DemoBackground = new DemoBackground();
			background.color = this.color;
			background.fileId = this.fileId;
			background.url = this.url;
			return background;
		}
		
		override public function readConfig(config:Object):void
		{
			super.readConfig(config);
			
			if (config)
			{
				if (config.hasOwnProperty("color"))
				{
					this.color = config.color;
				}
				
				if (config.comment)
				{
					this.comment = config.comment;
				}
			}
		}
		
		override public function writeConfig(config:Object, fileIds:Array):void
		{
			super.writeConfig(config, fileIds);
			
			if (config)
			{
				if (this.color != DEFAULT_COLOR)
				{
					config.color = this.color;
				}
				
				if (this.comment)
				{
					config.comment = this.comment;
				}
			}
		}
		
		override public function compareResource(resource:DemoResource):Boolean
		{
			var background:DemoBackground = resource as DemoBackground;
			return super.compareResource(resource) && background && this.color == background.color;
		}
	}
}