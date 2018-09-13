package  {
	import flash.events.Event;
	import Scenes;

	public class SceneState {
		// these are all public??
		private var started_fn:Function; // do at beginning (called once)
		private var finished_fn:Function; // do at end before transitioning (called once)
		private var during_fn:Function;
		private var transition_fn:Function; //must return a state or null
		public var sc:Scenes; // can be ref'd by started, finished, or during
		public var state_id:int;

		public function SceneState(state_id:int,
								   started_fn:Function = null,
								   finished_fn:Function = null,
								   transition_fn:Function = null,
								   during_fn:Function = null,
								   scenes_obj:Scenes = null){
			super();
			this.state_id = state_id;
			this.started_fn = started_fn;
			this.finished_fn = finished_fn;
			this.during_fn = during_fn;
			this.sc = scenes_obj;
			// default is don't transition
			var default_transition:Function = function(){ return null; }
			this.transition_fn = transition_fn != null ? transition_fn : default_transition;
		}
		// called by scene upon entering this state
		public function start(){
			if (this.started_fn != null){
				this.started_fn();
			}
		}
		public function transition(){
			var new_state:int = -1;
			if (this.transition_fn != null){
				new_state = transition_fn();
			}
			if (new_state >= 0 && new_state != this.state_id){
				trace('exiting state:' + this.state_id + ' --> ' + new_state);
				if (this.finished_fn != null) this.finished_fn();
			}
			return new_state;
		}
		// called by scene, during
		public function eachFrame(e:Event){
			if (this.during_fn != null){
				this.during_fn();
			}
		}
	}
	
}
