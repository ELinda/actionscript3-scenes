package  {
	
	import flash.display.MovieClip;
	import flash.net.NetStream;
	import flash.net.NetConnection;
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.media.Video;

	public class VideoPlayer  extends MovieClip{
		/**
		base class
		override with class that instantiates Video
		*/
		public function VideoPlayer() {
			super();
		}
		public function getStream(client:Object):NetStream{
			var handlers:Object = this.handlers;
			var conn:NetConnection = new NetConnection();
			conn.connect(null);

			var stream:NetStream = new NetStream(conn);
			stream.client = client;
			stream.addEventListener(NetStatusEvent.NET_STATUS, handlers.statusChanged);
			stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, handlers.asyncError);
			
			return stream;
		}
		public function playVideo(video:Video=null, url:String=null):void{
			var stream:NetStream = this.getStream(this);
			if (url){
				stream.play(url);
				trace("playVideo", url);
			}
			if (video){
				video.attachNetStream(stream);
			}
		}


		// onXMPData is required, accessed via stream.client
		public function onXMPData(info:Object): void{
			trace('onXMPData reached');
		}
		// onMetaData is required, accessed via stream.client
		public function onPlayStatus(info:Object): void{
			trace('onPlayStatus reached');
		}
		// onMetaData is required, accessed via stream.client
		public function onMetaData(info:Object): void{
			trace('onMetaData reached');
		}
		
		// this function will be called when the event Netstream.Play.Stop occurs
		public function onStop(info:Object=null): void{
			trace('Event: NetStream.Play.Stop');
		}
		protected var handlers:Object = {
			asyncError: function(event:AsyncErrorEvent):void{
				trace('asyncErrorHandler', event);
			},
			statusChanged: function(event:NetStatusEvent):void{
				var targetStream:NetStream = event.target as NetStream;
				var targetClient:WindowVideo = targetStream.client as WindowVideo;

				var getFileName:Function = function(path:String):String{
					return path ? path.substr(path.lastIndexOf("/")) : "";
				}
				trace('statusChanged event=', event.info.code,
					  '; target-time=', targetStream.time,
					  '; url=', getFileName(targetStream.info.resourceName));
				switch (event.info.code){
					case "NetStream.Play.Stop":
						trace('event.info[time]=', targetStream.time);
						targetClient.onStop();
					case "NetStream.Seek.Complete":
						trace('complete seek to time =', targetStream.time);
					case "NetStream.Play.Start":
						trace('seek -> ', targetStream.time);
					break;
				}
			}
		}
	}
	
}
