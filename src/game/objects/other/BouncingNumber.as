package game.objects.other
{
	import com.greensock.TweenLite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import game.objects.GameObject;
	/**
	 * ...
	 * @author 
	 */
	public class BouncingNumber extends GameObject
	{
		private var YSPEED:Number=2.0;
		private var _lifeTimer:int = 0;
		
		public function BouncingNumber(number:String,color:uint=0xFFFFFF) 
		{
			
			collidable = false;
			var txtField:TextField = new TextField();
			txtField.selectable = false;
			txtField.text = number;
			txtField.textColor = color;
			spriteHolder.addChild(txtField);
			var txtFormat:TextFormat = txtField.getTextFormat();
			txtFormat.font = "hooge 05_55 Cyr2";
			txtField.setTextFormat(txtFormat);
			txtField.embedFonts = true;
			txtField.filters = [new GlowFilter(0x000000)];
			txtField.x = -txtField.textWidth/ 2;
			txtField.y = -txtField.textHeight/ 2;
			
			//TweenLite.to(txtField,1.0,{textColor:0xC0C0C0, onComplete:tweenComplete});
		}
		
		private function tweenComplete():void 
		{
			kill = true;
		}
		
		override public function Update():void 
		{
			super.Update();
			
			z -= YSPEED;
			
			if (_lifeTimer++ > 30)
				kill = true;
			
		}		
		
	}

}