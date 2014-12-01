package com.lingdong.demo.model
{
	public interface IDemoConfig
	{
		function readConfig(config:Object):void;
		function writeConfig(config:Object, fileIds:Array):void;
	}
}