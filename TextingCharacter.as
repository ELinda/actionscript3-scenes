package  {
	import flash.events.Event; 
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.geom.Point;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class TextingCharacter extends Character{
		protected var txts:Vector.<TextField> = new Vector.<TextField>();
		protected var words:Vector.<String> = new Vector.<String>();
		protected var center:Point = new Point(0, 0);
		protected var words_index = 0;
		public function TextingCharacter() {
			super();
		}
		protected function getText():Vector.<String>{
			return new Vector.<String>();
		}


		function loadComplete(e:Event):void{
			var array:Array = e.target.data.split(/[\n ]/g);

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
			var fonts:Array = new Array('Times', 'Verdana', 'Chalkboard');
			var txt:TextField = new TextField();
			this.moveToCenter(txt);
			txt.textColor = Math.random() * 0x999999;
			txt.text = text;

			var format1:TextFormat = new TextFormat();
			var font_index:int = Math.floor(Math.random() * fonts.length);
			format1.font = fonts[font_index];
			format1.size = 20;
			txt.setTextFormat(format1);

			txt.autoSize = "center";
			stage.addChild(txt);
			this.txts.push(txt);
		}
		public override function eachFrame(e:Event){
			if (words_index < this.words.length && Math.random() > 0.85 && this.parent != null){
				this.addText(this.words[words_index++]);
				this.play();
			}
			super.eachFrame(e);
		}

	}
	
}
