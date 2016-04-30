package 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import game.core.Animation;
	import game.core.AnimationLibrary;
	import game.Game;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author 
	 */
	public class Main extends Sprite 
	{
		
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = "";
			
			Sounds.Init();
			
			//caching animations
			var start:int = getTimer();
			AnimationLibrary.AddAnimation("hero_run_fire", new Animation(hero_run_fire));
			AnimationLibrary.AddAnimation("hero_stand", new Animation(hero_stand));
			AnimationLibrary.AddAnimation("hero_run", new Animation(hero_run));
			AnimationLibrary.AddAnimation("hero_run_knife", new Animation(hero_run_knife));
			AnimationLibrary.AddAnimation("hero_stand_fire", new Animation(hero_stand_fire));
			AnimationLibrary.AddAnimation("hero_stand_knife", new Animation(hero_stand_knife));
			
			AnimationLibrary.AddAnimation("spider_clip", new Animation(spider_clip));
			AnimationLibrary.AddAnimation("mine_mc", new Animation(mine_mc));
			
			AnimationLibrary.AddAnimation("zombie_clip", new Animation(zombie_clip));
			
			AnimationLibrary.AddAnimation("grenbonus_mc", new Animation(grenbonus_mc));
			AnimationLibrary.AddAnimation("bombbonus_mc", new Animation(bombbonus_mc));
			AnimationLibrary.AddAnimation("medbonus_mc", new Animation(medbonus_mc));
			
			AnimationLibrary.AddAnimation("bullet_shadow", new Animation(bullet_shadow));
			AnimationLibrary.AddAnimation("bullet1_mc", new Animation(bullet1_mc));
			AnimationLibrary.AddAnimation("bullet1_mc2", new Animation(bullet1_mc2));
			
			AnimationLibrary.AddAnimation("bolter_turret_firing", new Animation(bolter_turret_firing));
			AnimationLibrary.AddAnimation("bolter_turret_standing", new Animation(bolter_turret_standing));
			
			AnimationLibrary.AddAnimation("bomber_mc", new Animation(bomber_mc));
			AnimationLibrary.AddAnimation("bomb_mc", new Animation(bomb_mc));
			
			AnimationLibrary.AddAnimation("mini_explosion", new Animation(mini_explosion));
			AnimationLibrary.AddAnimation("explosion_clip", new Animation(explosion_clip));
			
			
			
			trace("animation caching took",getTimer() - start,"ms");
			
			
			var gm:Game = new Game();
			addChild(gm);
			gm.Init();
			
		}
		
		
	}
	
}