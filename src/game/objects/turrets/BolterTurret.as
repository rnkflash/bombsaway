package game.objects.turrets
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import game.CollisionTypes;
	import game.core.AnimationHolder;
	import game.core.AnimationLibrary;
	import game.Input;
	import game.objects.bonus.MedBonus;
	import game.objects.GameObject;
	import game.objects.weapons.Bomber;
	import game.objects.weapons.Bullet;
	import game.objects.weapons.Grenade;
	import game.objects.weapons.KnifeAttack;
	import game.objects.weapons.RadarCheck;
	/**
	 * ...
	 * @author 
	 */
	public class BolterTurret extends GameObject
	{
		
		private var mc:AnimationHolder;
		private var currentAnim:String="stand";
		private var _shootTimerMax:int=7;
		private var _shootTimer:int;
		
		private var _firing:Boolean = false;

		private var _radarTimerMax:int=10;
		private var _radarTimer:int;
		
		private var fire_order:Boolean = false;
		private static var hitboxMovie:MovieClip;
		
		public function BolterTurret() 
		{
			//init timers
			_shootTimer = _shootTimerMax;
			
			//movieclip
			mc = new AnimationHolder();
			mc.AddAnimation("stand", AnimationLibrary.GetAnimation("bolter_turret_standing"));
			mc.AddAnimation("fire", AnimationLibrary.GetAnimation("bolter_turret_firing"));
			
			if (!hitboxMovie)
				hitboxMovie = new bolter_turret_hitboxes();
			InitHitboxesAndMainMovieclip(mc,hitboxMovie);
			
			
			//dmg color
			_dmgTextColor = 0xFF0000;
			
			//type
			type = CollisionTypes.GROUP_PLAYER;
		}
		

		
		override public function Die():void 
		{
			super.Die();
			HP = 0;
			
		}
		
		
		override public function Update():void 
		{
			super.Update();
			
			var _newfiring:Boolean = false;
			
			if (_shootTimer < _shootTimerMax)
			{
				_shootTimer++;
			}			
			
			if (_radarTimer < _radarTimerMax)
			{
				_radarTimer++;
			}
			
			Radar();
			
			
			if (fire_order)
			{
				Fire();
				_newfiring = true;
			} 
			
			ChangeGraphics(direction,_newfiring);
		}
		
		private function Radar():void 
		{
			if (_radarTimer < _radarTimerMax) return;
			
			var radar:RadarCheck = new RadarCheck(direction, OnRadarCallback);
			radar.x = x;
			radar.y = y;
			radar.z = z;
			world.Add(radar);
		}
		
		private function OnRadarCallback(victims:Array):void 
		{
			if (victims.length) 
				fire_order = true;
			else
				fire_order = false;
		}
		
		
		public function ChangeGraphics(direction:Boolean,firing:Boolean):void 
		{
			//check changes
			if (this.direction != direction)
			{
				this.direction = direction;
				mc.scaleX = direction?1.0: -1.0;
			}
			
			if (firing != _firing )
			{
				_firing = firing;
				var anims:Array = ["stand", "fire"];
				var anim:int = 0;
				
				if (firing)
					anim = 1;
				else
					anim = 0;
				
				SetAnimation(anims[anim]);
			}
			
		}
		
		
		public function Fire():void
		{
			if (_shootTimer < _shootTimerMax) return;
			
			_shootTimer = 0;
			
			Sounds.Play2DSnd("shoot",x);
			
			
			var razbrosAngle:Number = Math.PI / 32;
			var shotAngle:Number = direction?(razbrosAngle-2 * razbrosAngle * Math.random()):(Math.PI + razbrosAngle-2 * razbrosAngle * Math.random());
			
			var bullet:Bullet = new Bullet(shotAngle, 1 - 2 * Math.random());
			bullet.x = x + (direction?37:-37);
			bullet.y = y;
			bullet.z = z-28;
			world.Add(bullet);
			
/*			var razbrosAngle:Number = Math.PI / 32;
			
			bullet = new Bullet(direction?razbrosAngle:(Math.PI + razbrosAngle));
			bullet.x = x + (direction?33:-33);
			bullet.y = y;
			bullet.z = z-12;
			world.Add(bullet);
			
			bullet = new Bullet(direction?-razbrosAngle:(Math.PI - razbrosAngle));
			bullet.x = x + (direction?33:-33);
			bullet.y = y;
			bullet.z = z-12;
			world.Add(bullet);
*/			
			
		}
		
		public function SetAnimation(newAnim:String):void
		{
			if (currentAnim == newAnim)
				return;
				
			currentAnim = newAnim;
			mc.play(currentAnim);
		}
		
		override public function Hit(dmg:Number):void 
		{
			super.Hit(dmg);
			if (kill)
			{
				//Sounds.Play2DSnd("hero_die",x);
				return;
			}
			//Sounds.Play2DSnd("hero_hit", x);
		}
		
		
	}

}