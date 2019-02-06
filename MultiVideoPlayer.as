package  {
	import flash.display.MovieClip;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.events.AsyncErrorEvent;
	import flash.media.Video;
	import flash.events.NetStatusEvent;
	import flash.utils.setTimeout;
	import flash.events.Event;
	import flash.media.SoundTransform;
	
	public class MultiVideoPlayer extends VideoPlayer {
		protected var video:Video = null;
		private var stream:NetStream;
		
		public var video_urls:Vector.<String> = null;
		protected var streams:Vector.<NetStream> = null;
		public var times:Vector.<Number> = null;
		public var total_times:Vector.<Number> = null;
		public var video_index = 0;
		public var sound_transform:SoundTransform = new SoundTransform(0.01);

		public function MultiVideoPlayer() {
			this.initializeVectors(this.getBaseUrl());
			this.video = this.getVideo();
			this.addChildAt(this.video, 0);
			this.playNext(this.video);
			addEventListener(Event.ENTER_FRAME, eachFrame);
		}
		
		public function setVolume(volume:Number):void{
			this.sound_transform.volume = volume;
		}
		
		public function getBaseUrl():String{
			return './';
		}
		protected function getVideo():Video{
			// return the video object if it exists. If not, then return a new video
			if (this.video != null){
				return this.video;
			} else {
				var width:int = stage.stageWidth,
					height:int = stage.stageHeight;
				var video:Video = new Video(width, height);
				return video;
			}
		}
		protected function getVideoURLs():Vector.<String>{
			return new <String>[];
		}
		public function initializeVectors(base_url:String):void{
			// assign times, streams, and total_times
			this.video_urls = this.getVideoURLs();
			this.streams = new Vector.<NetStream>(this.video_urls.length);
			this.times = new Vector.<Number>(this.video_urls.length);
			this.total_times = new Vector.<Number>(this.video_urls.length);

			for(var i:int = 0; i < this.video_urls.length; ++i){
				this.times[i] = this.total_times[i] = 0.0;
				this.streams[i] = this.getStream(this);

				var path:String = base_url + this.video_urls[i];
				trace(path);
				this.streams[i].play(path);
				this.streams[i].pause();
			}
		}
		public function playNext(video:Video):void{
			// play the next video
			if (this.streams.length <= this.video_index){
				trace('no video, exiting');
				return;
			}
			this.streams[this.video_index].pause();
			this.video_index = (this.video_index + 1) % (this.video_urls.length);
			
			// resume the video
			var stream:NetStream = this.streams[this.video_index];
			stream.soundTransform = this.sound_transform;
			stream.resume();
			video.attachNetStream(stream);
			//this.times[this.video_index] = this.stream.time;
			trace('stream.time', stream.time);

			// do it again in a random interval
			var nextPlayNext:Function = function(){
				playNext(video);
			}
			setTimeout(nextPlayNext, Math.floor(Math.random() * 600 + 50));
		}
		public function eachFrame(e:Event):void{
		}
	}
	
}
