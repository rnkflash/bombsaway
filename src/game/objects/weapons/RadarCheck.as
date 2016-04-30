package game.objects.weapons 
{
	import flash.utils.Dictionary;
	import game.CollisionTypes;
	import game.objects.GameObject;
	/**
	 * ...
	 * @author 
	 */
	public class RadarCheck extends GameObject
	{
		
		private var _hitCounter:int = 0;
		private var victims:Dictionary = new Dictionary(true);
		private var mCallback:Function;
		
		public function RadarCheck(direction:Boolean,callback:Function) 
		{
			this.direction = direction;
			mCallback = callback;
			
			hitBoxBody.width = 600;
			hitBoxBody.height = 120;
			hitBoxBody.x = 0;
			hitBoxBody.y = -hitBoxBody.height/2;
			
			hitBoxFoot = hitBoxBody.clone();
			
			type = CollisionTypes.GROUP_PLAYER_BULLETS;
		}
		
		override public function Collided(other:GameObject):void 
		{
			if (_hitCounter>1) return;
			if (other.type == CollisionTypes.GROUP_ENEMIES && !victims[other])
			{
				
				victims[other] = true;
			}
			
		}		
		
		override public function Update():void 
		{
			super.Update();
			
			_hitCounter++;
			
			kill = true;
			
		}
		
		override public function Die():void 
		{
			super.Die();
			
			var list:Array = [];
			for (var name:* in victims) 
			{
				list.push(name);
			}
			
			mCallback(list);
		}
		
	}

}