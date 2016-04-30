package game.objects.bonus
{
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import game.CollisionTypes;
	import game.core.Animation;
	import game.core.AnimationLibrary;
	import game.objects.GameObject;
	import game.objects.heroes.Hero;
	import game.objects.other.BouncingNumber;
	/**
	 * ...
	 * @author 
	 */
	public class GrenadeBonus extends GameObject
	{
		private var mc:Animation;
		private var _lifeTimer:int = 30 * 10;
		private static var hitbox:MovieClip;
		
		public function GrenadeBonus() 
		{
			mc = AnimationLibrary.GetAnimation("grenbonus_mc");
			
			if (!hitbox)
				hitbox = new grenbonus_hitboxes();
			
			
			InitHitboxesAndMainMovieclip(mc, hitbox);
			
			type = CollisionTypes.GROUP_BONUS;
			//DrawHitbox();
		}
		
		override public function Collided(other:GameObject):void 
		{
			if (other is Hero)
			{
				(other as Hero).grenades += 5;
				collidable = false;
				
				Sounds.Play2DSnd("ammobonus",x);
				
				mc.play();
				
				var bN:BouncingNumber = new BouncingNumber("+5 grenades",0xFF00FF);
			bN.x = x + hitBoxBody.x + hitBoxBody.width/2;
			bN.y = y ;
			bN.z = z+ hitBoxBody.y + hitBoxBody.height/2;
				world.Add(bN);
				
			}
		}
		
		override public function Update():void 
		{
			super.Update();
			
			if (mc.currentFrame >= 14)
			{
				mc.stop();
				kill = true;
			}
			if (collidable && _lifeTimer-- < 0)
			{
				kill = true;
			}


			
		}
		
		
		
	}

}