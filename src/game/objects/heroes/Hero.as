package game.objects.heroes
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import game.CollisionTypes;
	import game.core.AnimationHolder;
	import game.core.AnimationLibrary;
	import game.Input;
	import game.objects.bonus.MedBonus;
	import game.objects.GameObject;
	import game.objects.turrets.BolterTurret;
	import game.objects.weapons.Bomber;
	import game.objects.weapons.Bullet;
	import game.objects.weapons.Grenade;
	import game.objects.weapons.KnifeAttack;
	/**
	 * ...
	 * @author 
	 */
	public class Hero extends GameObject
	{
		
		private var heromc:AnimationHolder;
		private var currentAnim:String="stand";
		private var _grenades:int=10;
		private var _bombs:int=5;
		private var _shootTimerMax:int=7;
		private var _shootTimer:int;
		private var _closeCombatTimerMax:int=10;
		private var _closeCombatTimer:int;
		private var _screamed:Boolean = false;
		
		
		private var _moving:Boolean = false;
		private var _firing:Boolean = false;
		private var _closecombat:Boolean = false;
		
		public static const XSPEED:Number = 5;
		public static const YSPEED:Number = 4;
		public static const EVENT_GRENADES_CHANGED:String= "eventGCH";
		public static const EVENT_BOMBS_CHANGED:String = "EVBCH";
		
		private static var hitbox:MovieClip;
		
		public function Hero() 
		{
			//init timers
			_shootTimer = _shootTimerMax;
			_closeCombatTimer = _closeCombatTimerMax;
			
			//movieclip
			
			var animHolder:AnimationHolder = new AnimationHolder();
			animHolder.AddAnimation("run_fire", AnimationLibrary.GetAnimation("hero_run_fire"));
			animHolder.AddAnimation("stand", AnimationLibrary.GetAnimation("hero_stand"));
			animHolder.AddAnimation("run", AnimationLibrary.GetAnimation("hero_run"));
			animHolder.AddAnimation("run_knife", AnimationLibrary.GetAnimation("hero_run_knife"));
			animHolder.AddAnimation("stand_fire", AnimationLibrary.GetAnimation("hero_stand_fire"));
			animHolder.AddAnimation("stand_knife", AnimationLibrary.GetAnimation("hero_stand_knife"));
			
			animHolder.play("stand");
			heromc = animHolder;
			
			if (!hitbox)
				hitbox = new hero_hitboxes();
			
			InitHitboxesAndMainMovieclip(heromc,hitbox);
			
			
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
			
			if (_shootTimer < _shootTimerMax)
			{
				_shootTimer++;
			}
			if (_closeCombatTimer < _closeCombatTimerMax)
			{
				_closeCombatTimer++;
			}
			
			var dx:Number = 0;
			var dy:Number = 0;
			var _newdirection:Boolean = direction;
			var _newmoving:Boolean = false;
			var _newfiring:Boolean = false;
			var _newclosecombat:Boolean = false;
			
			
			if (Input.isKeyDown(38)) //up
			{
				dy = -YSPEED;
				
			} else
			if (Input.isKeyDown(40)) //down
			{
				dy = YSPEED;
				
			}
			
			if (Input.isKeyDown(37)) //left
			{
				dx = -XSPEED;
				_newdirection = false;
				
			} else
			if (Input.isKeyDown(39)) //right
			{
				dx = XSPEED;
				_newdirection = true;
			}
			
			x += dx;
			y += dy;
			
			if (dx ==0 &&  dy == 0)
			{
				
			} else
			{
				_newmoving = true;
			}
			
			if (Input.isKeyDown(32)) //space
			{
				Fire();
				_newfiring = true;
			} 
			else
			if (Input.isKeyDown(67)) //c
			{
				CloseCombat();
				_newclosecombat = true;
			} 
			
			if (Input.isKeyPressed(90))//x
			{
				ThrowGrenade();
				//InstallTurret();
			}
			if (Input.isKeyPressed(86))//v
			{
				InstallTurret();
			}
			if (Input.isKeyPressed(88))//z
			{
				CallBomber();
			}
			
			ChangeGraphics(_newdirection, _newfiring, _newclosecombat,_newmoving);
		}
		
		private function InstallTurret():void 
		{
			var turret:BolterTurret = new BolterTurret();
			turret.x = x;
			turret.y = y;
			turret.z = 0;
			turret.ChangeGraphics(direction,false);
			world.Add(turret);
		}
		
		private function CloseCombat():void 
		{
			
			if (_closeCombatTimer < _closeCombatTimerMax) return;
			
			_closeCombatTimer = 0;		
			
			Sounds.Play2DSnd("knife_attack", x);
			
			var ka:KnifeAttack = new KnifeAttack(direction);
			ka.x = x + (direction?20:-20);
			ka.y = y;
			ka.z = z - 11;
			world.Add(ka);
		}
		
		private function ChangeGraphics(direction:Boolean,firing:Boolean,closecombat:Boolean,moving:Boolean):void 
		{
			//check changes
			if (this.direction != direction)
			{
				this.direction = direction;
				heromc.scaleX = direction?1.0: -1.0;
			}
			
			if (firing != _firing || moving != _moving || closecombat != _closecombat )
			{
				_firing = firing;
				_moving = moving;
				_closecombat = closecombat;
				var anims:Array = ["stand", "run", "stand_fire", "run_fire", "stand_knife", "run_knife"];
				var anim:int = 0;
				
				if (moving && firing && !closecombat)
					anim = 3;
				else
				if (!moving && firing && !closecombat)
					anim = 2;
				else
				if (moving && !firing && !closecombat)
					anim = 1;
				else
				if (moving && closecombat && !firing)
					anim = 5;
				else
				if (!moving && closecombat && !firing)
					anim = 4;
				
				SetAnimation(anims[anim]);
			}
			
		}
		
		public function CallBomber():void
		{
			if (bombs <= 0) return;
			
			bombs--;
			
			var bomber:Bomber = new Bomber(direction);
			bomber.x = direction?(world.camera.x + world.camera.width + 100):(world.camera.x - 100);
			bomber.y = y;
			world.Add(bomber);
		}
		
		public function ThrowGrenade():void
		{
			if (grenades<= 0) return;
			
			grenades--;
			
			var gren:Grenade= new Grenade(direction);
			gren.x = x;
			gren.y = y;
			gren.z = z-11;
			world.Add(gren);
		}
		
		public function Fire():void
		{
			if (_shootTimer < _shootTimerMax) return;
			
			_shootTimer = 0;
			
			Sounds.Play2DSnd("shoot",x);
			
			
			var razbrosAngle:Number = Math.PI / 32;
			var shotAngle:Number = direction?(razbrosAngle-2 * razbrosAngle * Math.random()):(Math.PI + razbrosAngle-2 * razbrosAngle * Math.random());
			
			var bullet:Bullet = new Bullet(shotAngle, 1 - 2 * Math.random());
			bullet.x = x + (direction?33:-33);
			bullet.y = y;
			bullet.z = z-12;
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
			heromc.play(currentAnim);
		}
		
		public function get grenades():int 
		{
			return _grenades;
		}
		
		public function set grenades(value:int):void 
		{
			_grenades = value;
			dispatchEvent(new Event(EVENT_GRENADES_CHANGED));
		}
		
		public function get bombs():int 
		{
			return _bombs;
		}
		
		public function set bombs(value:int):void 
		{
			_bombs = value;
			dispatchEvent(new Event(EVENT_BOMBS_CHANGED));
		}
		
		
		override public function Hit(dmg:Number):void 
		{
			super.Hit(dmg);
			if (kill)
			{
				if (!_screamed)
				{
					_screamed = true;
					Sounds.Play2DSnd("hero_die",x);
				}
				return;
			}
			Sounds.Play2DSnd("hero_hit", x);
		}
		
		
	}

}