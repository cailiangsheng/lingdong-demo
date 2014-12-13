package com.lingdong.demo.model.traits
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	
	import mx.core.Container;

	public class DemoPageSize
	{
		public static const DEFAULT_WIDTH:int = 400;
		public static const DEFAULT_HEIGHT:int = 300;
		public static const DEFAULT_PADDING:int = 10;
		public static const THUMBNAIL_SIZE:int = 60;
		
		public var pageWidth:int = DEFAULT_WIDTH;
		public var pageHeight:int = DEFAULT_HEIGHT;
		public var pagePadding:int = DEFAULT_PADDING;
		
		public function getFitSize(container:DisplayObjectContainer):Point
		{
			return getSize(container.width, container.height, true);
		}
		
		public function get thumbnailSize():Point
		{
			return getSize(THUMBNAIL_SIZE, THUMBNAIL_SIZE, false);
		}
		
		private function getSize(viewportWidth:Number, viewportHeight:Number, withPadding:Boolean):Point
		{
			var padding:int = withPadding ? pagePadding * 2 : 0;
			
			var size1:Point = new Point();
			size1.y = viewportHeight - padding;
			size1.x = size1.y * pageWidth / pageHeight;
			
			var size2:Point = new Point();
			size2.x = viewportWidth - padding;
			size2.y = size2.x * pageHeight / pageWidth;
			
			return new Point(Math.min(size1.x, size2.x), Math.min(size1.y, size2.y));
		}
		
		public function DemoPageSize()
		{
		}
	}
}