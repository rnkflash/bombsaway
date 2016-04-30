package game.gui
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import game.Game;
	import game.objects.GameObject;
	import game.objects.heroes.Hero;
	/**
	 * ...
	 * @author 
	 */
	public class Gui extends Sprite
	{
		private var bg:MovieClip;
		private var world:Game;
		
		public function Gui(world:Game) 
		{
			this.world = world;
			
			bg = new gui_mc();
			addChild(bg);
			
		}
		
		public function Init():void
		{
			var hero:Hero = world.hero;
			
			OnHeroChange();
			
			hero.addEventListener(GameObject.EVENT_HP_CHANGED, OnHeroChange, false, 0, true);
			hero.addEventListener(Hero.EVENT_GRENADES_CHANGED, OnHeroChange, false, 0, true);
			hero.addEventListener(Hero.EVENT_BOMBS_CHANGED, OnHeroChange, false, 0, true);
		}
		
		private function OnHeroChange(e:Event=null):void 
		{
			bg.hp_text.text = String(world.hero.HP);
			bg.gren_text.text = String(world.hero.grenades);
			bg.bomb_text.text = String(world.hero.bombs);
		}
		
	}

}