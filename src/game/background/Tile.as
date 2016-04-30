package game.background 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author ...
	 */
	public class Tile extends Bitmap
	{
		private var bmd:BitmapData;
		
		public function Tile(bmd:BitmapData) 
		{
			this.bmd = bmd;
			
		}
		
		public function Show():void
		{
			bitmapData = bmd;
		}
		
		public function Hide():void
		{
			bmd = bitmapData;
			bitmapData = null;
		}
		
	}

}