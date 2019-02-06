package  {
	
	public class ColorUtils {

		public function ColorUtils() {
			// tests
			/* red ff0000
			orange ffff00
			yellow ff00
			green ffff
			blue ff
			purple ff00ff */
			trace('red', ColorUtils.hsv2Hex(0, 1.0, 1.0).toString(16));
			trace('yellow', ColorUtils.hsv2Hex(1.0/6, 1.0, 1.0).toString(16));
			trace('green', ColorUtils.hsv2Hex(1.0/3, 1.0, 1.0).toString(16));
			trace('aqua', ColorUtils.hsv2Hex(1.0/2, 1.0, 1.0).toString(16));
			trace('blue', ColorUtils.hsv2Hex(4.0/6, 1.0, 1.0).toString(16));
			trace('magenta', ColorUtils.hsv2Hex(5.0/6, 1.0, 1.0).toString(16));
		}
		public static function rgb2Hex(r:uint, g:uint, b:uint):uint{
			// red green blue (indiv) -> composite ARGB
			return r << 16 | g << 8 | b;
		}
		public static function hsv2Hex(h:Number=1.0, s:Number=1.0, v:Number=1.0):uint{
			var r:Number, g:Number, b:Number, i:Number, f:Number, p:Number, q:Number, t:Number;
			// normalize h, s, v -> [0, 1]
			if (v == 0) {
				return 0;
			}
			h %= 1.0;
			i = Math.floor(h * 6);
			p = v * (1 - s);
			q = v * (1 - (s * (h * 6 - i)));
			t = v * (1 - (s * (1 + i - h * 6)));
			switch (i){
				case 0: r = v; g = t; b = p; break;
				case 1: r = q; g = v; b = p; break;
				case 2: r = p; g = v; b = t; break;
				case 3: r = p ; g = q; b = v; break;
				case 4: r = t; g = p; b = v; break;
				case 5: r = v; g = p; b = q; break;
			}
			if (h == 1.0){
			trace(i, h, h * 6, i - h * 6, 1 + i - h * 6, t);
			trace(i, r, g, b, rgb2Hex(r * 255, g * 255, b * 255), 1 as uint);
			}
			return rgb2Hex(r * 255, g * 255, b * 255);
		}

	}
	
}
