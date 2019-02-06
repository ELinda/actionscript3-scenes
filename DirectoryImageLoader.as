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

	public class DirectoryImageLoader extends ImageLoader{
		public var thisObj:Scenes;
		private var files_property:String;
		private var images_property:String;
		// boilerplate for loading images
		/*
		USAGE
			// e.g. from within a Scenes object (i.e. "this" refers to a scene) 
			var dir:String = '/path/to/png_or_other_bitmaps';
			// any file name containing '\n' separated list of other file names
			var list_file:String = 'bitmaps_list.txt';
			// in this example, files_property and images_property are strings, keys for "properties" dictionary
			// which is defined in Scenes base class
			var imageLoader:ImageLoader = new ImageLoader(this, this.files_property, this.images_property);
			// after this is called, this.properties[this.files_property] contains a list of bitmap files loaded
			// and this.images_property contains the objects dictated by imageLoaded
			// a third argument can be supplied to the invocation, e.g. this.customImageLoaded
			imageLoader.loadImageList(dir, list_file);
		*/
		public function ImageLoader(thisObj:Scenes, files_property:String, images_property:String) {
			super();
			this.thisObj = thisObj;
			this.files_property = files_property;
			this.images_property = images_property;
		}

		public function fileLoaded(e:Event){
			// load a file with names of other files into "thisObj" specified attribute
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

		private function loadFileSetup(dir:String, listFileName:String, loadedFn:Function):void{
			// open dir/listFileName and call loadedFn when contents are ready
			// rely on loadedFn to remove itself from the event listener
			var loader:URLLoader = new URLLoader(getURLRequest(listFileName, dir));
			
			loader.addEventListener(Event.COMPLETE, loadedFn, false, 0, true);
			return;
		}
		public function defaultImageLoaded(e:Event):void {
			var t:Scenes = this.thisObj;
			var info:LoaderInfo = e.target as LoaderInfo;
			var loader:Loader = info.loader as Loader;
			loader.removeEventListener(Event.COMPLETE, this.defaultImageLoaded);
			//trace('loaded image ', info.url);
			var bitmap:Bitmap = loader.content as Bitmap;
			bitmap.x = Math.random() * this.thisObj.stage.stageWidth;
			bitmap.y = Math.random() * this.thisObj.stage.stageHeight;
			bitmap.width = 40;
			bitmap.height = 40;
			(t.properties[this.images_property] as Vector.<Bitmap>).push(bitmap);
			//t.addChild(bitmap);
		}
		public function loadImageList(dir:String, listFileName:String,
									  imageLoaded:Function=null):void{
			// main entrypoint
			// see above for usage
			if (imageLoaded == null) imageLoaded = this.defaultImageLoaded;
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
						var urlRequest:URLRequest = this.getURLRequest(image_url, dir);
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
