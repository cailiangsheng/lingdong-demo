package com.lingdong.demo.model.pages
{
	import com.lingdong.demo.model.IDemoConfig;
	import com.lingdong.demo.model.events.DemoElementEvent;
	import com.lingdong.demo.model.resources.DemoResource;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	[Event(name="xChange", type="com.lingdong.demo.model.events.DemoElementEvent")]
	[Event(name="yChange", type="com.lingdong.demo.model.events.DemoElementEvent")]
	[Event(name="scaleXChange", type="com.lingdong.demo.model.events.DemoElementEvent")]
	[Event(name="scaleYChange", type="com.lingdong.demo.model.events.DemoElementEvent")]
	[Event(name="widthChange", type="com.lingdong.demo.model.events.DemoElementEvent")]
	[Event(name="heightChange", type="com.lingdong.demo.model.events.DemoElementEvent")]
	[Event(name="rotationChange", type="com.lingdong.demo.model.events.DemoElementEvent")]
	public class DemoElement extends EventDispatcher implements IDemoConfig
	{
		private var _x:Number;
		
		public function get x():Number
		{
			return _x;
		}
		
		public function set x(value:Number):void
		{
			if (_x != value)
			{
				_x = value;
				
				this.dispatchElementEvent(DemoElementEvent.X_CHANGE);
			}
		}
		
		private var _y:Number;
		
		public function get y():Number
		{
			return _y;
		}
		
		public function set y(value:Number):void
		{
			if (_y != value)
			{
				_y = value;
				
				this.dispatchElementEvent(DemoElementEvent.Y_CHANGE);
			}
		}
		private var _scaleX:Number = 1;
		
		public function get scaleX():Number
		{
			return _scaleX;
		}
		
		public function set scaleX(value:Number):void
		{
			if (_scaleX != value)
			{
				_scaleX = value;
				
				this.dispatchElementEvent(DemoElementEvent.SCALE_X_CHANGE);
			}
		}
		
		private var _scaleY:Number = 1;
		
		public function get scaleY():Number
		{
			return _scaleY;
		}
		
		public function set scaleY(value:Number):void
		{
			if (_scaleY != value)
			{
				_scaleY = value;
				
				this.dispatchElementEvent(DemoElementEvent.SCALE_Y_CHANGE);
			}
		}
		
		private var _width:Number;
		
		public function get width():Number
		{
			return _width;
		}
		
		public function set width(value:Number):void
		{
			if (_width != value)
			{
				_width = value;
				
				this.dispatchElementEvent(DemoElementEvent.WIDTH_CHANGE);
			}
		}
		
		private var _height:Number;
		
		public function get height():Number
		{
			return _height;
		}
		
		public function set height(value:Number):void
		{
			if (_height != value)
			{
				_height = value;
				
				this.dispatchElementEvent(DemoElementEvent.HEIGHT_CHANGE);
			}
		}
		
		private var _rotation:Number;
		
		public function get rotation():Number
		{
			return _rotation;
		}
		
		public function set rotation(value:Number):void
		{
			if (_rotation != value)
			{
				_rotation = value;
				
				this.dispatchElementEvent(DemoElementEvent.ROTATION_CHANGE);
			}
		}
		
		private var _resource:DemoResource;
		
		public function get resource():DemoResource
		{
			return _resource;
		}
		
		public function get type():String
		{
			return resource ? resource.type : null;
		}
		
		public function DemoElement(resource:DemoResource)
		{
			_resource = resource;
		}
		
		public function readConfig(config:Object):void
		{
			this.x = config.x;
			this.y = config.y;
			this.width = Math.abs(config.width);
			this.height = Math.abs(config.height);
			this.scaleX = sign(config.width);
			this.scaleY = sign(config.height);
			this.rotation = config.rotation;
			
			this.resource.readConfig(config);
		}
		
		public function writeConfig(config:Object, fileIds:Array):void
		{
			if (config)
			{
				config.x = this.x;
				config.y = this.y;
				config.width = this.width * this.scaleX;
				config.height = this.height * this.scaleY;
				config.rotation = this.rotation;
				
				this.resource.writeConfig(config, fileIds);
			}
		}
		
		private function dispatchElementEvent(name:String):void
		{
			this.dispatchEvent(new DemoElementEvent(name));
		}
	}
}

function sign(value:Number):Number
{
	return value >= 0 ? 1 : -1;
}