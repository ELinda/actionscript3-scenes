package  {
	import flash.events.Event; 
	import flash.media.Sound; 
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	import flash.utils.getTimer;

	import CallBack;
	import Character;
	import flash.display.Graphics;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class TalkingCharacter extends Character {
		protected var bytes:ByteArray = new ByteArray();
		protected var sounds_to_play:Vector.<Sound> = new Vector.<Sound>();
		private var playing_sound:Sound = null;
		private var playing_bytes:ByteArray = new ByteArray();
		private var playing_channel:SoundChannel = null;
		public var played_urls:Array = new Array();
		private var annotations:Vector.<TextField> = new Vector.<TextField>();
		// per documentation, sample rate is 44100 no matter which file loaded
		const SAMPLE_RATE:int = 44100;
		
		public function TalkingCharacter() {
			// saying more
			super();
		}
		public function talkLater(url:String, wait_ms:int){
			var callback:Function = new CallBack(function(){ this.talk(url); }, this).handler;
			setTimeout(callback, wait_ms);
			trace('will say ' + url + ' in ' + wait_ms + ' ms ');
		}
		public function talk(url:String):void{
			// if already talking, then wait until current item is done
			// otherwise, speak now
			var snd:Sound = new Sound();
			var req:URLRequest = new URLRequest(url); 
			snd.load(req);
			snd.addEventListener(Event.COMPLETE, onSoundLoaded);
		}
		public function getOwnAverageMagnitude():Number{
			// sounds the character is supposedly making, 0 if not yet loaded.
			var msecs_in:Number = this.playing_channel.position as Number;
			//trace('msecs_in = ', msecs_in);
			// TDOO update the extract to occur on the fly?? i.e. extract fewer bytes than possible
			// each time except the last time, in chunks
			this.playing_bytes.position = msecs_in / 1000 * this.SAMPLE_RATE;
			
			// read in one second
			var avg_mag:Number = 0;
			var segment_len:int = this.SAMPLE_RATE / stage.frameRate;
			for (var rel_pos:int=0; rel_pos < segment_len; ++rel_pos){
				var left_chan:Number = this.playing_bytes.readFloat();
				var right_chan:Number = this.playing_bytes.readFloat();
				avg_mag += Math.abs(left_chan) + Math.abs(right_chan);
			}
			avg_mag /= segment_len * 2;
			//trace('avg_mag is ' + avg_mag + ' with seglen='+ segment_len);
			return avg_mag;
		}
		public function initializeAnnotations(initialSize:int=512):void{
			// default format: 
			var format1:TextFormat = new TextFormat();
			format1.font = 'Chalkboard';
			format1.size = 10;

			this.annotations = new Vector.<TextField>(initialSize);
			for (var i:int=0; i < this.annotations.length; ++i){
				this.annotations[i] = new TextField(); // empty text box
				this.annotations[i].textColor = 0xFFFFFF;
				
				this.annotations[i].setTextFormat(format1);
				this.annotations[i].autoSize = 'center';
				
				this.addChild(this.annotations[i]);
			}
		}
		// todo:separate into 2 funcs possibly put this in a new class
		public function getSpectrum():Number{
			const PLOT_HEIGHT:int = 200;
			const CHANNEL_LENGTH:int = 256;
			const DX:int = 5;
			
			// annotations should match
			if (this.annotations.length != CHANNEL_LENGTH * 2){
				this.initializeAnnotations(CHANNEL_LENGTH * 2);
			}
			// 256 bytes of data sampled at 44.1 KHz, with DFT performed
			SoundMixer.computeSpectrum(this.bytes, true, 0);
			var g:Graphics = this.graphics;
			//left channel
			g.clear();
			g.lineStyle(0, 0x6600CC);
			
			// todo: move initializations out of four loop??
			// how to measure perf?
			for (var i:int = 0; i < CHANNEL_LENGTH; i++) {
				var read_float:Number = bytes.readFloat();
                var n:Number = read_float * PLOT_HEIGHT;
                g.lineTo(i * DX, PLOT_HEIGHT - n);
				var tf:TextField = this.annotations[i] as TextField;
				tf.text = read_float.toPrecision(3);
				tf.x = i * DX; tf.y = PLOT_HEIGHT - n;
            }
			g.lineTo(CHANNEL_LENGTH * 2, PLOT_HEIGHT);
			
            g.endFill();
            g.lineStyle(0, 0x00FF00);
			
            g.beginFill(0x00FF00, 0.5);
            g.moveTo(CHANNEL_LENGTH * 2, PLOT_HEIGHT);
            
            for (i = CHANNEL_LENGTH; i < CHANNEL_LENGTH * 2; ++i) {
                n = (bytes.readFloat() * PLOT_HEIGHT);
                g.lineTo(i * DX, PLOT_HEIGHT - n);
            }
  
            g.lineTo(0, PLOT_HEIGHT);
            g.endFill();
			return this.bytes.length;
		}
		public function getAverageMagnitude():Number{
			// the combination of all sounds currently happening
			SoundMixer.computeSpectrum(this.bytes, false, 0);
			// left channel
			var sum:Number = 0;
			for (var i:int = 0; i < bytes.length; i+=10){
				sum += Math.abs(bytes.readFloat());
			}
			return sum / this.bytes.length;
		}

		public function isTalking():Boolean{
			return this.playing_sound != null;
		}
		protected function onSoundLoaded(event:Event, finished_fn:Function = null):void 
		{
			// add to queue
			var sound:Sound = event.currentTarget as Sound;
			this.sounds_to_play.push(sound);
			// load sound data into class variable. Reset position to beginning
			sound.extract(this.playing_bytes, getNumBytes(sound));
			this.playing_bytes.position = 0;
		}
		protected function onPlaybackComplete(event:Event):void
		{
			this.played_urls.push(this.getFileFromPath(this.playing_sound.url));
			trace('already played? = ' + alreadyPlayed(this.playing_sound.url));
			trace('this.played_urls = ' + this.played_urls.toString());
			this.playing_sound = null;
		}
		private function getFileFromPath(url:String):String{
			return url.slice(url.lastIndexOf('/') + 1);
		}
		private function getNumBytes(sound:Sound):int{
			var bytes:int = Math.floor((sound.length as Number) / 1000 * this.SAMPLE_RATE * 2);
			trace('bytes in ' + sound.url + ' = ' + bytes);
			return bytes;
		}
		private function playNextSound():Sound{
			// enlist the earliest added unplayed sound. Return its URL
			var nextSound:Sound = this.sounds_to_play.shift();
			this.playing_sound = nextSound;
			this.playing_channel = nextSound.play();

			// add event for when sound completes
			this.playing_channel.addEventListener(Event.SOUND_COMPLETE, onPlaybackComplete);

			return nextSound;
		}
		public function alreadyPlayed(url:String, times:int=1):Boolean{
			var counter:int = 0;
			//trace(this.played_urls.toString() + ' checking for ' + url);
			for each(var played_url:String in this.played_urls){
				counter += played_url == url ? 1 : 0;
				if (counter >= times){
					return true;
				}
			}
			return false;
		}
		public override function eachFrame(e:Event){
			if (this.playing_sound == null && this.sounds_to_play.length > 0){
				playNextSound();
			}
			super.eachFrame(e);
		}
	}
	
}
