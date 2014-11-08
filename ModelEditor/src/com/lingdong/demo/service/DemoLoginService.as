package com.lingdong.demo.service
{
	public class DemoLoginService extends DemoService
	{
		public static const LOGIN:String = "login";
		
		private var loginedUserName:String = "313052590@qq.com";
		private var loginedPassword:String = "111111";
		
		public function get currentUserName():String
		{
			return loginedUserName;
		}
		
		public function DemoLoginService()
		{
		}
		
		private function getLoginParam(userName:String, password:String):Object
		{
			userName ||= loginedUserName;
			password ||= loginedPassword;
			
			return userName && password ? {account: userName, password: password} : null;
		}
		
		public function relogin(onLogin:Function, onError:Function):void
		{
			login(null, null, onLogin, onError);
		}
		
		public function login(userName:String, password:String, onLogin:Function, onError:Function):void
		{
			var param: Object = getLoginParam(userName, password);
			if (param)
			{
				call(LOGIN, 
					param, 
					function(result:Object):void
					{
						loginedUserName = userName;
						loginedPassword = password;
						onLogin && onLogin(result);
					},
					function(result:Object):void
					{
						loginedPassword = null;
						onError && onError(result);
					}
				);
			}
			else
			{
				DemoService.dispatchSecurityErrorEvent();
			}
		}
	}
}