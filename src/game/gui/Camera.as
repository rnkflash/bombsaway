package game.gui 
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import game.objects.GameObject;
	/**
	 * ...
	 * @author 
	 */
	public class Camera 
	{
		
		private var _x:Number = 0;
		private var _y:Number = 0;
		public var width:Number = 640;
		public var height:Number = 480;
		private var _gameScreen:DisplayObject;
		private var _targetGameObject:GameObject;
		private var _targetX:Number = 0;
		
		public var bounds:Rectangle=new Rectangle(0,0,width,height);
		
		
		public function Camera(gameScreen:DisplayObject) 
		{
			_gameScreen = gameScreen;
			
		}
		
		public function Follow(targetGameObject:GameObject):void
		{
			_targetGameObject = targetGameObject;
			
		}
		
		public function Update():void
		{
			if (_targetGameObject)
			{
				if (_targetGameObject.direction && _targetGameObject.x - x > 213)
				{
					_targetX = _targetGameObject.x - 213;
				} else
				if (!_targetGameObject.direction && _targetGameObject.x - x < 426)
				{
					_targetX = _targetGameObject.x - 426;
				}
				
				if (_targetX < bounds.x)
				{
					_targetX = bounds.x;
				}
				if (_targetX > bounds.x+bounds.width-width)
				{
					_targetX = bounds.x+bounds.width-width;
				}
				
			}
			
			if (_targetX != x)
			{
				
				var dx:Number = (_targetX - x) / 10;
				if (Math.abs(dx) < 0.1)
					x = _targetX
				else
					x += dx;
			}
		}
		
		public function GetCameraCoord(gameObject:GameObject):Point
		{
			return new Point(gameObject.x - x, gameObject.y - y);
		}
		
		
		public function get x():Number 
		{
			return _x;
		}
		
		public function set x(value:Number):void 
		{
			_x = value;
			_gameScreen.x = -_x;
		}
		
		public function get y():Number 
		{
			return _y;
		}
		
		public function set y(value:Number):void 
		{
			_y = value;
		}
		
	}

}