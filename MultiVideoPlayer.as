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
	
	public class MultiVideoPlayer extends MovieClip {
		protected var video:Video = null;
		private var stream:NetStream;
		
		public var video_urls:Vector.<String> = null;
		private var streams:Vector.<NetStream> = null;
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
				this.streams[i] = this.getStream(this, this.handlers);

				var path:String = base_url + this.video_urls[i];
				this.streams[i].play(path);
				this.streams[i].pause();
			}
		}
		public function playNext(video:Video):void{
			// play the next video
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
		public function getStream(client:Object, handlers:Object):NetStream{
			// todo: can use new netconn below or need connect(null)?
			var conn:NetConnection = new NetConnection();
			conn.connect(null);

			var stream:NetStream = new NetStream(conn);
			stream.client = client;
			stream.addEventListener(NetStatusEvent.NET_STATUS, handlers.statusChanged);
			stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, handlers.asyncError);
			
			return stream;
		}

		// onXMPData is required, accessed via stream.client
		public function onXMPData(info:Object): void{
			trace('onXMPData reached');
			/*for(var s:String in info){
				trace(s, info[s]);
			}*/
		}
		// onMetaData is required, accessed via stream.client
		public function onPlayStatus(info:Object): void{
			trace('onPlayStatus reached');
			/*
			for(var s:String in info){
				trace(s, info[s]);
			}*/
		}
		// onMetaData is required, accessed via stream.client
		public function onMetaData(info:Object): void{
			trace('onMetaData reached');
			/*
			for(var s:String in info){
				trace(s, info[s]);
			}*/
		}
		private var handlers:Object = {
			asyncError: function(event:AsyncErrorEvent):void 
			{
				trace('asyncErrorHandler', event);
			},
			statusChanged: function(event:NetStatusEvent):void{
				var targetStream:NetStream = event.target as NetStream;
				var targetClient:MultiVideoPlayer = targetStream.client as MultiVideoPlayer;

				var getFileName:Function = function(path:String):String{
					return path.substr(path.lastIndexOf("/"));
				}
				trace('statusChanged event=', event.info.code,
					  '; target-time=', targetStream.time,
					  '; url=', getFileName(targetStream.info.resourceName));
				switch (event.info.code){
					case "NetStream.Play.Stop":
						trace('event.info[time]=', targetStream.time);
					case "NetStream.Play.Start":
						trace('seek -> ', targetClient.times[targetClient.video_index]);
					break;
				}
			}
		}
		public function eachFrame(e:Event):void{
		}
	}
	
}
