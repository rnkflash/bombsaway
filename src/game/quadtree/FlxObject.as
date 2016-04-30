package game.quadtree{
	import flash.geom.Point;
	

	public class FlxObject extends FlxRect
	{
		private static var last_uid:uint = 0;
		
		public var uid:uint = last_uid++;
		
		/**
		 * Dedicated internal flag for whether or not this class is a FlxGroup.
		 */
		internal var _group:Boolean = false;
		
		/**
		 * Kind of a global on/off switch for any objects descended from <code>FlxObject</code>.
		 */
		public var exists:Boolean = true;		
		
		/**
		 * If an object is dead, the functions that automate collisions will skip it (see <code>FlxG.overlapArrays()</code> and <code>FlxG.collideArrays()</code>).
		 */
		public var solid:Boolean = true;
		
		public var parent:*;
		
		public function kill():void
		{
			exists = false;
		}		
		
		
		
	}
}
