package com.lingdong.demo.view.resources
{
	import com.lingdong.demo.model.events.DemoFileEvent;
	import com.lingdong.demo.model.resources.DemoResource;
	import com.lingdong.demo.model.resources.DemoVideo;
	import com.lingdong.demo.util.DemoPoolUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mx.controls.VideoDisplay;
	import mx.core.UIComponent;

	public class DemoVideoDisplay extends DemoResourceDisplay
	{
		override public function get resource():DemoResource
		{
			return this.video;
		}
		
		override public function set resource(value:DemoResource):void
		{
			this.video = value as DemoVideo;
		}
		
		private var _video:DemoVideo;
		
		public function get video():DemoVideo
		{
			return _video;
		}
		
		public function set video(value:DemoVideo):void
		{
			if (_video != value)
			{
				_video && _video.removeEventListener(DemoFileEvent.URL_CHANGE, updateURL);
				
				this.dispose();
				
				_video = value;
				
				this.stage && update();
				
				_video && _video.removeEventListener(DemoFileEvent.URL_CHANGE, updateURL);
			}
		}
		
		public function DemoVideoDisplay()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, update);
		}
		
		private function update(event:Event = null):void
		{
			if (video)
			{
				updateURL();
			}
		}
		
		private var _videoUI:VideoDisplay;
		
		private function get videoUI():VideoDisplay
		{
			if (!_videoUI)
			{
				_videoUI = DemoPoolUtil.alloc(VideoDisplay);
				_videoUI.percentWidth = 100;
				_videoUI.percentHeight = 100;
				
				_videoUI.autoPlay = false;
				_videoUI.addEventListener(MouseEvent.MOUSE_OVER, onVideoMouseMove);
				_videoUI.addEventListener(MouseEvent.MOUSE_MOVE, onVideoMouseMove);
				_videoUI.addEventListener(MouseEvent.MOUSE_OUT, onVideoMouseOut);
				
				this.addElement(_videoUI);
			}
			
			return _videoUI;
		}
		
		private var _controllerUI:VideoPlayerController;
		
		private function get controllerUI():VideoPlayerController
		{
			if (!_controllerUI)
			{
				_controllerUI = DemoPoolUtil.alloc(VideoPlayerController);
				_controllerUI.addEventListener(MouseEvent.CLICK, onVideoControllerClick);
				this.addElement(_controllerUI);
			}
			
			return _controllerUI;
		}
		
		private function onVideoMouseMove(event:MouseEvent):void
		{
			this.videoUI.playing ? this.controllerUI.showPauseIcon() : this.controllerUI.showPlayIcon();
		}
		
		private function onVideoMouseOut(event:MouseEvent):void
		{
			if (!this.controllerUI.controlRect.contains(event.localX, event.localY))
			{
				this.controllerUI.showNothing();
			}
		}
		
		private function onVideoControllerClick(event:Event):void
		{
			videoUI.playing ? videoUI.pause() : videoUI.play();
			this.controllerUI.showNothing();
		}
		
		private function updateURL(event:Event = null):void
		{
			this.videoUI.source = video.url;
		}
		
		private function dispose():void
		{
			if (_videoUI)
			{
				_videoUI.source = null;
				_videoUI.removeEventListener(MouseEvent.MOUSE_OVER, onVideoMouseMove);
				_videoUI.removeEventListener(MouseEvent.MOUSE_MOVE, onVideoMouseMove);
				_videoUI.removeEventListener(MouseEvent.MOUSE_OUT, onVideoMouseOut);
				this.removeElement(_videoUI);
				
				DemoPoolUtil.free(_videoUI);
				_videoUI = null;
			}
			
			if (_controllerUI)
			{
				_controllerUI.showNothing();
				_controllerUI.removeEventListener(MouseEvent.CLICK, onVideoControllerClick);
				this.removeElement(_controllerUI);
				_controllerUI = null;
			}
		}
	}
}

import flash.geom.Rectangle;

import mx.core.UIComponent;

class VideoPlayerController extends UIComponent
{
	public var fillColor:uint;
	public var iconColor:uint;
	
	public function VideoPlayerController(fillColor:uint = 0xffffff, iconColor:uint = 0x000000)
	{
		this.fillColor = fillColor;
		this.iconColor = iconColor;
		
		this.percentWidth = 100;
		this.percentHeight = 100;
		
		this.buttonMode = true;
	}
	
	private function getCenterRect(size:Number):Rectangle
	{
		return new Rectangle(
			this.width / 2 - size / 2, 
			this.height / 2 - size / 2, 
			size, 
			size
		);
	}
	
	public function get controlRect():Rectangle
	{
		var controlWidth:Number = this.width / 8;
		var controlHeight:Number = this.height / 8;
		var controlSize:Number = Math.min(controlWidth, controlHeight);
		
		return getCenterRect(controlSize);
	}
	
	public function showPlayIcon():void
	{
		var rect:Rectangle = this.controlRect;
		this.graphics.clear();
		
		this.graphics.lineStyle(this.iconColor);
		this.graphics.beginFill(this.fillColor);
		this.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
		this.graphics.endFill();
		
		this.graphics.lineStyle();
		this.graphics.beginFill(this.iconColor);
		this.graphics.moveTo(rect.x + rect.width / 3, rect.y + rect.height / 4);
		this.graphics.lineTo(rect.x + rect.width / 3, rect.bottom - rect.height / 4);
		this.graphics.lineTo(rect.right - rect.width / 4, rect.y + rect.height / 2);
		this.graphics.lineTo(rect.x + rect.width / 3, rect.y + rect.height / 4);
		this.graphics.endFill();
	}
	
	public function showPauseIcon():void
	{
		var rect:Rectangle = this.controlRect;
		this.graphics.clear();
		
		this.graphics.lineStyle(this.iconColor);
		this.graphics.beginFill(this.fillColor);
		this.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
		this.graphics.endFill();
		
		this.graphics.lineStyle();
		this.graphics.beginFill(this.iconColor);
		this.graphics.drawRect(rect.x + rect.width * 5 / 16, rect.y + rect.height / 4, rect.width / 8, rect.height / 2);
		this.graphics.endFill();
		
		this.graphics.beginFill(this.iconColor);
		this.graphics.drawRect(rect.x + rect.width * 9 / 16, rect.y + rect.height / 4, rect.width / 8, rect.height / 2);
		this.graphics.endFill();
	}
	
	public function showNothing():void
	{
		this.graphics.clear();
	}
}