package game.quadtree{
	import flash.display.Sprite;

	
	public class FlxU
	{
		/**
		 * Controls the granularity of the quad tree.  Default is 3 (decent performance on large and small worlds).
		 */
		static public var quadTreeDivisions:uint = 25;
		
		/**
		 * Helps to eliminate false collisions and/or rendering glitches caused by rounding errors
		 */
		static internal var roundingError:Number = 0.0000001;		
		
		
		static public var screen:Sprite;
		static public function DrawDebugRect(x:Number,y:Number,w:Number,h:Number,c:uint):void
		{
			if (!screen) return;
			
			var colorPower:Number = w * h / 10000;
			if (colorPower > 1.0) colorPower = 1.0;
			
			screen.graphics.lineStyle(1.0, 0xFFFFFF);
			screen.graphics.beginFill(0x000000, 1.0-colorPower);
			screen.graphics.drawRect(x, y, w, h);
			screen.graphics.endFill();
			
		}
	}
}
