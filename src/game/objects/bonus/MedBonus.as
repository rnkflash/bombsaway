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
	public class MedBonus extends GameObject
	{
		private var mc:Animation;
		
		private var _lifeTimer:int = 30 * 10;
		
		private static var hitbox:MovieClip;
		
		public function MedBonus() 
		{
			mc = AnimationLibrary.GetAnimation("medbonus_mc");
			
			if (!hitbox)
				hitbox = new medbonus_hitboxes();
						
			
			InitHitboxesAndMainMovieclip(mc, hitbox);
			
			type = CollisionTypes.GROUP_BONUS;
			//DrawHitbox();
		}
		
		override public function Init():void 
		{
			super.Init();
		}
		
		override public function Collided(other:GameObject):void 
		{
			if (other is Hero)
			{
				other.HP += 10;
				collidable = false;
				
				Sounds.Play2DSnd("medbonus",x);
				
				mc.play();
				
				var bN:BouncingNumber = new BouncingNumber("+10 hp",0x80FF00);
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
				kill = true;
			}
			
			if (collidable && _lifeTimer-- < 0)
			{
				kill = true;
			}

			
		}
		
		
		
	}

}