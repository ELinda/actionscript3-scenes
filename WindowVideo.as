package  {
	import flash.display.MovieClip;
	import flash.media.Video;
	import flash.net.NetStream;
	import streams.StreamInfo;

	public class WindowVideo extends VideoPlayer {
		protected var base_url:String = './';
		private var video:Video = null;
		protected var video_url = null;

		public function WindowVideo(base_url, video_url) {
			super();
			this.base_url = base_url;
			this.video_url = video_url;
			this.video = new Video(280, 190);
			this.video.z = 10;
			this.addChildAt(this.video, 0);
			this.playVideo();
		}

		public override function onStop(info:Object=null): void{
			super.onStop();
			this.playVideo();
		}

		public override function playVideo(video:Video=null, url:String=null):void{
			super.playVideo(this.video, this.base_url + this.video_url);
		}
	}
}
