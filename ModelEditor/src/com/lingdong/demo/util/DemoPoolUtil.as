package com.lingdong.demo.util
{
	import flash.utils.Dictionary;

	public class DemoPoolUtil
	{
		private static var _pools:Dictionary = new Dictionary();
		
		private static function getPool(key:*):Array
		{
			return _pools[key] ||= [];
		}
		
		public static function free(object:Object):void
		{
			if (!object) return;
			
			var key:* = Object(object).constructor;
			var pool:Array = getPool(key);
			if (pool.indexOf(object) < 0)
			{
				object.dispose();
				pool.push(object);
			}
		}
		
		public static function alloc(type:Class):*
		{
			if (!type) return null;
			
			var pool:Array = getPool(type);
			if (pool.length > 0)
			{
				return pool.pop();
			}
			else
			{
				return new type();
			}
		}
	}
}