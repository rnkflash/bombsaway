package game.background
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import game.gui.Camera;
	
	/**
	 * ...
	 * @author 
	 */
	public class Background extends Sprite
	{
		public static const TILE_WIDTH:int = 320;
		public static const TILE_HEIGHT:int = 480;
		
		private var camera:Camera;
		private var tiles:Array;
		private var lastTile:int = -1;
		private var leftTile:int=-1;
		private var rightTile:int=-1;
		private var holes:Sprite;
		
		public function Background(camera:Camera) 
		{
			this.camera = camera;
			
		}
		
		public function Load(levelClips:Array):void
		{
			tiles = [];
			var lastX:int = 0;
			for (var i:int = 0; i < levelClips.length; i++)
			{
				var pieces:Array = TileDecruncher.Decrunch(levelClips[i], TILE_WIDTH, TILE_HEIGHT);
				for (var j:int = 0; j < pieces.length; j++) 
				{
					var tile:Tile = new Tile(pieces[j]);
					tiles.push(tile);
					tile.x = lastX;
					addChild(tile);
					lastX += TILE_WIDTH;
				}
			}
			
		}
		
		public function update():void
		{
			var curTile:int = Math.floor(camera.x / TILE_WIDTH);
			
			if (curTile != lastTile)
			{
				if (curTile >=0 && curTile < tiles.length )
				{
					if (lastTile >=0 && lastTile < tiles.length)
						tiles[lastTile].Hide();
					tiles[curTile].Show();
					tiles[curTile+1].Show();
					tiles[curTile+2].Show();
				}
				
				lastTile = curTile;
			}
			
		}
		
		public function MakeExplosionHole(x:Number, y:Number, power:Number):void
		{
			if (!holes)
			{
				holes = new Sprite();
				addChild(holes);
			}
			
			var expl:MovieClip = new expl_hole();
			expl.scaleX = expl.scaleY = power / 100;
			//expl.x = x;
			//expl.y = y;
			
			//holes.addChild(expl);
			
			var clip:MovieClip = expl;
			var r:Rectangle = clip.getBounds(clip);
			r.width *= clip.scaleX;
			r.height *= clip.scaleY;
			//r.x *= clip.scaleX;
			//r.y *= clip.scaleY;
            var bd:BitmapData = new BitmapData(Math.max(1, r.width), Math.max(1, r.height), true, 0x00000000);
			var m:Matrix = new Matrix();
            m.identity();
            m.translate( -r.x, -r.y);
			m.scale(clip.scaleX,clip.scaleY);
            bd.draw(clip, m);
            
			r.x *= clip.scaleX;
			r.y *= clip.scaleY;
			m.identity();
			m.translate(x+r.x,y+r.y);
            holes.graphics.beginBitmapFill(bd, m);
			holes.graphics.drawRect(x+r.x,y+r.y,r.width,r.height);
			holes.graphics.endFill();
            
			
		}
	}

}