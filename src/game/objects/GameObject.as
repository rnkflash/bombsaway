package game.objects
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import game.Game;
	import game.objects.other.BouncingNumber;
	import game.quadtree.FlxObject;
	/**
	 * ...
	 * @author 
	 */
	public class GameObject extends EventDispatcher
	{
		static public const EVENT_HP_CHANGED:String = "eventHpChanged";

		//debug
		static private const DEBUG:Boolean = false;
		private var footHitBoxSprite:Sprite;
		private var bodyHitBoxSprite:Sprite;
		
		
		//stuff
		public var world:Game;
		private var _collidable:Boolean = true;
		private var _kill:Boolean = false;
		private var _HP:Number = 100;
		protected var _dmgTextColor:uint = 0xFFFFFF;
		protected var _beingHit:Boolean = false;
		public var type:String = "";
		
		//collision stuff
		public var hitBoxFoot:Rectangle = new Rectangle();
		public var hitBoxBody:Rectangle = new Rectangle();
		public var groundCollisionBox:FlxObject = new FlxObject();
		
		//graphics
		public var spriteHolder:Sprite;
		public var shadowHolder:Sprite;
		
		//pos
		public var x:Number = 0;
		public var y:Number = 0;
		public var z:Number = 0;
		public var direction:Boolean = true;
		
		
		public function GameObject() 
		{
			spriteHolder = new Sprite();
			shadowHolder = new Sprite();
			groundCollisionBox.parent = this;
			
		}
		
		public function Die():void
		{
			
		}
		
		public function Init():void
		{
			if (DEBUG)
			{
				var color1:uint = 0x0000FF;
				var color2:uint = 0xFF0000;
				footHitBoxSprite = DrawHitbox(hitBoxFoot, color1, color2); 
				spriteHolder.parent.addChild(footHitBoxSprite);
				
				color1 = 0xFF0000;
				color2 = 0x80FF00;
				bodyHitBoxSprite = DrawHitbox(hitBoxBody, color1, color2); 
				spriteHolder.parent.addChild(bodyHitBoxSprite);
			}
		}
		
		public function Update():void
		{
			//blink when hit
			if (_beingHit)
			{
				var colorTransform:ColorTransform = spriteHolder.transform.colorTransform;
				colorTransform.redOffset = 0;
				colorTransform.blueOffset = 0;
				colorTransform.greenOffset = 0;
				spriteHolder.transform.colorTransform = colorTransform;
				_beingHit = false;
			}
			
			//sync coords
			spriteHolder.x = x;
			spriteHolder.y = y + z;
			shadowHolder.x = x;
			shadowHolder.y = y;
			
			groundCollisionBox.x = x + hitBoxFoot.x;
			groundCollisionBox.y = y + hitBoxFoot.y;
			groundCollisionBox.width = hitBoxFoot.width;
			groundCollisionBox.height = hitBoxFoot.height;
			
			//debug
			if (DEBUG)
			{
				footHitBoxSprite.x = x;
				footHitBoxSprite.y = y;
				
				bodyHitBoxSprite.x = x;
				bodyHitBoxSprite.y = y + z;
			}
			
			
		}
		
		public function Hit(dmg:Number):void
		{
			if (kill) return;
			HP -= dmg;
			_beingHit = true;
			//TweenLite.to(transform.colorTransform, 0.5, { blueOffset:255, redOffset:255, greenOffset:255 } );
			
			var colorTransform:ColorTransform = spriteHolder.transform.colorTransform;
			colorTransform.redOffset = 255;
			colorTransform.blueOffset = 255;
			colorTransform.greenOffset = 255;
			spriteHolder.transform.colorTransform = colorTransform;
			
			var bN:BouncingNumber = new BouncingNumber(String(dmg),_dmgTextColor);
			bN.x = x + hitBoxBody.x + hitBoxBody.width/2;
			bN.y = y ;
			bN.z = z+ hitBoxBody.y + hitBoxBody.height/2;
			world.Add(bN);
			
			if (HP <= 0)
			{
				kill = true;
				Killed();
			}
		}
		
		protected function Killed():void 
		{
			
		}
		
		
		
		
		public function DrawHitbox(hitBox:Rectangle,col1:uint,col2:uint):Sprite
		{
			var debugspr:Sprite = new Sprite();
			debugspr.graphics.lineStyle(1.0, col1);
			debugspr.graphics.beginFill(col2, 0.5);
			//debugspr.graphics.drawRect(groundCollisionBox.x, groundCollisionBox.y, groundCollisionBox.width, groundCollisionBox.height);
			debugspr.graphics.drawRect(hitBox.x, hitBox.y, hitBox.width, hitBox.height);
			debugspr.graphics.endFill();
			return debugspr;
		}
		
		public function InitHitboxesAndMainMovieclip(mainclip:DisplayObject,hitboxMovie:MovieClip):void 
		{
			
			var footMovie:MovieClip = null;
			var bodyMovie:MovieClip = null;
			
			for (var i:int = 0; i < hitboxMovie.numChildren; i++)
			{
				if (hitboxMovie.getChildAt(i) is footHitBox)
					footMovie = hitboxMovie.getChildAt(i) as MovieClip;
				else
				if (hitboxMovie.getChildAt(i) is bodyHitbox)
					bodyMovie = hitboxMovie.getChildAt(i) as MovieClip;
			}
			
			//foot hitbox
			hitBoxFoot.x = footMovie.x;
			hitBoxFoot.y = -footMovie.height/2;
			hitBoxFoot.width = footMovie.width;
			hitBoxFoot.height = footMovie.height;
			
			//body hitbox
			hitBoxBody.x = bodyMovie.x;
			hitBoxBody.y = bodyMovie.y - (footMovie.y + footMovie.height/2);
			hitBoxBody.width = bodyMovie.width;
			hitBoxBody.height = bodyMovie.height;
			
			mainclip.y = - (footMovie.y + footMovie.height/2);
			spriteHolder.addChild(mainclip);
			
		}		
		
		public function Collided(other:GameObject):void
		{
			
		}
		
		public function DoubleCheck(other:GameObject):Boolean
		{
			var x1:Number = x + hitBoxBody.x;
			var x2:Number = x + hitBoxBody.x + hitBoxBody.width;
			var y1:Number = z + hitBoxBody.y;
			var y2:Number = z + hitBoxBody.y + hitBoxBody.height;
			
			var x3:Number = other.x + other.hitBoxBody.x;
			var x4:Number = other.x + other.hitBoxBody.x + other.hitBoxBody.width;
			var y3:Number = other.z + other.hitBoxBody.y;
			var y4:Number = other.z + other.hitBoxBody.y + other.hitBoxBody.height;;
			
			return ((((x1 >= x3 && x1 <= x4) || (x2 >= x3 && x2 <= x4)) && ((y1 >= y3 && y1 <= y4) || (y2 >= y3 && y2 <= y4))) 
			|| (((x3 >= x1 && x3 <= x2) || (x4 >= x1 && x4 <= x2)) && ((y3 >= y1 && y3 <= y2) || (y4 >= y1 && y4 <= y2))));
		}
		
		public function get HP():Number 
		{
			return _HP;
		}
		
		public function set HP(value:Number):void 
		{
			_HP = value;
			dispatchEvent(new Event(EVENT_HP_CHANGED));
		}
		
		public function get kill():Boolean 
		{
			return _kill;
		}
		
		public function set kill(value:Boolean):void 
		{
			_kill = value;
		}
		
		public function get collidable():Boolean 
		{
			return _collidable;
		}
		
		public function set collidable(value:Boolean):void 
		{
			_collidable = value;
			groundCollisionBox.exists = value;
			groundCollisionBox.solid = value;
		}
		
	}

}