package com.lingdong.demo.util
{
	import flash.external.ExternalInterface;

	public class DemoBrowserUtil
	{
		public static function getProperty(key:String):String
		{
			if (ExternalInterface.available)
			{
				return ExternalInterface.call("window." + key + ".toString");
			}
			
			return null;
		}
		
		private static var locationKeys: Array = [
			"host", "hostname", "href", "origin", "pathname", "port", "protocol", "search"
		];
		
		public static function get location():Object
		{
			var result:Object = {};
			
			for each (var key:String in locationKeys)
			{
				result[key] = getProperty("location." + key);
			}
			
			return result;
		}
	}
}