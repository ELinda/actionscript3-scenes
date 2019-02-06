package  {
	import flash.events.Event; 
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.geom.Point;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import Filters;
	import flash.net.URLRequest;
	
	public class TextingCharacter extends Character{
		protected var txts:Vector.<TextField> = new Vector.<TextField>();
		protected var words:Vector.<String> = new Vector.<String>();
		protected var center:Point = new Point(0, 0);
		protected var split_pattern:RegExp = /[\n ]/g;
		protected var words_index:int = 0;
		protected var text_color:uint = 0xFF00FF;
		protected var font_size:uint = 30;
		// rate in (0, 1] dictates how often words are added
		protected var rate:Number = 0.45;
		public function TextingCharacter() {
			super();
		}
		protected function getText():Vector.<String>{
			return new Vector.<String>();
		}


		function loadComplete(e:Event):void{
			var array:Array = e.target.data.split(this.split_pattern);

			this.words.push.apply(null, array);
		}

		protected function getTextFromFile(fileName:String):void{
			var loader:URLLoader = new URLLoader(new URLRequest(fileName));
			var array:Array = new Array();
			var result:Vector.<String> = new Vector.<String>();

			loader.addEventListener(Event.COMPLETE, loadComplete, false, 0, true);
		}
		private function moveToCenter(txt:TextField){
			txt.x = this.center.x;
			txt.y = this.center.y;
		}
		
		public function addText(text:String):void{
			var fonts:Array = new Array('Verdana'); //, 'Verdana', 'Chalkboard')
			var txt:TextField = new TextField();
			this.moveToCenter(txt);
			txt.textColor = this.text_color; //Math.random() * 0x999999;
			txt.text = text;

			var format1:TextFormat = new TextFormat();
			var font_index:int = Math.floor(Math.random() * fonts.length);
			format1.font = fonts[font_index];
			format1.size = this.font_size;
			txt.setTextFormat(format1);
			txt.filters = [ Filters.getDropShadowFilter({'strength':4}) ];

			txt.autoSize = "center";
			stage.addChild(txt);
			this.txts.push(txt);
		}
		public override function eachFrame(e:Event){
			if (this.words_index < this.words.length
				&& Math.random() <= this.rate
				&& this.parent != null){
				this.addText(this.words[this.words_index++]);
			} else if (this.words_index >= this.words.length){
				this.words_index = 0;
			}
			super.eachFrame(e);
		}

	}
	
}
