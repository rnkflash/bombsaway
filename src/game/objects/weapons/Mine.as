package game.objects.weapons 
{
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import game.CollisionTypes;
	import game.core.Animation;
	import game.core.AnimationHolder;
	import game.core.AnimationLibrary;
	import game.objects.GameObject;
	import game.objects.heroes.Hero;
	/**
	 * ...
	 * @author 
	 */
	public class Mine extends GameObject
	{
		private var _exploded:Boolean = false;
		
		private static var hitbox:MovieClip;
		
		public function Mine() 
		{
			var mc:Animation = AnimationLibrary.GetAnimation("mine_mc");
			
			if (!hitbox)
				hitbox = new mine_hitboxes();
			
			InitHitboxesAndMainMovieclip(mc, hitbox);
			HP = 1;
			
			type = CollisionTypes.GROUP_OBJECTS;
			//DrawHitbox();
		}
		
		override public function Collided(other:GameObject):void 
		{
			if (other.type == CollisionTypes.GROUP_PLAYER || other.type == CollisionTypes.GROUP_ENEMIES)
			{
				Boom();
				
			}
		}
		
		override protected function Killed():void 
		{
			super.Killed();
			Boom();
		}
		
		private function Boom():void 
		{
			if (_exploded) return;
			var expl:Explosion = new Explosion();
			expl.x = x;
			expl.y = y;
			expl.z = z;
			world.Add(expl);
			kill = true;
			_exploded = true;
		}
		
	}

}