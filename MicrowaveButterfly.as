package  {
	
	import flash.display.MovieClip;
	import flash.utils.getTimer;
	import flash.events.Event;
	import TalkingCharacter;
	
	public class MicrowaveButterfly extends TalkingCharacter {
		// defaults are based on the size of the scene panel (parent)
		private var center_x:int = 1200;
		private var center_y:int = 400;
		public var fluttering:Boolean = false;
		public function MicrowaveButterfly() {
			super();
		}
		public function updateCenterXY(center_x:int, center_y:int){
			this.center_x = center_x;
			this.center_y = center_y;
		}
		public override function eachFrame(e:Event){
			super.eachFrame(e);
			var mseconds:int = getTimer();
			var r:int = 140;
			if (!this.fluttering){
				this.flutter();
			}
			this.x = r * Math.cos(mseconds / 7000.0) + this.center_x;
			this.y = r * Math.sin(mseconds / 10000.0) + this.center_y;
			
			if (this.isTalking()){
				var avg_mag:Number = getOwnAverageMagnitude();
				this.gotoAndPlay(Math.ceil(Math.pow(avg_mag, .0625) * 10));
			}
		}
		public function stop_flutter(){
			this.gotoAndStop(1);
			this.fluttering = false;
		}
		public function flutter(){
			this.gotoAndPlay(2);
			this.fluttering = true;
		}
	}
	
}
