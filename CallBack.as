package  {
	import flash.events.IEventDispatcher;
	import flash.events.Event;

	class CallBack {
		public var callback:Function;
		public var thisObj:Object;
		public var params:Array;
		public var dispatcher:IEventDispatcher;

		function CallBack(callback:Function, thisObj:Object, 
						  params:Array=null, dispatcher:IEventDispatcher=null)
		{
			this.callback = callback;
			this.thisObj = thisObj;
			this.params = params;
			this.dispatcher = dispatcher;
		}

		public function handler(e:Event=null):void
		{
			// trace('[inside callback]' + this);
			var all_params:Array = [e].concat(params);
			this.callback.apply(thisObj, all_params);
			// clean up
			if (e != null && dispatcher != null){
				dispatcher.removeEventListener(e.type, this.callback);
			}
		}
	}
}
