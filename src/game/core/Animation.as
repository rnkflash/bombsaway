package game.core  
{
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author rnk
	 */
	public class Animation extends Sprite
	{
		private var cachedMovieclip:CachedMovieclip;
		public var currentFrame:int = 1;
		private var _animation_class:Class;
		private var _scale:Number;
		public var isPlaying:Boolean=false;
		
		public function Animation(animation_class:Class, scale:Number = 1.0 ) 
		{
			super();
			_scale = scale;
			_animation_class = animation_class;
			cachedMovieclip = CachedMovieclip.getClip(animation_class, scale);
			addChild(cachedMovieclip);
			
		}
		
		public function play(startingFrame:int=1):void
		{
			isPlaying = true;
			currentFrame = startingFrame;
			addEventListener(Event.ENTER_FRAME, OnEnterFrame, false, 0, true);
		}
		
		public function stop(stopFrame:int = 0):void
		{
			isPlaying = false;
			removeEventListener(Event.ENTER_FRAME, OnEnterFrame);
			if (stopFrame > 0)
			{
				currentFrame = stopFrame;
				cachedMovieclip.gotoAndStop(currentFrame);
			}
		}
		
		private function OnEnterFrame(e:Event):void 
		{
			cachedMovieclip.gotoAndStop(currentFrame);
			if (++currentFrame > cachedMovieclip.totalFrames)
			{
				currentFrame = 1;
			}
			
		}
		
		public function get totalFrames():int 
		{
			return cachedMovieclip.totalFrames;
		}
		

		
		
		public function clone():Animation
		{
			return new Animation(_animation_class, _scale);
		}
	}

}