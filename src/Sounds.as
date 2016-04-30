// Управление пространственными звуками в игре
package  {
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	public class Sounds extends Object {
		static public const MAX_SOUND_CHANNELS:int=16;
		private static var snd:Object;	// хэш со звуками
		
		private static var streams:Array;
		

		public static function Init():void 
		{
			streams = [];
			// создадим все звуки
			snd = new Object();
			snd['bomb_explosion'] = new bomb_explosion();
			snd['shoot'] = new shoot_snd();
			snd['hero_hit'] = new hero_hit();
			snd['hero_die'] = new hero_die();
			snd['plane_flyby'] = new plane_snd();
			snd['monster_die'] = new monster_die_snd();
			
			snd['ammobonus'] = new ammobonus_snd();
			snd['monster_hit'] = new monster_hit_snd();
			snd['medbonus'] = new medbonus_snd();
			snd['knife_attack'] = new knife_snd();
			
			// вычислим примерный радиус (в квадрате) видимой области экрана
			
		}

		// Воспроизводит звук с учетом пространства
		// (dx,dy - смещение источника звука относительно центра экрана)
		// dv - множитель для громкости
		public static function Play2DSnd(snd_name:String, pan:Number=1.0):void {
			var t:SoundTransform, v:Vector;
			
			t = new SoundTransform();
			// Ставим громкость в зависимости от расстояния
			// Делаем так, чтобы громкость в углу экрана (stageRadius) была 50% от общей
			
			// стерео в зависимости от угла до источника звука
			//t.pan = -0.5 + dx / 640;
			
			// воспроизводим
			streams.push(snd[snd_name].play(0, 0, t));
			
			if (streams.length > MAX_SOUND_CHANNELS)
			{
				(streams.shift() as SoundChannel).stop();
			}
		}
	}
}
