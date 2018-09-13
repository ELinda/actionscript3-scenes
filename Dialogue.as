package  {
	import flash.utils.setTimeout;
	import flash.display.MovieClip;
	import CallBack;

	public class Dialogue extends MovieClip {
		private var durations:Vector.<int> = new Vector.<int>();
		private var label2frame:Object = new Object();

		public function Dialogue() {
			// duration sets in millisecs
			var durations_from_0:Vector.<int> = new <int>[0, 0, 0]; // extra 0 for 0-indexed vector
			var durations_from_2:Vector.<int> = new <int>[399, 324, 349 + 329, 414, 429, 419, 364];
			var durations_from_11:Vector.<int> = new <int>[394, 209, 503 + 334, 269, 344, 334, 399];
			var durations_from_21:Vector.<int> = new <int>[394, 843, 384, 453 + 473];
			var durations_from_27:Vector.<int> = new <int>[199, 264, 174, 204, 359];
			// necessary for gotoAndStop calculation to be correct
			// b/c 2 frames between each sentence
			var padding_between:Vector.<int> = new <int>[-1, -1];
			this.durations = durations_from_0.concat(durations_from_2).concat(padding_between)
											 .concat(durations_from_11).concat(padding_between)
											 .concat(durations_from_21).concat(padding_between)
											 .concat(durations_from_27).concat(padding_between);
			// trace('durations', this.durations);

			// for use in playSpeech
			label2frame['house_small'] = 2;
			label2frame['wife_no_longer'] = 11;
			label2frame['every_day_sad'] = 21;
			label2frame['i_do_not_love'] = 27;
		}
		public function playSpeech(speech:String):void{
			// want to use label2frame.hasOwnProperty(speech) for checking or no?
			// first go to frame for the dialogue, then schedule word-by-word progression
			this.gotoAndStop(this.label2frame[speech]);
			this.timedSpeech();
			// trace('playing the speech: ', speech);
		}
		private function timedSpeech():void{
			this.gotoAndStop(this.currentFrame + 1);
			var wait_ms:int = this.durations[this.currentFrame];
			var callback:Function = new CallBack(function(){this.timedSpeech()}, this).handler;
			if (wait_ms >= 0){
				// trace('at frame ', this.currentFrame, ', calling in ', wait_ms);
				setTimeout(callback, wait_ms);
			}else{
				var end:Function = new CallBack(function(){this.gotoAndStop(0);}, this).handler;
				setTimeout(end, 500);
			}
		}
		
	}
	
}
