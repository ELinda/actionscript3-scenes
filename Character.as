package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Point;

	public class Character extends MovieClip{
		public var x_velocity:Number = 0;
		public var y_velocity:Number = 0;
		public var angular_velocity:Number = 0;
		public var sizeFactor:Number = 1.0;
		public var sizeRatio:Number = 1.0;
		private var targetWidth:Number = NaN;
		public var TL:Point = new Point(0, 0);
		public var LR:Point = new Point(0, 0);
		public var flip:Boolean = false;

		public function Character() {
			super();
			addEventListener(Event.ENTER_FRAME, eachFrame);
			this.sizeRatio = getCurrentSizeRatio();
			
			// stage info isn't available until added to stage
			if (stage){
				this.addedToStage();
			}else{
				this.addEventListener(Event.ADDED_TO_STAGE, this.addedToStage);
			}
		}
		public function getCurrentSizeRatio():Number{
			return this.height / this.width;
		}
		public function setTargetWidth(targetWidth:Number, sizeFactor:Number=NaN){
			this.targetWidth = targetWidth;
			// fix invalid values to make sense
			if (isNaN(sizeFactor) || sizeFactor == 1.0 
				|| (sizeFactor > 1.0 && this.width < targetWidth)
				|| (sizeFactor < 1.0 && this.width > targetWidth)){
				this.sizeFactor = targetWidth > this.width ? 1.01 : .99;
			}
			trace('setting target width ' + targetWidth + ' from ' + this.width + ' w/ ' + this.sizeFactor);
		}
		protected function addedToStageActions():void{
			// override to do stuff with stage or parent.
		}
		private function addedToStage(e:Event=null):void{
			this.removeEventListener(Event.ADDED_TO_STAGE, this.addedToStage);
			this.LR = new Point(stage.stageWidth, stage.stageHeight);
			this.addedToStageActions();
		}
		private function reachedTargetWidth():Boolean{
			var abs_width:Number = Math.abs(this.width);
			return (abs_width >= this.targetWidth && this.sizeFactor > 1.0) ||
				   (abs_width <= this.targetWidth && this.sizeFactor < 1.0);
		}
		private function flipIfNeeded():void{
			if (this.flip && this.scaleX > 0){
				this.scaleX *= -1;
			}
		}
		private function resetSizeTargetAndGrowthFactor(){
			this.sizeFactor = 1.0;
			trace('reached target width of ' + this.targetWidth + ' setting back to NaN');
			this.targetWidth = NaN;
		}
		protected function updateSize():void{
			if (this.sizeFactor != 1.0){
				this.height *= sizeFactor;
				this.width *= sizeFactor;
				if (Math.abs(getCurrentSizeRatio() - this.sizeRatio) > 0.05){
					this.height = this.width * this.sizeRatio; 
				}
			};
			if (!isNaN(this.targetWidth) && this.reachedTargetWidth()){
				this.resetSizeTargetAndGrowthFactor();
			}
			this.flipIfNeeded();
		}
		public function set_LL(LL:Point):void{
			// set the lower left boundary corner, by manipulating top left and lower right
			this.TL.x = LL.x;
			this.LR.y = LL.y;
		}
		public function moveX(dx:int, x_velocity:Number=0.5):void{
			this.TL = this.LR = new Point(this.x + dx, this.y);
			this.x_velocity = x_velocity;
		}
		public function set_TL_LR(TL:Point, LR:Point):void{
			this.TL = TL;
			this.LR = LR;
			if (TL.x > LR.x || TL.y > LR.y) {
				throw new Error('TL must be less than LR in both dimensions');
			}
		}
		public function moveWithinBounds(){
			// map MovieClip to Point representing velocities, i.e. mc -> Point
			if(this.x < TL.x){
				this.x_velocity = Math.abs(this.x_velocity);
			}
			if(this.x > LR.x){
				this.x_velocity = -1 * Math.abs(this.x_velocity);
			}
			if(this.y < TL.y){
				this.y_velocity = Math.abs(this.y_velocity);
			}
			if(this.y > LR.y){
				this.y_velocity = -1 * Math.abs(this.y_velocity);
			}
			this.x += this.x_velocity;
			this.y += this.y_velocity;
		}
		// apply random color to a movieclip
		function applyRandomColor(mc: MovieClip):void {
			var color:ColorTransform = this.transform.colorTransform;
			color.color = Math.random() * 0xFFFFFF;
			mc.transform.colorTransform = color;
		}
		public function eachFrame(e:Event){
			if (this.sizeFactor != 1.0){
				this.updateSize();
			}
			if (this.angular_velocity != 0.0){
				this.rotation += this.angular_velocity;
			}
			this.moveWithinBounds();
		}
	}
}
