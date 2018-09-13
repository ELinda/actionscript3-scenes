package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import CallBack;
	import IntervalAction;
	import SceneState;
	
	
	public class Scenes extends MovieClip {
		private var targetX:Number = -1;
		private var targetY:Number = -1;
		private var moving:Boolean = false;
		private var interval_actions:Vector.<IntervalAction> = new Vector.<IntervalAction>();
		private var frame_to_actions:Vector.<Vector.<Function>> = null; // initialized later
		private var frame_secs:Number;
		public var current:int = 0;
		private var MAX_FRAMES:int;

		public function Scenes() {
			// ten seconds
			this.MAX_FRAMES = 10 * stage.frameRate;
			
			// seconds in a frame
			this.frame_secs = 1.0 / stage.frameRate;

			this.interval_actions = this.getIntervalActions();
			this.initializeFrame2Family();
			this.populateFrame2Family();

			addEventListener(Event.ENTER_FRAME, eachFrame);
		}
		
		function callback(fn:Function): Function{
			return new CallBack(fn, this).handler;
		}
		// this can be overrideable
		protected function getIntervalActions(): Vector.<IntervalAction>{
			return new <IntervalAction>[
			];
		}
		private function initializeFrame2Family(): void{
			// call before populateFrame2Family
			// prepopulate the frame to action mapping with empty function vectors
			this.frame_to_actions = new Vector.<Vector.<Function>>(this.MAX_FRAMES);
			
			for (var frame_i:int=0; frame_i <= this.MAX_FRAMES; ++frame_i){
				this.frame_to_actions[frame_i] = new <Function>[];
			}
		}
		private function populateFrame2Family(): void{
			// first call initializeFrame2Family
			// populate the frame to action mapping with contents of interval_actions
			for each(var ia:IntervalAction in this.interval_actions){
				var start_frame:int = Math.ceil(ia.start_sec * stage.frameRate);
				var end_frame:int = Math.ceil(ia.end_sec * stage.frameRate);
				for (var frame_i:int=start_frame; frame_i <= end_frame; ++frame_i){
					this.frame_to_actions[frame_i].push(ia.action);
				}
			}
		}
		
		public function doLater(fn:Function, obj:Object, wait_ms:int){
			var callback:Function = new CallBack(fn, obj).handler;
			setTimeout(callback, wait_ms);
			trace('will do ' + fn + ' in ' + wait_ms + ' ms ');
		}
		private function setTargetXY(targetX:int, targetY:int){
			this.targetX = targetX;
			this.targetY = targetY;
			if (this.targetX != this.x || this.targetY != this.y){
				trace('moving');
				this.moving = true;
			}
		}
		public function eachFrame(e:Event){
			if (this.frame_to_actions[current].length > 0){
				for each(var fun:Function in this.frame_to_actions[current]){
					fun();
				}
			}
			current += 1;
			if (current >= this.frame_to_actions.length - 1){
				this.removeEventListener(Event.ENTER_FRAME, eachFrame);
			}
			
		}
	}
	
}
