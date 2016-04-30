package game.objects.weapons 
{
	import flash.utils.Dictionary;
	import game.CollisionTypes;
	import game.objects.GameObject;
	/**
	 * ...
	 * @author 
	 */
	public class KnifeAttack extends GameObject
	{
		
		private var _hitCounter:int = 0;
		private var victims:Dictionary = new Dictionary(true);
		
		
		public function KnifeAttack(direction:Boolean) 
		{
			this.direction = direction;
			
			hitBoxBody.width = 60;
			hitBoxBody.height = 60;
			hitBoxBody.x = -hitBoxBody.width/2;
			hitBoxBody.y = -hitBoxBody.height/1.5;
			
			hitBoxFoot = hitBoxBody.clone();
			
			type = CollisionTypes.GROUP_PLAYER_BULLETS;
		}
		
		override public function Collided(other:GameObject):void 
		{
			if (_hitCounter>1) return;
			if (other.type == CollisionTypes.GROUP_ENEMIES && !victims[other])
			{
				other.Hit(50+Math.floor(Math.random()*50));
				other.x += direction?5: -5;
				victims[other] = true;
			}
			
		}		
		
		override public function Update():void 
		{
			super.Update();
			
			_hitCounter++;
			
			kill = true;
		}
		
	}

}