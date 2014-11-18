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
				_controllerUI.dispose();
				this.removeChild(_controllerUI);
				
				DemoPoolUtil.free(_controllerUI);
				_controllerUI = null;
			}
		}
	}
}

import com.lingdong.demo.util.DemoPoolUtil;

import flash.display.Sprite;
import flash.events.MouseEvent;

import mx.core.IVisualElement;
import mx.core.UIComponent;

class ControlPoint extends Sprite
{
	public var size:uint;
	public var lineWeight:uint;
	public var lineColor:uint;
	
	public function ControlPoint(size:uint = 4, lineWeight:uint = 1, lineColor:uint = 0xff0000)
	{
		this.size = size;
		this.lineWeight = lineWeight;
		this.lineColor = lineColor;
	}
	
	public function clear():void
	{
		this.graphics.clear();
	}
	
	public function draw():void
	{
		throw new Error("to be override");
	}
}

class SideControlPoint extends ControlPoint
{
	public function SideControlPoint(size:uint = 8, lineWeight:uint = 1, lineColor:uint = 0xff0000)
	{
		super(size, lineWeight, lineColor);
	}
	
	override public function draw():void
	{
		this.graphics.clear();
		this.graphics.lineStyle(lineWeight, lineColor);
		this.graphics.beginFill(0xffffff);
		this.graphics.drawRect(-size / 2, -size / 2, size, size);
		this.graphics.endFill();
	}
}

class DiagControlPoint extends ControlPoint
{
	public function DiagControlPoint(size:uint = 8, lineWeight:uint = 1, lineColor:uint = 0xff0000)
	{
		super(size, lineWeight, lineColor);
	}
	
	override public function draw():void
	{
		this.graphics.clear();
		this.graphics.lineStyle(lineWeight, lineColor);
		this.graphics.beginFill(0xffffff);
		this.graphics.drawCircle(0, 0, size / 2);
		this.graphics.endFill();
	}
}

class ControlFrame extends UIComponent
{
	public var lineWeight:uint = 1;
	public var lineColor:uint = 0xff0000;
	
	public function ControlFrame()
	{
	}
	
	public function clear():void
	{
		this.graphics.clear();
		
		this.topLeftPoint.clear();
		this.topRightPoint.clear();
		this.bottomLeftPoint.clear();
		this.bottomRightPoint.clear();
		
		this.leftPoint.clear();
		this.rightPoint.clear();
		this.topPoint.clear();
		this.bottomPoint.clear();
	}
	
	public function draw():void
	{
		this.graphics.lineStyle(lineWeight, lineColor);
		this.graphics.beginFill(0, 0);
		this.graphics.drawRect(0, 0, this.width, this.height);
		this.graphics.endFill();
		
		this.topLeftPoint.draw();
		this.topRightPoint.draw();
		this.bottomLeftPoint.draw();
		this.bottomRightPoint.draw();
		
		this.leftPoint.draw();
		this.rightPoint.draw();
		this.topPoint.draw();
		this.bottomPoint.draw();
	}
	
	public function dispose():void
	{
		
	}
	
	private var _topLeftPoint:DiagControlPoint;
	private var _topRightPoint:DiagControlPoint;
	private var _bottomLeftPoint:DiagControlPoint;
	private var _bottomRightPoint:DiagControlPoint;
	
	private var _topPoint:SideControlPoint;
	private var _bottomPoint:SideControlPoint;
	private var _leftPoint:SideControlPoint;
	private var _rightPoint:SideControlPoint;
	
	protected function get topLeftPoint():DiagControlPoint
	{
		if (!_topLeftPoint)
		{
			_topLeftPoint = new DiagControlPoint();
			this.addChild(_topLeftPoint);
		}
		
		_topLeftPoint.x = 0;
		_topLeftPoint.y = 0;
		return _topLeftPoint;
	}
	
	protected function get topRightPoint():DiagControlPoint
	{
		if (!_topRightPoint)
		{
			_topRightPoint = new DiagControlPoint();
			this.addChild(_topRightPoint);
		}
		
		_topRightPoint.x = this.width;
		_topRightPoint.y = 0;
		return _topRightPoint;
	}
	
	protected function get bottomLeftPoint():DiagControlPoint
	{
		if (!_bottomLeftPoint)
		{
			_bottomLeftPoint = new DiagControlPoint();
			this.addChild(_bottomLeftPoint);
		}
		
		_bottomLeftPoint.x = 0;
		_bottomLeftPoint.y = this.height;
		return _bottomLeftPoint;
	}
	
	protected function get bottomRightPoint():DiagControlPoint
	{
		if (!_bottomRightPoint)
		{
			_bottomRightPoint = DemoPoolUtil.alloc(DiagControlPoint);
			this.addChild(_bottomRightPoint);
		}
		
		_bottomRightPoint.x = this.width;
		_bottomRightPoint.y = this.height;
		return _bottomRightPoint;
	}
	
	protected function get topPoint():SideControlPoint
	{
		if (!_topPoint)
		{
			_topPoint = new SideControlPoint();
			this.addChild(_topPoint);
		}
		
		_topPoint.x = this.width / 2;
		_topPoint.y = 0;
		return _topPoint;
	}
	
	protected function get bottomPoint():SideControlPoint
	{
		if (!_bottomPoint)
		{
			_bottomPoint = new SideControlPoint();
			this.addChild(_bottomPoint);
		}
		
		_bottomPoint.x = this.width / 2;
		_bottomPoint.y = this.height;
		return _bottomPoint;
	}
	
	protected function get leftPoint():SideControlPoint
	{
		if (!_leftPoint)
		{
			_leftPoint = new SideControlPoint();
			this.addChild(_leftPoint);
		}
		
		_leftPoint.x = 0;
		_leftPoint.y = this.height / 2;
		return _leftPoint;
	}
	
	protected function get rightPoint():SideControlPoint
	{
		if (!_rightPoint)
		{
			_rightPoint = new SideControlPoint();
			this.addChild(_rightPoint);
		}
		
		_rightPoint.x = this.width;
		_rightPoint.y = this.height / 2;
		return _rightPoint;
	}
}

class SelectionController extends UIComponent
{
	public var lineWeight:uint = 1;
	public var lineColor:uint = 0xff0000;
	
	public function SelectionController()
	{
		this.percentWidth = 100;
		this.percentHeight = 100;
		
		this.buttonMode = true;
	}
	
	private var _controlFrameUI:ControlFrame;
	
	private function get controlFrameUI():ControlFrame
	{
		if (!_controlFrameUI)
		{
			_controlFrameUI = DemoPoolUtil.alloc(ControlFrame);
			this.addChild(_controlFrameUI);
		}
		
		_controlFrameUI.lineWeight = this.lineWeight;
		_controlFrameUI.lineColor = this.lineColor;
		return _controlFrameUI;
	}
	
	public function clear():void
	{
		this.controlFrameUI.clear();
	}
	
	public function draw(target:IVisualElement):void
	{
		this.controlFrameUI.x = target.x;
		this.controlFrameUI.y = target.y;
		this.controlFrameUI.width = target.width;
		this.controlFrameUI.height = target.height;
		this.controlFrameUI.draw();
	}
	
	public function dispose():void
	{
		if (_controlFrameUI)
		{
			_controlFrameUI.clear();
			this.removeChild(_controlFrameUI);
			_controlFrameUI = null;
		}
	}
}