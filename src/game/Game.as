package game
{
	import com.greensock.TweenLite;
	import com.pixelwelders.fx.Earthquake;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import game.background.Background;
	import game.gui.Camera;
	import game.gui.Gui;
	import game.level.Level;
	import game.objects.enemies.Spider;
	import game.objects.enemies.Zombie;
	import game.objects.GameObject;
	import game.objects.heroes.Hero;
	import game.objects.weapons.Mine;
	import game.quadtree.FlxU;
	
	/**
	 * ...
	 * @author 
	 */
	public class Game extends Sprite 
	{
		public var gui:Gui;
		public var gameScreen:Sprite;
		public var camera:Camera;
		public var collisionSystem:CollisionSystem;
		public var hero:Hero;
		private var mInput:Input;
		
		private var mGameObjects:Vector.<GameObject>;
		private var zombieCounter:int = 0;
		private var spiderCounter:int = 0;
		public var background:Background;
		
		private var stats:Statistics;
		
		
		
		public function Game():void 
		{
			
		}
		
		public function Init():void 
		{
			//test
			stats = new Statistics();
			
			stats.StartTimer("Init()");
			
			Sounds.Init();
			
			mInput = new Input(this);
			mGameObjects = new Vector.<GameObject>();
			
			gameScreen = new Sprite();
			camera = new Camera(gameScreen);
			gui = new Gui(this);
			
			
			collisionSystem = new CollisionSystem();
			collisionSystem.Init();
			
			//lame level
			var level:Level = new Level();
			level.levelClips = [new level1()/*,new level1(),new level1(),new level1()*/];
			
			background = new Background(camera);
			background.x = 0;
			background.y = 0;
			background.Load(level.levelClips);
			
			//bounds
			camera.bounds = background.getBounds(background);
			collisionSystem.quadTreeBounds.copyRect(new Rectangle(camera.bounds.x, camera.bounds.y, camera.bounds.width, 480));
			
			hero = new Hero();
			hero.x = 200;
			hero.y = 200;
			//hero.scaleX = hero.scaleY= 55.0/hero.width;
			Add(hero);
			camera.Follow(hero);
			
			addEventListener(Event.ENTER_FRAME, Update);
			
			gui.Init();
			
			//display order
			addChild(gameScreen);
			addChild(gui);
			gameScreen.addChild(background);
			
			//scatter mines
			for (var i:int = 0; i < 10; i++) 
			{
				var mine:Mine = new Mine();
				mine.x = Math.random() * camera.bounds.width;
				mine.y = Math.random() * 480;
				Add(mine);
				
			}
			
			stats.EndTimer("Init()");
			stats.Update();
			addChild(stats);
			
		}
		
		private function Update(e:Event):void 
		{
			stats.EndTimer("FRAME TOTAL");
			stats.StartTimer("UPDATE TOTAL");
			
			//spawn monsters
			//stats.StartTimer("spawn monsters");
			if (zombieCounter++ > 30)
			{
				zombieCounter = 0;
				var zombieGruppe:int = Math.floor(Math.random() * 3);
				for (var k:int = 0; k < zombieGruppe; k++) 
				{
					var zombi:Zombie = new Zombie();
					zombi.x = camera.x + camera.width + 50 + 150* Math.random();;
					zombi.y = 480 * Math.random();
					Add(zombi);
				}
			}
			if (spiderCounter++ > 600)
			{
				
				spiderCounter = 0;
				
				var spiderGruppe:int = Math.floor(Math.random() * 3);
				for (var l:int = 0; l < spiderGruppe; l++)
				{
					var spider:Spider= new Spider();
					spider.x = camera.x -50 - 150* Math.random();
					spider.y = 480 * Math.random();
					Add(spider);
				}
				
			}
			//stats.EndTimer("spawn monsters");
			
			//objects update
			stats.StartTimer("objects update");
			for (var i:int = 0; i < mGameObjects.length; i++) 
			{
				mGameObjects[i].Update();
				
			}
			stats.EndTimer("objects update");
			
			//collisions
			stats.StartTimer("collisions update");
			collisionSystem.update();
			stats.EndTimer("collisions update");
			
			//depth sorting
			stats.StartTimer("depth sorting");
			LameDepthSortingAlgorythm(mGameObjects);
			stats.EndTimer("depth sorting");
			
			
			//kill dead objects
			//stats.StartTimer("kill dead objects");
			for (i = mGameObjects.length-1; i >=0; i--) 
			{
				if (mGameObjects[i].kill)
					{
						Remove(mGameObjects[i]);
					}
			}
			//stats.EndTimer("kill dead objects");
			
			//camera update
			//stats.StartTimer("camera update");
			camera.Update();
			//stats.EndTimer("camera update");
			
			//bg update
			//stats.StartTimer("bg update");
			background.update();
			//stats.EndTimer("bg update");
			
			//mouse and keyboard update
			//stats.StartTimer("mouse and keyboard update");
			Input.update();
			//stats.EndTimer("mouse and keyboard update");
			
			
			//lame statistics update
			stats.EndTimer("UPDATE TOTAL");
			stats.Update();
			
			stats.StartTimer("FRAME TOTAL");
		}
		
		private function LameDepthSortingAlgorythm(gameObjects:Vector.<GameObject>):void 
		{
			//TODO отфильтровать невидимы объекты
			var listOfVisibleObjects:Vector.<GameObject> = gameObjects.slice(0, gameObjects.length);
			
			//sort by Y
			listOfVisibleObjects.sort(SortByY);
			function SortByY(a:GameObject, b:GameObject):Number
			{
				if (a.y == b.y)
				{
					if (a.groundCollisionBox.uid > b.groundCollisionBox.uid)
						return -1;
					else
						return 1;
						
					return 0;
				}
				
				if (a.y > b.y)
					return 1;
				else
					return -1;
			}
			
			//сортировать
			for (var i:int = 0; i < listOfVisibleObjects.length; i++)
			{
				gameScreen.addChild(listOfVisibleObjects[i].spriteHolder);
				gameScreen.addChild(listOfVisibleObjects[i].shadowHolder);
			}
		}
		
		public function Add(gameObject:GameObject):void
		{
			gameObject.world = this;
			mGameObjects.push(gameObject);
			gameScreen.addChild(gameObject.spriteHolder);
			gameScreen.addChild(gameObject.shadowHolder);
			collisionSystem.AddObject(gameObject.groundCollisionBox, gameObject.type);
			gameObject.Init();
		}
		
		
		public function Remove(gameObject:GameObject):void
		{
			gameObject.Die();
			gameObject.world = null;
			mGameObjects.splice(mGameObjects.indexOf(gameObject), 1);
			collisionSystem.RemoveObject(gameObject.groundCollisionBox, gameObject.type);
			gameScreen.removeChild(gameObject.spriteHolder);
			gameScreen.removeChild(gameObject.shadowHolder);
		}	
		
		public function LoadLevel(level:Level):void
		{
			
		}
		
		public function ShakeIt():void
		{
			Earthquake.go(gameScreen,10,0.3);
		}
		
		
	}
	
}