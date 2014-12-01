package com.lingdong.demo.model.pages
{
	import com.lingdong.demo.model.IDemoConfig;
	import com.lingdong.demo.model.events.DemoPageEvent;
	import com.lingdong.demo.model.resources.DemoBackground;
	import com.lingdong.demo.model.resources.DemoBitmap;
	import com.lingdong.demo.model.resources.DemoImage;
	import com.lingdong.demo.model.resources.DemoResource;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	[Event(name="backgroundChange", type="com.lingdong.demo.model.events.DemoPageEvent")]
	[Event(name="childChange", type="com.lingdong.demo.model.events.DemoPageEvent")]
	public class DemoPage extends EventDispatcher implements IDemoConfig
	{
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
		
		private var _thumbnail:DemoBitmap;
		
		public function get thumbnail():DemoBitmap
		{
			return _thumbnail;
		}
		
		private var _elements:DemoElements;
		
		public function get elements():DemoElements
		{
			return _elements;
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
			_background = DemoBackground.instance;
			_thumbnail = new DemoBitmap();
			_elements = new DemoElements();
		}
		
		public function readConfig(config:Object):void
		{
			if (config)
			{
				if (config.background)
				{
					this.background = new DemoBackground();
					this.background.readConfig(config.background);
				}
				
				this.thumbnail.readConfig(config.thumbnail);
				
				if (config.child)
				{
					var childConfig:Object = JSON.parse(config.child);
					this.child = new DemoTheme();
					this.child.readConfig(childConfig);
				}
				
				this.elements.removeAllElements();
				for each (var elementConfig:Object in config.elements)
				{
					var resource:DemoResource = DemoResource.getResource(elementConfig.type);
					if (resource)
					{
						var element:DemoElement = new DemoElement(resource);
						if (element)
						{
							element.readConfig(elementConfig);
							
							this.elements.addElement(element);
						}
					}
				}
			}
		}
		
		public function writeConfig(config:Object, fileIds:Array):void
		{
			if (config)
			{
				var backgroundConfig:Object = {};
				config.background = backgroundConfig;
				this.background.writeConfig(backgroundConfig, fileIds);
				
				var thumbnailConfig:Object = {};
				config.thumbnail = thumbnailConfig;
				this.thumbnail.writeConfig(thumbnailConfig, fileIds);
				
				if (this.child)
				{
					var childConfig:Object = {};
					this.child.writeConfig(childConfig, fileIds);
					config.child = JSON.stringify(childConfig);
				}
				
				var elementsConfig:Array = [];
				config.elements = elementsConfig;
				for each (var element:DemoElement in this.elements.source)
				{
					var elementConfig:Object = {};
					elementConfig.type = element.resource.type;
					element.writeConfig(elementConfig, fileIds);
					elementsConfig.push(elementConfig);
				}
			}
		}
	}
}