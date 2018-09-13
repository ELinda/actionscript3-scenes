package  {
	import Scenes;
	public class MeowScenes extends Scenes{
		public function MeowScenes() {
			super();
		}
		private function getIntervalActions(): Vector.<IntervalAction>{
			var ia1:IntervalAction = new IntervalAction(.5, .5, this.cat1.startWalk);
			return new <IntervalAction>[
				ia1
			];
		}
	}
}