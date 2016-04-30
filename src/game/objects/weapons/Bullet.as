package game.objects.weapons
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import game.CollisionTypes;
	import game.core.Animation;
	import game.core.AnimationLibrary;
	import game.objects.GameObject;
	/**
	 * ...
	 * @author 
	 */
	public class Bullet extends GameObject
	{
		private var _angle:Number;
		
		static public const SPEED:Number = 13;
		private var dx:Number;
		private var dy:Number;
		private var dz:Number;
		private var delay_kill:int = -1;
		private var life_timer:int = 30 * 2 + Math.random() * 30;
		private static var hitbox:MovieClip;
		
		public function Bullet(angle:Number,_dz:Number=0) 
		{
			_angle = angle;
			
			var mc:Animation = AnimationLibrary.GetAnimation("bullet1_mc");
			
			
			if (!hitbox)
				hitbox = new bullet_hitboxes();
			
			InitHitboxesAndMainMovieclip(mc, hitbox);
			
			dx = Math.cos(angle) * SPEED;
			dy = Math.sin(angle) * SPEED;
			dz = _dz;
			
			if (dx < 0) 
			{
				direction = false;
				
			}
			
			mc.rotation = angle*180/Math.PI;
			
			type = CollisionTypes.GROUP_PLAYER_BULLETS;
			
			//DrawHitbox();
			
			var shadow:Animation = AnimationLibrary.GetAnimation("bullet_shadow");
			shadowHolder.addChild(shadow);
			shadow.rotation = angle*180/Math.PI;
		}
		
		override public function Collided(other:GameObject):void 
		{
			if (other.type == CollisionTypes.GROUP_ENEMIES)
			{
				other.x += direction?5:-5;
				other.Hit(10 + Math.floor(20 * Math.random()));
				delay_kill = 2;
				collidable = false;
				
				Boom();
			}

		}
		
		private function Boom():void 
		{
			var miniexpl:MiniExplosion = new MiniExplosion();
			miniexpl.x = x;
			miniexpl.y = y;
			miniexpl.z = z;
			world.Add(miniexpl);
		}
		
		
		override public function Update():void 
		{
			super.Update();
			
			x += dx;
			y += dy;
			z += dz;
			
			
			if (delay_kill>0)
			{
				if (--delay_kill <= 0)
					kill = true;
			}
			
			if (life_timer-- < 0)
			{
				kill = true;
				Boom();
			}
			
			/*if (x<world.le.bounds.x || x > (world.camera.bounds.width) 
				|| y<world.camera.bounds.y || y>world.camera.bounds.height)
			{
				kill = true;
			}*/
			
			if (z > 0)
			{
				kill = true;
				Boom();
			}
		}
		
	}

}