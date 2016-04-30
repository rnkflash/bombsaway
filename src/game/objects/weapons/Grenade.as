package game.objects.weapons
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import game.core.Animation;
	import game.core.AnimationLibrary;
	import game.objects.GameObject;
	/**
	 * ...
	 * @author 
	 */
	public class Grenade extends GameObject
	{
		
		private var _gravity:Number = 35.0;
		private var _power:Number = 15.0;
		private var _vel:Point = new Point();
		private var _detonatey:Number = 0;
		private var mc:Animation;
		private var _detonatorSet:Boolean=false;
		private var _rotSpeed:Number = 20.0;;
		
		
		public function Grenade(direction:Boolean=true) 
		{
			this.direction = direction;
			mc = AnimationLibrary.GetAnimation("grenbonus_mc");
			
			
			spriteHolder.addChild(mc);
			
			hitBoxFoot.width = 12;
			hitBoxFoot.height = 12;
			hitBoxFoot.x= - hitBoxFoot.width / 2;
			hitBoxFoot.y = -hitBoxFoot.height / 2;
			hitBoxBody = hitBoxFoot.clone();
			
			var _angle:Number = direction?(-Math.PI / 4):(-3*Math.PI / 4);
			_vel.x = Math.cos(_angle) * _power;
			_vel.y = Math.sin(_angle) * _power;
			
			
			//shadow
			var shadow:Animation = AnimationLibrary.GetAnimation("bullet_shadow");
			shadowHolder.addChild(shadow);
		}
		
		override public function Update():void 
		{
			if (!_detonatorSet)
			{
				_detonatorSet = true;
				_detonatey = 0;
			}
			
			super.Update();
			
			mc.rotation += _rotSpeed;
			
			x += _vel.x;
			z += _vel.y;
			
			_vel.y += _gravity / 30.0;
			
			if (z > _detonatey)
			{
				z = _detonatey;
				Boom();
			}
			
		}
		
		private function Boom():void 
		{
			if (kill) return;
			
			
			var expl:Explosion = new Explosion();
			expl.x = x;
			expl.y = y;
			expl.z = z;
			world.Add(expl);
			
			kill = true;
		}
		
	}

}