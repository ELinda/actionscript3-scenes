package  {
	
	public class IntervalAction {
		// start == end means single exection.
		public var start_sec:Number = 0.0;
		public var end_sec:Number = 0.0;
		public var action:Function = null;

		public function IntervalAction(start_sec:Number, end_sec:Number, action:Function) {
			this.start_sec = start_sec;
			this.end_sec = end_sec;
			this.action = action;
		}
	}
	
}
