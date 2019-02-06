package  {
	import Scenes;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.display.LoaderInfo;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	public class ImageLoader {
		// boilerplate for loading images
		/*
		USAGE
			utility class for loading bitmaps

			var imageLoader:ImageLoader = new ImageLoader();
			var url:String = '/path/to/image.jpg(or any bitmap format)';
			imageLoader.loadImage(url, function(bitmap:Bitmap){ this.addChild(bitmap);... });
		*/
		public var compositeImageLoaded:Function = null;
		public function ImageLoader() {
			super();
		}

		public static function getURLRequest(fileName:String, dir:String):URLRequest{
			return new URLRequest(dir + '/' + fileName);
		}

		public function imageLoadError(e:Event):void {
			// doesn't seem this is invoked
			var info:LoaderInfo = e.target as LoaderInfo;
			trace('error loading image ', info.url);
		}
		public function getImageLoaded(imageLoaded:Function=null, client:ImageLoader=null):Function {
			// imageLoaded -- custom logic handling the bitmap, after it's been loaded.
			// client -- a ImageLoader, only for reference to the return value of this function
			// 			 to clean things up
			return function(e:Event):void{
				var info:LoaderInfo = e.target as LoaderInfo;
				var loader:Loader = info.loader as Loader;
				if (client != null){
					loader.removeEventListener(Event.COMPLETE, client.compositeImageLoaded);
				}
				trace('loaded image ', info.url);
				var bitmap:Bitmap = loader.content as Bitmap;
				if (imageLoaded != null){
					imageLoaded(bitmap);
				}
			}
		}
		public function loadImage(image_url:String,
								  imageLoaded:Function=null):void{
			// main entrypoint
			// see above for usage
			var imageLoadedFn:Function = this.getImageLoaded(imageLoaded, this);
			this.compositeImageLoaded = imageLoadedFn;
			var interval_id:uint = 0;
			var urlRequest:URLRequest = new URLRequest(image_url);
			var loader:Loader = new Loader();
			loader.addEventListener(flash.events.IOErrorEvent.IO_ERROR, imageLoadError);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoadedFn);
			loader.load(urlRequest);
		}
	}
	
}
