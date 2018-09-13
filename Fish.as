package  {
	import flash.events.Event; 
	import flash.geom.Point;
	import flash.display.MovieClip;

	import Character;

	public class Fish extends Character{
		public function Fish() {
			super();
		}
		public function fixOrientation(){
			if (this.x_velocity > 0){
				this.scaleX = -1.0;
			}else{
				this.scaleX = 1.0;
			}
		}
		public function moveWithinOtherElement(other:MovieClip):void{
			var other_TL:Point = new Point(other.x, other.y);
			var other_LR:Point = new Point(other.x + other.width, other.y + other.height);
			this.set_TL_LR(other_TL, other_LR);
			this.x_velocity = Math.random() * 1.0 - 0.5;
			this.y_velocity = Math.random() * 1.0 - 0.5;
		}
		public override function eachFrame(e:Event){
			this.fixOrientation();
			super.eachFrame(e);
		}
	}
	
}
