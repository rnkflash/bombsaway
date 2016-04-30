package game.objects.weapons
{
	import flash.display.MovieClip;
	import game.CollisionTypes;
	import game.core.Animation;
	import game.core.AnimationLibrary;
	import game.objects.GameObject;
	import game.objects.heroes.Hero;
	/**
	 * ...
	 * @author 
	 */
	public class Explosion extends GameObject
	{
		private var _lifeTimer:int;
		private var explmc:Animation;
		private var _sndPlayed:Boolean = false;
		
		private var _hitCounter:int = 0;
		
		public function Explosion() 
		{
			explmc = AnimationLibrary.GetAnimation("explosion_clip");
			spriteHolder.addChild(explmc);
			
			hitBoxFoot.width = 120;
			hitBoxFoot.height = 120;
			hitBoxFoot.x= - hitBoxFoot.width / 2;
			hitBoxFoot.y = -hitBoxFoot.height / 2;
			hitBoxBody = hitBoxFoot.clone();
			
			_lifeTimer = explmc.totalFrames;
			explmc.play();
			
			type = CollisionTypes.GROUP_PLAYER_BULLETS;
			
			//DrawHitbox();
		}
		
		override public function Collided(other:GameObject):void 
		{
			if (_hitCounter > 1) 
			{
				return;
			}
			if (other.type == CollisionTypes.GROUP_ENEMIES || other.type == CollisionTypes.GROUP_PLAYER || other is Mine)
			{
				other.Hit(100);
			}
			
		}
		
		override public function Update():void 
		{
			super.Update();
			
			_hitCounter++;
			
			if (!_sndPlayed)
			{
				_sndPlayed = true;
				Sounds.Play2DSnd("bomb_explosion", x);
				world.ShakeIt();
			}
			
			if (_lifeTimer-- <= 0)
			{
				kill = true;
				world.background.MakeExplosionHole(x, y, 100);
			}
		}
		
	}

}