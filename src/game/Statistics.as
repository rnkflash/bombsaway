package game 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author rnk
	 */
	public class Statistics extends Sprite
	{
		private var timers:Object;
		private var timerResults:Object;
		private var txt:TextField;
		
		public function Statistics() 
		{
			timers = { };
			timerResults = { };
			txt = new TextField();
			txt.width = 500;
			txt.height = 500;
			txt.textColor = 0xFFFFFF;
			addChild(txt);
			txt.mouseEnabled = false;
			txt.selectable = false;
		}
		
		public function StartTimer(timerName:String):void
		{
			timers[timerName] = getTimer();
		}
		
		public function EndTimer(timerName:String):void
		{
			timerResults[timerName] = getTimer() - timers[timerName];
		}
		
		public function Update():void
		{
			var result:String = "";
			for (var name:String in timerResults) 
			{
				result += name + ": " + timerResults[name] + " ms\n";
			}
			txt.text = result;
		}
	}

}