package com.lingdong.demo.view.containers
{
	import flash.events.IEventDispatcher;
	
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;

	public interface IDemoContainer extends IVisualElementContainer, IVisualElement, IEventDispatcher
	{
		function get selectedIndex():int;
		function set selectedIndex(value:int):void;
	}
}