package com.lingdong.demo.model.resources
{
	import com.lingdong.demo.model.events.DemoFileEvent;
	
	import flash.display.BitmapData;

	[Event(name="fileIdChange", type="com.lingdong.demo.model.events.DemoFileEvent")]
	[Event(name="urlChange", type="com.lingdong.demo.model.events.DemoFileEvent")]
	public class DemoFile extends DemoResource
	{
		private var _fileId:String;
		private var _url:String;
		
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
		
		public function DemoFile()
		{
			addResource(this);
		}
		
		private function dispatchFileEvent(name:String):void
		{
			this.dispatchEvent(new DemoFileEvent(name));
		}
	}
}