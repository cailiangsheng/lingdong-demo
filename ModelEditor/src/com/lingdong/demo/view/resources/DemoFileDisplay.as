package com.lingdong.demo.view.resources
{
	import com.lingdong.demo.model.events.DemoFileEvent;
	import com.lingdong.demo.model.resources.DemoFile;
	import com.lingdong.demo.model.resources.DemoResource;
	import com.lingdong.demo.util.DemoPoolUtil;
	
	import flash.events.Event;
	
	import mx.controls.ProgressBar;
	import mx.controls.ProgressBarDirection;
	import mx.controls.ProgressBarLabelPlacement;
	import mx.controls.ProgressBarMode;

	public class DemoFileDisplay extends DemoResourceDisplay
	{
		override public function get resource():DemoResource
		{
			return this.file;
		}
		
		override public function set resource(value:DemoResource):void
		{
			this.file = value as DemoFile;
		}
		
		private var _file:DemoFile;
		
		public function get file():DemoFile
		{
			return _file;
		}
		
		public function set file(value:DemoFile):void
		{
			if (_file != value)
			{
				_file && _file.removeEventListener(DemoFileEvent.PROGRESS_CHANGE, updateProgress);
				
				this.dispose();
				
				_file = value;
				
				update();
				
				_file && _file.addEventListener(DemoFileEvent.PROGRESS_CHANGE, updateProgress);
			}
		}
		
		public function DemoFileDisplay()
		{
		}
		
		override protected function update(event:Event=null):void
		{
			super.update(event);
			
			if (file)
			{
				updateProgress();
			}
		}
		
		private var _progressUI:ProgressBar;
		
		private function get progressUI():ProgressBar
		{
			if (!_progressUI)
			{
				_progressUI = DemoPoolUtil.alloc(ProgressBar);
				_progressUI.label = "上传进度";
				_progressUI.mode = ProgressBarMode.MANUAL;
				_progressUI.labelPlacement = ProgressBarLabelPlacement.CENTER;
				_progressUI.direction = ProgressBarDirection.RIGHT;
				_progressUI.percentWidth = 100;
				_progressUI.percentHeight = 100;
				_progressUI.minimum = 0;
				_progressUI.maximum = 100;
				this.addElement(_progressUI);
			}
			
			return _progressUI;
		}
		
		private function updateProgress(event:Event = null):void
		{
			if (!this.stage) return;
			
			if (this.file.isUploading)
			{
				if (this.file.progress > 0)
				{
					this.progressUI.label = "正在上传: " + (this.file.progress).toFixed(2) + "%";
					this.progressUI.setProgress(this.file.progress, 100);
				}
				else
				{
					this.progressUI.label = "准备上传";
					this.progressUI.setProgress(0, 100);
				}
			}
			else
			{
				this.dispose();
			}
		}
		
		private function dispose():void
		{
			if (_progressUI)
			{
				_progressUI.label = "";
				_progressUI.setProgress(0, 100);
				this.removeElement(_progressUI);
				
				DemoPoolUtil.free(_progressUI);
				_progressUI = null;
			}
		}
	}
}