package game.background 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author ...
	 */
	public class TileDecruncher 
	{
		
		public static function Decrunch(movieClip:MovieClip, tileWidth:int = 320, tileHeight:int = 480):Array
		{
			var bounds:Rectangle = movieClip.getRect(movieClip);
			var count:int = Math.floor((bounds.x + bounds.width) / tileWidth);
			var result:Array = [];
			var bmd:BitmapData;
			var mat:Matrix = new Matrix();
			for (var i:int = 0; i < count; i++)
			{
				
				bmd = new BitmapData(tileWidth, tileHeight);
				bmd.draw(movieClip,mat);
				result.push(bmd);
				mat.translate(-tileWidth,0);
			}
			return result;
		}
		
		
	}

}