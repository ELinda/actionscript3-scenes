package  {
	import flash.filters.GlowFilter;
    import flash.filters.BitmapFilterQuality;
    import flash.filters.BevelFilter;
    import flash.filters.DropShadowFilter;
	
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
		public static function getDropShadowFilter(overrides:Object):DropShadowFilter{
			// green highlight and shadow
			var defaults:Object = {'color':0xCCCCCC,'alpha':1.0,'distance':5,
									  'blurX':0, 'blurY':0, 'strength':2,
									  'inner':false, 'knockout':false,
									  'quality':BitmapFilterQuality.HIGH};
			var props:Object = Filters.applyOverrides(defaults, overrides);
			return new DropShadowFilter(props.distance,props.angle, props.color, props.alpha,
									  props.blurX, props.blurY, props.strength, props.quality,
									  props.inner, props.knockout);
										
		}
		public static function getBevelFilter(overrides:Object):BevelFilter{
			// green highlight and shadow
			var defaults:Object = {'shadowColor':0x666600,'highlightColor':0x33ff00,'highlightAlpha':1,
									  'type':'inner', 'blurX':4, 'blurY':4, 'strength':1,
									  'shadowAlpha':1, 'highlighAlpha':1, 'angle':45, 'distance':4,
									  'quality':1};
			var props:Object = Filters.applyOverrides(defaults, overrides);
			return new BevelFilter(props.distance, props.angle, props.highlightColor,
								   props.highlightAlpha, props.shadowColor, props.shadowAlpha,
								   props.blurX, props.blurY, props.strength, props.quality,
								   props.type, props.knockout);
		}
	}
	
}
