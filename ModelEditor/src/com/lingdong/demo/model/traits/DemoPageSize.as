package com.lingdong.demo.model.traits
{
	import flash.geom.Point;

	public class DemoPageSize
	{
		public static const DEFAULT_WIDTH:int = 400;
		public static const DEFAULT_HEIGHT:int = 300;
		public static const DEFAULT_PADDING:int = 10;
		public static const SCROLLBAR_HEIGHT:int = 20;
		public static const THUMBNAIL_HEIGHT:int = 64;
		
		public var pageWidth:int = DEFAULT_WIDTH;
		public var pageHeight:int = DEFAULT_HEIGHT;
		public var pagePadding:int = DEFAULT_PADDING;
		
		public function getLayoutSize(containerHeight:Number):Point
		{
			return getSize(containerHeight - SCROLLBAR_HEIGHT, true);
		}
		
		public function get thumbnailSize():Point
		{
			return getSize(THUMBNAIL_HEIGHT - SCROLLBAR_HEIGHT, true);
		}
		
		private function getSize(viewportHeight:Number, withPadding:Boolean):Point
		{
			var size:Point = new Point();
			size.y = viewportHeight * (pageHeight - pagePadding * 2) / pageHeight;
			size.x = size.y * pageWidth / pageHeight;
			return size;
		}
		
		public function DemoPageSize()
		{
		}
	}
}