package game.quadtree
{
	/**
	 * This is an organizational class that can update and render a bunch of <code>FlxObject</code>s.
	 * NOTE: Although <code>FlxGroup</code> extends <code>FlxObject</code>, it will not automatically
	 * add itself to the global collisions quad tree, it will only add its members.
	 */
	public class FlxGroup extends FlxObject
	{
		/**
		 * Array of all the <code>FlxObject</code>s that exist in this layer.
		 */
		public var members:Vector.<FlxObject>;
		
		public function FlxGroup()
		{
			members = new Vector.<FlxObject>();
			_group = true;
		}
		
	}
}
