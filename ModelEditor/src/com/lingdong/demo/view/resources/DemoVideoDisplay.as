package com.lingdong.demo.view.resources
{
	import com.lingdong.demo.model.events.DemoFileEvent;
	import com.lingdong.demo.model.resources.DemoFile;
	import com.lingdong.demo.model.resources.DemoResource;
	import com.lingdong.demo.model.resources.DemoVideo;
	import com.lingdong.demo.util.DemoPoolUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mx.controls.VideoDisplay;
	import mx.core.UIComponent;
	import mx.core.mx_internal;

	public class DemoVideoDisplay extends DemoFileDisplay
	{
		override public function set file(value:DemoFile):void
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
			super.file = value;
			
			if (_video != value)
			{
				_video && _video.removeEventListener(DemoFileEvent.URL_CHANGE, updateURL);
				
				this.dispose();
				
				_video = value;
				
				update();
				
				_video && _video.addEventListener(DemoFileEvent.URL_CHANGE, updateURL);
			}
		}
		
		override public function get contentWidth():Number
		{
			return _videoUI ? _videoUI.mx_internal::videoPlayer.width : this.width;
		}
		
		override public function get contentHeight():Number
		{
			return _videoUI ? _videoUI.mx_internal::videoPlayer.height : this.height;
		}
		
		public function DemoVideoDisplay()
		{
		}
		
		override protected function update(event:Event = null):void
		{
			super.update(event);
			
			if (this.video)
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
				_videoUI.maintainAspectRatio = super.maintainAspectRatio;
				_videoUI.setStyle("contentBackgroundAlpha", 0);
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
		
		override protected function updateMaintainAspectRatio():void
		{
			if (_videoUI)
			{
				_videoUI.maintainAspectRatio = super.maintainAspectRatio;
			}
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
			if (this.videoUI.source)
			{
				this.videoUI.playing ? this.controllerUI.showPauseIcon() : this.controllerUI.showPlayIcon();
			}
			else
			{
				this.controllerUI.showNothing();
			}
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
			if (!this.stage) return;
			
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
				
				DemoPoolUtil.free(_controllerUI);
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