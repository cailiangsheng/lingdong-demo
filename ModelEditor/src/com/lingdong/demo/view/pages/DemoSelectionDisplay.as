package com.lingdong.demo.view.pages
{
	import com.lingdong.demo.util.DemoPoolUtil;
	
	import flash.events.Event;
	
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	
	public class DemoSelectionDisplay extends UIComponent
	{
		private var _selected:Boolean;
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if (_selected != value)
			{
				this.dispose();
				
				_selected = value;
				
				this.stage && update();
			}
		}
		
		protected function get selectionTarget():IVisualElement
		{
			return null;
		}
		
		public function DemoSelectionDisplay()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, update);
		}
		
		private var _controllerUI:SelectionController;
		
		private function get controllerUI():SelectionController
		{
			if (!_controllerUI)
			{
				_controllerUI = DemoPoolUtil.alloc(SelectionController);
				this.addChild(_controllerUI);
			}
			
			this.setChildIndex(_controllerUI, this.numChildren - 1);
			return _controllerUI;
		}
		
		private function update(event:Event = null):void
		{
			this.controllerUI.clear();
			
			if (this.selectionTarget && this.selected)
			{
				this.controllerUI.draw(this.selectionTarget);
			}
		}
		
		private function dispose():void
		{
			if (_controllerUI)
			{
				_controllerUI.clear();
				this.removeChild(_controllerUI);
				
				DemoPoolUtil.free(_controllerUI);
				_controllerUI = null;
			}
		}
	}
}

import mx.core.IVisualElement;
import mx.core.UIComponent;

class SelectionController extends UIComponent
{
	public function SelectionController()
	{
		this.percentWidth = 100;
		this.percentHeight = 100;
		this.buttonMode = true;
	}
	
	public function clear():void
	{
		this.graphics.clear();
	}
	
	public function draw(target:IVisualElement, borderWeight:int = 2, borderColor:uint = 0xff0000):void
	{
		this.graphics.lineStyle(borderWeight, borderColor);
		this.graphics.drawRect(
			target.x - borderWeight / 2, 
			target.y - borderWeight / 2, 
			target.width + borderWeight, 
			target.height + borderWeight);
	}
}