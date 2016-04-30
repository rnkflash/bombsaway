package game.objects.enemies
{
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Transform;
	import game.CollisionTypes;
	import game.core.AnimationHolder;
	import game.core.AnimationLibrary;
	import game.objects.bonus.BombBonus;
	import game.objects.bonus.GrenadeBonus;
	import game.objects.bonus.MedBonus;
	import game.objects.GameObject;
	import game.objects.heroes.Hero;
	/**
	 * ...
	 * @author 
	 */
	public class Zombie extends GameObject
	{
		
		static public const XSPEED:Number = -1.2;
		
		private var moveCounter:int = 1;
		
		private var _hitTimer:int = 30;
		private var clip:AnimationHolder;
		
		private static var hitbox:MovieClip;
		
		public function Zombie() 
		{
			HP = 50;
			
			clip = new AnimationHolder();
			clip.AddAnimation("run", AnimationLibrary.GetAnimation("zombie_clip"));
			clip.play("run");
			
			if (!hitbox)
				hitbox = new zombie_hitboxes();
			
			
			InitHitboxesAndMainMovieclip(clip, hitbox);
			
			clip.scaleX = -1.0;
			
			type = CollisionTypes.GROUP_ENEMIES;
			
			//DrawHitbox();
		}
		
		override public function Collided(other:GameObject):void 
		{
			if (other is Hero)
			{
				if (_hitTimer >= 30)
				{
					var her:Hero = other as Hero;
					her.Hit(10 + Math.floor(20 * Math.random()));
					_hitTimer = 0;
				}
			}
		}
		

		
		override public function Update():void 
		{
			super.Update();
			
			if (_hitTimer<30)
				_hitTimer++;
			
			
			if (moveCounter>17 || moveCounter<5)
				x += XSPEED;
				
			moveCounter++;
			if (moveCounter >= 25)
			moveCounter = 1;
			
			
			var distanceToCamera:Number = Math.abs(world.camera.x - x);
			//if (x < -50)
			if (distanceToCamera > 640*2 || x < -50)
			{
				kill = true;
			}
		}
		
		override public function Hit(dmg:Number):void 
		{
			var justDied:Boolean = kill;
			super.Hit(dmg);
			
			
			
			if (kill && kill!=justDied)
			{
				ForcedDeath();
				return;
			}
			
			Sounds.Play2DSnd("monster_hit",x);
		}
		
		private function ForcedDeath():void 
		{
			Sounds.Play2DSnd("monster_die", x);
			if (Math.random() > 0.9)
			{
				var bonus:MedBonus = new MedBonus();
				bonus.x = x;
				bonus.y = y;
				
				world.Add(bonus);
			} else
			if (Math.random() > 0.9)
			{
				var gbonus:GrenadeBonus= new GrenadeBonus();
				gbonus.x = x;
				gbonus.y = y;
				world.Add(gbonus);
			} else
			if (Math.random() > 0.9)
			{
				var bbonus:BombBonus= new BombBonus();
				bbonus.x = x;
				bbonus.y = y;
				world.Add(bbonus);
			}
		}
		
	}

}