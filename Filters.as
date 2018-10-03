package  {
	import flash.filters.GlowFilter;
    import flash.filters.BitmapFilterQuality;
	
	public class Filters {

		public function Filters() {
			// utility class
		}

		public static function applyOverrides(defaults:Object, overrides:Object):Object{
			var props:Object = new Object();
			for(var key:String in defaults)
			{
				props[key] = overrides.hasOwnProperty(key) ? overrides[key] : defaults[key];
			}
			return props;
			
		}
		public static function getGlowFilter(overrides:Object):GlowFilter{
			// minty green glow
			var defaults:Object = {'color':0xCFF4DD,'opacity':0.8,
									  'blurX':35, 'blurY':35, 'strength':2,
									  'inner':false, 'knockout':false,
									  'quality':BitmapFilterQuality.HIGH};
			var props:Object = Filters.applyOverrides(defaults, overrides);
			return new GlowFilter(props.color, props.opacity, props.blurX, props.blurY, props.strength,
                                  props.quality, props.inner, props.knockout);
		}

	}
	
}
