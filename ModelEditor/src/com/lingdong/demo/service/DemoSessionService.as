package com.lingdong.demo.service
{
	public class DemoSessionService extends DemoService
	{
		public function DemoSessionService()
		{
		}
		
		override protected function call(path:String, param:Object, onComplete:Function=null, onError:Function=null):void
		{
			var super_call:Function = super.call;
			
			super.call(path, param, onComplete, function(result:Object):void
			{
				validateSession(function(result:Object):void
				{
					super_call(path, param, onComplete, onError);
				});
			});
		}
		
		private function validateSession(onValidate:Function):void
		{
			DemoService.loginService.relogin(onValidate, onSessionError);
		}
		
		private function onSessionError(result:Object):void
		{
			DemoService.dispatchSecurityErrorEvent();
		}
	}
}