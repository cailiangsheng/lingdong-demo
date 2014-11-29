package com.lingdong.demo.service
{
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;

	public class DemoUploadService extends DemoService
	{
		public static const UPLOAD_FILE:String = "uploadFile";
		public static const UPLOAD_DATAFIELD_NAME:String = "fileu";
		
		public function DemoUploadService()
		{
		}
		
		public function uploadFile(typeFilter:Array, 
								   onProgress:Function, 
								   onCompleteData:Function,
								   onError:Function):void
		{
			var fileReference:FileReference = new FileReference();
			fileReference.addEventListener(Event.SELECT, function(event:Event):void
			{
				doUploadFile(fileReference, onProgress, onCompleteData, onError);
			});
			
			fileReference.addEventListener(Event.CANCEL, onError);
			
			fileReference.browse(typeFilter);
		}
		
		private function doUploadFile(fileReference:FileReference, 
									  onProgress:Function, 
									  onCompleteData:Function,
									  onError:Function):void
		{
			var request:URLRequest = getRequest(UPLOAD_FILE);
			
			fileReference.addEventListener(ProgressEvent.PROGRESS, onProgress);
			fileReference.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, onCompleteData);
			fileReference.addEventListener(HTTPStatusEvent.HTTP_STATUS, onError);
			fileReference.addEventListener(IOErrorEvent.IO_ERROR, onError);
			fileReference.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			
			fileReference.upload(request, UPLOAD_DATAFIELD_NAME);
		}
	}
}