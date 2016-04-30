package game.objects.weapons
{
	import flash.display.MovieClip;
	import game.core.Animation;
	import game.core.AnimationLibrary;
	import game.objects.GameObject;
	/**
	 * ...
	 * @author 
	 */
	public class Bomber extends GameObject 
	{
		static public const XSPEED:Number = 10;
		private var mc:Animation;
		private var _bombTimer:int=0;
		private var _bombsAwayTime:int = 10;
		
		private var bombRunDistance:Number = 800;
		private var dx:Number;
		
		public function Bomber(dir:Boolean=true) 
		{
			this.direction = dir;
			
			mc = AnimationLibrary.GetAnimation("bomber_mc");
			spriteHolder.addChild(mc);
			
			mc.scaleX = direction?1.0: -1.0;
			dx = direction?-XSPEED: XSPEED;
			
			Sounds.Play2DSnd("plane_flyby");
			
		}
		
		override public function Update():void 
		{
			super.Update();
			
			x += dx;
			
			bombRunDistance -= Math.abs(dx);
			
			
			if (_bombTimer++ > _bombsAwayTime && bombRunDistance>0)
			{
				_bombTimer = 0;
				BombsAway();
			}
			
			if (bombRunDistance < 0 && (x<world.camera.x-100 || x>world.camera.x+world.camera.width+100))
			{
				kill = true;
			}
			
		}
		
		private function BombsAway():void 
		{
			var bomb:Bomb = new Bomb();
			bomb.x = x;
			bomb.y = y;
			world.Add(bomb);
		
		}
		
		
	}

}