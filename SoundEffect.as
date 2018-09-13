package  {
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	

	public class SoundEffect{
		var times_to_play:int = 0;
		var times_played:int = 0;
		var finished_fn:Function;
		var started_fn:Function;
		var play_at_time:int;
		var url:String;
        var channel:SoundChannel;
		var finished_playing:Boolean;
		public function SoundEffect(url:String,
								   started_fn:Function = null,
								   finished_fn:Function = null,
								   times_to_play:int = 1) {
			this.url = url;
			trace('construct url: ' + this.url);
			this.finished_playing = false;
			this.times_to_play = times_to_play;
			this.play_at_time = play_at_time;

			var on_finished_wrapper:Function = function():void{
				this.finished_playing = true;
				times_played += 1;
				if (times_to_play >= times_played){
					play_sound();
					trace('additional: ' + this.url);
				}else if (finished_fn != null){
					finished_fn();
				}
				trace('finished: ' + this.url);
			};
			this.finished_fn = on_finished_wrapper;
			this.started_fn = started_fn;
		}
		
		function onSoundLoaded(event:Event):void 
		{ 
			var localSound:Sound = event.target as Sound;
			var channel = localSound.play();
			trace(this + this.times_played + this.times_to_play);
			if(this.started_fn != null){
				this.started_fn();
				trace('started: ' + this.started_fn)
			}
			channel.addEventListener(Event.SOUND_COMPLETE, this.finished_fn);
		}
		public function perform_all_actions(): void{
			if (!this.url){
				if (this.started_fn != null) this.started_fn();
				if (this.finished_fn != null) this.finished_fn();
				return;
			}else{
				this.play_sound();
			}
		}
		public function reset(): void{
			this.times_played = 0;
		}
		public function play_sound(): void{
			this.times_played += 1;
			var req:URLRequest = new URLRequest(this.url);
			trace('playing: ' + this.url);
			var s:Sound = new Sound(req);
			// this seems unnecessary
			//var loadedFn:Function = new CallBack(this.onSoundLoaded, this, [], s).handler;
			s.addEventListener(Event.COMPLETE, onSoundLoaded);
		}
	}
}
