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
	public class MiniExplosion extends GameObject
	{
		private var _lifeTimer:int;
		private var explmc:Animation;
		private var _sndPlayed:Boolean = false;
		
		private var _hitCounter:int = 0;
		
		public function MiniExplosion() 
		{
			explmc = AnimationLibrary.GetAnimation("mini_explosion");
			spriteHolder.addChild(explmc);
			
			hitBoxFoot.width = 60;
			hitBoxFoot.height = 60;
			hitBoxFoot.x= - hitBoxFoot.width / 2;
			hitBoxFoot.y = -hitBoxFoot.height / 2;
			hitBoxBody = hitBoxFoot.clone();
			
			_lifeTimer = explmc.totalFrames;
			explmc.play();
			
			type = CollisionTypes.GROUP_NEUTRAL_BULLETS;
			
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
				other.Hit(1);
			}
			
		}
		
		override public function Update():void 
		{
			super.Update();
			
			_hitCounter++;
			
			if (!_sndPlayed)
			{
				_sndPlayed = true;
				//Sounds.Play2DSnd("bomb_explosion", x);
				//world.ShakeIt();
			}
			
			if (_lifeTimer-- <= 0)
			{
				kill = true;
				if (z>-10 && z < 10) world.background.MakeExplosionHole(x, y, 20+Math.random()*30);
			}
		}
		
	}

}