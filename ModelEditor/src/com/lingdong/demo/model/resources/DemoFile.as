package com.lingdong.demo.model.resources
{
	import com.lingdong.demo.model.events.DemoFileEvent;
	import com.lingdong.demo.service.DemoService;
	
	import flash.display.BitmapData;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.FileFilter;

	[Event(name="fileIdChange", type="com.lingdong.demo.model.events.DemoFileEvent")]
	[Event(name="urlChange", type="com.lingdong.demo.model.events.DemoFileEvent")]
	[Event(name="progressChange", type="com.lingdong.demo.model.events.DemoFileEvent")]
	public class DemoFile extends DemoResource
	{
		private var _fileId:String;
		private var _url:String;
		private var _progress:Number;
		
		public function get fileId():String
		{
			return _fileId;
		}
		
		public function set fileId(value:String):void
		{
			if (_fileId != value)
			{
				_fileId = value;
				
				dispatchFileEvent(DemoFileEvent.FILE_ID_CHANGE);
			}
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function set url(value:String):void
		{
			if (_url != value)
			{
				_url = value;
				
				dispatchFileEvent(DemoFileEvent.URL_CHANGE);
			}
		}
		
		public function get progress():Number
		{
			return _progress;
		}
		
		public function set progress(value:Number):void
		{
			if (_progress != value)
			{
				_progress = value;
				
				dispatchFileEvent(DemoFileEvent.PROGRESS_CHANGE);
			}
		}
		
		override public function get isValid():Boolean
		{
			return !this.isUploading;
		}
		
		public function get isUploading():Boolean
		{
			return !isNaN(this.progress);
		}
		
		public function DemoFile()
		{
		}
		
		private function dispatchFileEvent(name:String):void
		{
			this.dispatchEvent(new DemoFileEvent(name));
		}
		
		override public function readConfig(config:Object):void
		{
			if (config)
			{
				this.url = config.url;
			}
		}
		
		override public function writeConfig(config:Object, fileIds:Array):void
		{
			if (config)
			{
				if (this.url)
				{
					config.url = this.url;
				}
				
				if (fileIds && this.fileId)
				{
					fileIds.push(this.fileId);
				}
			}
		}
		
		public function upload():void
		{
			addResource(this);
			
			this.progress = 0;
			
			DemoService.uploadService.uploadFile(
				fileFilter,
				onUploadProgress,
				onUploadCompleteData,
				onUploadError);
		}
		
		protected function get fileFilter():Array
		{
			return null;
		}
		
		private function onUploadProgress(event:ProgressEvent):void
		{
			this.progress = event.bytesLoaded / event.bytesTotal * 100;
		}
		
		private function onUploadCompleteData(event:DataEvent):void
		{ 
			this.progress = 100;
			
			var config:Object = JSON.parse(event.data);
			readUploadConfig(config);
			
			this.progress = NaN;
		}
		
		protected function readUploadConfig(config:Object):void
		{
			throw new Error("to be override!");
		}
		
		private function onUploadError(event:Event):void
		{
			removeResource(this);
		}
		
		override public function compareResource(resource:DemoResource):Boolean
		{
			var file:DemoFile = resource as DemoFile;
			return file && this.url == file.url;
		}
	}
}