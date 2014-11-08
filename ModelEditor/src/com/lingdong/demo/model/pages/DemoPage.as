package com.lingdong.demo.model.pages
{
	import com.lingdong.demo.model.IDemoConfig;
	import com.lingdong.demo.model.events.DemoPageEvent;
	import com.lingdong.demo.model.resources.DemoBackground;
	import com.lingdong.demo.model.resources.DemoImage;
	import com.lingdong.demo.model.resources.DemoResource;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	[Event(name="backgroundChange", type="com.lingdong.demo.model.events.DemoPageEvent")]
	[Event(name="thumbnailChange", type="com.lingdong.demo.model.events.DemoPageEvent")]
	[Event(name="elementsChange", type="com.lingdong.demo.model.events.DemoPageEvent")]
	[Event(name="childChange", type="com.lingdong.demo.model.events.DemoPageEvent")]
	public class DemoPage extends EventDispatcher implements IDemoConfig
	{
		public var id:String;
		public var index:uint;
		
		private var _background:DemoBackground;
		
		public function get background():DemoBackground
		{
			return _background;
		}
		
		public function set background(value:DemoBackground):void
		{
			if (_background != value)
			{
				_background = value;
				
				this.dispatchEvent(new DemoPageEvent(DemoPageEvent.BACKGROUND_CHANGE));
			}
		}
		
		private var _thumbnail:DemoBackground;
		
		public function get thumbnail():DemoBackground
		{
			return _thumbnail;
		}
		
		public function set thumbnail(value:DemoBackground):void
		{
			if (_thumbnail != value)
			{
				_thumbnail = value;
				
				this.dispatchEvent(new DemoPageEvent(DemoPageEvent.THUMBNAIL_CHANGE));
			}
		}
		
		private var _elements:Vector.<DemoElement>;
		
		public function get elements():Vector.<DemoElement>
		{
			return _elements;
		}
		
		public function set elements(value:Vector.<DemoElement>):void
		{
			if (_elements != value)
			{
				_elements = value;
				
				this.dispatchEvent(new DemoPageEvent(DemoPageEvent.ELEMENTS_CHANGE));
			}
		}
		
		private var _child:DemoTheme;
		
		public function get child():DemoTheme
		{
			return _child;
		}
		
		public function set child(value:DemoTheme):void
		{
			if (_child != value)
			{
				_child = value;
				
				this.dispatchEvent(new DemoPageEvent(DemoPageEvent.CHILD_CHANGE));
			}
		}
		
		public function DemoPage()
		{
			background = new DemoBackground();
			thumbnail = new DemoBackground();
			elements = new Vector.<DemoElement>();
		}
		
		public function readConfig(config:Object):void
		{
			if (config)
			{
				this.id = config.id;
				this.index = config.index;
				
				this.background.readConfig(config.background);
				this.thumbnail.readConfig(config.thumbnail);
				
				if (config.child)
				{
					var childConfig:Object = JSON.parse(config.child);
					this.child = new DemoTheme();
					this.child.readConfig(childConfig);
				}
				
				for each (var elementConfig:Object in config.elements)
				{
					var resource:DemoResource = DemoResource.getResource(elementConfig.type);
					if (resource)
					{
						var element:DemoElement = new DemoElement(resource);
						if (element)
						{
							element.readConfig(elementConfig);
							
							this.elements.push(element);
						}
					}
				}
				
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}
	}
}