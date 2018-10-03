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
		public var thisObj:Scenes;
		private var files_property:String;
		private var images_property:String;
		// boilerplate for loading images
		public function ImageLoader(thisObj:Scenes, files_property:String, images_property:String) {
			super();
			this.thisObj = thisObj;
			this.files_property = files_property;
			this.images_property = images_property;
		}

		public function fileLoaded(e:Event){
			var t:Scenes = this.thisObj;
			var eLoader:URLLoader = e.target as URLLoader;
			eLoader.removeEventListener(Event.COMPLETE, this.fileLoaded);
			var string_contents:String = eLoader.data as String;
			trace('this = ', t, ', e =', e);
			t.properties[this.files_property] = new <String>[];
			for each(var file_name:String in string_contents.split("\n")){
				t.properties[this.files_property].push(file_name);
			}
		}

		public static function getURLRequest(fileName:String, dir:String='.'):URLRequest{
			return new URLRequest(dir + '/' + fileName);
		}

		private function loadFileSetup(dir:String, listFileName:String, loadedFn:Function):void{
			// open dir/listFileName and call loadedFn when contents are ready
			// rely on loadedFn to remove itself from the event listener
			var loader:URLLoader = new URLLoader(getURLRequest(listFileName, dir));

			loader.addEventListener(Event.COMPLETE, loadedFn, false, 0, true);
			return;
		}
		public function imageLoadError(e:Event):void {
			// doesn't seem this is invoked
			var info:LoaderInfo = e.target as LoaderInfo;
			trace('error loading image ', info.url);
		}
		public function imageLoaded(e:Event):void {
			var t:Scenes = this.thisObj;
			var info:LoaderInfo = e.target as LoaderInfo;
			var loader:Loader = info.loader as Loader;
			loader.removeEventListener(Event.COMPLETE, this.imageLoaded);
			//trace('loaded image ', info.url);
			var bitmap:Bitmap = loader.content as Bitmap;
			bitmap.x = Math.random() * this.thisObj.stage.stageWidth;
			bitmap.y = Math.random() * this.thisObj.stage.stageHeight;
			bitmap.width = 40;
			bitmap.height = 40;
			(t.properties[this.images_property] as Vector.<Bitmap>).push(bitmap);
			t.addChild(bitmap);
		}
		public function loadImageList(dir:String, listFileName:String):void{
			// async population of property
			var t:Scenes = this.thisObj;
			this.loadFileSetup(dir, listFileName, this.fileLoaded);
			var files_property:String = this.files_property;
			var images_property:String = this.images_property;
			var interval_id:uint = 0;
			var checkForFiles:Function = function(){
				if (t.properties[files_property] != null){
					trace('this.properties[' + files_property + '] = ', t.properties[files_property]);
					clearInterval(interval_id);
					t.properties[images_property] = new Vector.<Bitmap>();
					for each(var image_url:String in t.properties[files_property]){
						var urlRequest:URLRequest = ImageLoader.getURLRequest(image_url, dir);
						var loader:Loader = new Loader();
						loader.load(urlRequest);
						loader.addEventListener(flash.events.IOErrorEvent.IO_ERROR, imageLoadError);
						loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
					}
				} else {
					trace('this.properties[' + files_property + '] = null');
				}
			};
			interval_id = setInterval(checkForFiles, 1500);
			return;
		}
	}
}
