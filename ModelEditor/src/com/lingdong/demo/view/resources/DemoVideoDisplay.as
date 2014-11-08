package com.lingdong.demo.view.resources
{
	import com.lingdong.demo.model.events.DemoFileEvent;
	import com.lingdong.demo.model.resources.DemoResource;
	import com.lingdong.demo.model.resources.DemoVideo;
	import com.lingdong.demo.util.DemoPoolUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
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
			else
			{
				this.dispose();
			}
		}
		
		private var _videoUI:VideoDisplay;
		
		private function get videoUI():VideoDisplay
		{
			if (!_videoUI)
			{
				_videoUI = DemoPoolUtil.alloc(VideoDisplay);
				_videoUI.width = this.width;
				_videoUI.height = this.height;
				
				videoUI.autoPlay = false;
				videoUI.buttonMode = true;
				videoUI.addEventListener(MouseEvent.CLICK, onVideoClick);
				
				this.addChild(_videoUI);
			}
			
			return _videoUI;
		}
		
		private function onVideoClick(event:Event):void
		{
			videoUI.playing ? videoUI.pause() : videoUI.play();
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			
			this.videoUI.width = value;
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			
			this.videoUI.height = value;
		}
		
		private function updateURL(event:Event = null):void
		{
			this.videoUI.source = video.url;
		}
		
		private function dispose():void
		{
			if (_videoUI)
			{
				_videoUI.stop();
				_videoUI.source = null;
				_videoUI.removeEventListener(MouseEvent.CLICK, onVideoClick);
				this.removeChild(_videoUI);
				
				DemoPoolUtil.free(_videoUI);
				_videoUI = null;
			}
		}
	}
}