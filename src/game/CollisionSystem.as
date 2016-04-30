package game 
{
	import game.quadtree.FlxGroup;
	import game.quadtree.FlxObject;
	import game.quadtree.FlxQuadTree;
	import game.quadtree.FlxRect;
	/**
	 * ...
	 * @author rnk
	 */
	public class CollisionSystem 
	{
		public var quadTreeBounds:FlxRect = new FlxRect(-1000,-1000,2000,2000);
		private var playerGroup:FlxGroup = new FlxGroup();
		private var enemyGroup:FlxGroup = new FlxGroup();

		
		private static const GROUP_NAMES:Array = [
													"",
													CollisionTypes.GROUP_PLAYER,
													CollisionTypes.GROUP_PLAYER_BULLETS,
													CollisionTypes.GROUP_ENEMIES,
													CollisionTypes.GROUP_ENEMY_BULLETS,
													CollisionTypes.GROUP_OBJECTS,
													CollisionTypes.GROUP_NEUTRAL_BULLETS,
													CollisionTypes.GROUP_BONUS
												];
		
		private static const GROUP_COLLISIONS:Array = 
		[
			{groupA:CollisionTypes.GROUP_PLAYER , groupB:CollisionTypes.GROUP_ENEMIES }/*,
			{groupA:CollisionTypes.GROUP_PLAYER , groupB:CollisionTypes.GROUP_ENEMY_BULLETS },
			{groupA:CollisionTypes.GROUP_PLAYER , groupB:CollisionTypes.GROUP_OBJECTS },
			{groupA:CollisionTypes.GROUP_PLAYER , groupB:CollisionTypes.GROUP_BONUS },
			{groupA:CollisionTypes.GROUP_PLAYER_BULLETS , groupB:CollisionTypes.GROUP_ENEMIES },
			{groupA:CollisionTypes.GROUP_ENEMIES , groupB:CollisionTypes.GROUP_OBJECTS },
			{groupA:CollisionTypes.GROUP_NEUTRAL_BULLETS , groupB:CollisionTypes.GROUP_PLAYER },
			{groupA:CollisionTypes.GROUP_NEUTRAL_BULLETS , groupB:CollisionTypes.GROUP_ENEMIES },
			{groupA:CollisionTypes.GROUP_NEUTRAL_BULLETS , groupB:CollisionTypes.GROUP_OBJECTS }*/
			
		];
		
		public var collisionGroups:Object = { };
		
		public function CollisionSystem() 
		{
			
		}
		
		public function Init():void
		{
			for each (var name:String in GROUP_NAMES) 
			{
				collisionGroups[name] = new FlxGroup();
			}
		}
		
		public function AddObject(obj:FlxObject,groupName:String):void
		{
			var grp:FlxGroup = enemyGroup;// collisionGroups[groupName];
			
			if (groupName == CollisionTypes.GROUP_PLAYER || groupName == CollisionTypes.GROUP_PLAYER_BULLETS)
			grp = playerGroup;
			
			if (grp)
			{
	 			grp.members.push(obj);
			} else
			{
        		throw new Error("wrong groupName=" + groupName);
			}
		}
		
		public function RemoveObject(obj:FlxObject,groupName:String):void
		{
			var grp:FlxGroup = enemyGroup;//collisionGroups[groupName];
			
			if (groupName == CollisionTypes.GROUP_PLAYER || groupName == CollisionTypes.GROUP_PLAYER_BULLETS)
			grp = playerGroup;
			
			
			if (grp)
			{
				var idx:int = grp.members.indexOf(obj);
				if (idx >= 0) grp.members.splice(idx, 1);
			}
		}
		
		public function update():void
		{
			overlap(playerGroup, enemyGroup, OnCollision);
			overlap(playerGroup, playerGroup, OnCollision);
			PostCollisionEventsProcess();
			/*for each (var colGrp:Object in GROUP_COLLISIONS) 
			{
				overlap(collisionGroups[colGrp.groupA], collisionGroups[colGrp.groupB], OnCollision);
			}*/
		}
		
		private function overlap(Object1:FlxObject,Object2:FlxObject,Callback:Function=null):Boolean
		{
			var quadTree:FlxQuadTree;
			if( (Object1 == null) || !Object1.exists ||
				(Object2 == null) || !Object2.exists )
				return false;
			quadTree = new FlxQuadTree(quadTreeBounds.x, quadTreeBounds.y, quadTreeBounds.width, quadTreeBounds.height);
			quadTree.add(Object1, FlxQuadTree.A_LIST);
			if(Object1 === Object2)
				return quadTree.overlap(false,Callback);
			quadTree.add(Object2,FlxQuadTree.B_LIST);
			return quadTree.overlap(true,Callback);
		}			
		
		private var postCollisionEvents:Object = {};
		
		private function OnCollision(obj1:FlxObject, obj2:FlxObject):void
		{
			if (obj1.parent.DoubleCheck(obj2.parent))
			{
				if (!postCollisionEvents[obj1.uid+"_"+obj2.uid] && !postCollisionEvents[obj2.uid+"_"+obj1.uid])
				postCollisionEvents[obj1.uid + "_" + obj2.uid] = [obj1,obj2];
				//obj1.parent.Collided(obj2.parent);
				//obj2.parent.Collided(obj1.parent);
			}
			
		}	
		
		private function PostCollisionEventsProcess():void
		{
			
			for each (var event:Array in postCollisionEvents) 
			{
				var obj1:FlxObject = event[0];
				var obj2:FlxObject = event[1];
				obj1.parent.Collided(obj2.parent);
				obj2.parent.Collided(obj1.parent);
				
			}
			postCollisionEvents = {};
		}
		
	}

}