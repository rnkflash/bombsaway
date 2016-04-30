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
	public class Bomb extends GameObject 
	{
		
		private var mc:Animation;
		private var _lifeTimer:int = 30;
		
		public function Bomb() 
		{
			mc = AnimationLibrary.GetAnimation("bomb_mc");
			spriteHolder.addChild(mc);
			mc.play();
			
		}
		
		override public function Update():void 
		{
			super.Update();
			
			if (kill) return;
			
			if (_lifeTimer-- <= 0)
			{
				kill = true;
				var expl:Explosion = new Explosion();
				expl.x = x;
				expl.y = y;
				world.Add(expl);
			}			
			
		}
		
	}

}