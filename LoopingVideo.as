package  {
	import flash.display.MovieClip;
	import flash.media.Video;
	import flash.net.NetStream;
	import streams.StreamInfo;

	public class LoopingVideo extends VideoPlayer {
		protected var base_url:String = './';
		private var video:Video = null;
		protected var video_url = null;

		public function LoopingVideo(base_url, video_url) {
			super();
			this.base_url = base_url;
			this.video_url = video_url;
			this.video = new Video();
			this.video.z = 10;
			this.addChildAt(this.video, 0);
			this.playVideo();
		}

		public override function onStop(info:Object=null): void{
			super.onStop();
			this.playVideo();
		}

		public function playVideo():void{
			var stream:NetStream = this.getStream(this);
			var whole_url:String  = this.base_url + this.video_url;
			stream.play(whole_url);
			trace("playVideo", whole_url);
			this.video.attachNetStream(stream);
		}
	}
}
