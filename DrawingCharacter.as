package  {
	import TalkingCharacter;
	import flash.media.SoundMixer;
	import flash.display.BlendMode;
	import flash.utils.ByteArray;

	import CallBack;
	import flash.display.Graphics;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class DrawingCharacter extends TalkingCharacter{
		private var annotations:Vector.<TextField> = new Vector.<TextField>();
		// this type draws based on what it says (talks)
		public function DrawingCharacter() {
			super();
		}

		protected function plotLineGraph(bytes:ByteArray, bytes_length:int, i_0:int, g:Graphics,
									   plot_height:int, x_0:int, dx:int,
								       annotations:Vector.<TextField>):int{
			// helper function
			/** bytes: data to plot, bytes_length: length of bytes,
				annotations: textfields to use to display values being plotted**/
			var plot_y:Number, plot_x:Number, read_float:Number;
			var i:int = i_0, max_nonzero_i:int = i_0;

			for (var encountered_0:int = 0; i < i_0 + bytes_length; i++) {
				read_float = bytes.readFloat();

				plot_x = x_0 + (i - i_0) * dx;
				plot_y = (1 - read_float) * plot_height;

				g.lineTo(plot_x, plot_y);

				var tf:TextField = annotations[i] as TextField;
				if (read_float == 0){
					encountered_0 += 1;
					tf.text = '.'
				} else {
					tf.text = read_float.toPrecision(3);
					tf.scaleX = tf.scaleY = read_float * 10;
					encountered_0 = 0;
				}
				if (encountered_0 == 3 && max_nonzero_i == 0){
					max_nonzero_i = i;
					trace('setting max_nonzero_i', i);
				}
				tf.x = plot_x;
				tf.y = plot_y;
			}
			return max_nonzero_i;
		}
		public function drawBytes(plot_height:int=400, dx:int=2,
								  channel_length:int=256):int{
			// annotations should match length of bytes
			if (this.annotations.length != channel_length * 2){
				this.initializeAnnotations(channel_length * 2);
			}
			var g:Graphics = this.graphics;
			// left channel
			g.clear();
			g.lineStyle(0, 0xCC3366);
			g.moveTo(0, plot_height);
			var g_x:int = 0, max_nonzero_i:int=0;
			max_nonzero_i = this.plotLineGraph(this.bytes, channel_length, 0, g,
											   plot_height, g_x, dx, this.annotations);
			g_x = max_nonzero_i * dx;
			g.lineTo(g_x, plot_height);
			//trace('max_nonzero_i * dx', g_x);

			g.lineStyle(0, 0x00FF00);
			
			// right channel
			g.moveTo(g_x, plot_height);
			max_nonzero_i = this.plotLineGraph(this.bytes, channel_length, channel_length,
											   g, plot_height, g_x, dx, this.annotations);
			g_x = max_nonzero_i * dx;
			g.lineTo(g_x, plot_height);
			return this.bytes.length;
		}
		public override function getSpectrum(draw:Boolean=true):int{
			// 256 bytes of data sampled at 44.1 KHz, with DFT performed
			// same as parent class but draw the data received
			SoundMixer.computeSpectrum(this.bytes, true, 0);
			if (draw){
				return this.drawBytes();
			}
			return 0;
		}
		
		public function initializeAnnotations(initialSize:int):void{
			// default format: 
			var format1:TextFormat = new TextFormat();
			format1.font = 'Times';
			format1.size = 8;
			// blue -> magenta -> pink
			var colors:Vector.<int> = new <int>[0x506bc1, 0xe619ee, 0xef67f4, 0xf3b9e5,
												0xff0042, 0xffd200, 0xe7f77c, 0x3dac0c,
												0xd26d6d, 0xfa581f, 0xfaaf1f, 0xe8e6a4,
												0x1ffa72, 0x721ffa, 0x1f77fa, 0xd26dbd];

			this.annotations = new Vector.<TextField>(initialSize);
			for (var i:int=0; i < initialSize; ++i){
				this.annotations[i] = new TextField(); // empty text box
				var colors_i:int = Math.floor(i / initialSize * colors.length);
				this.annotations[i].textColor = colors[colors_i];
				this.annotations[i].setTextFormat(format1);
				this.annotations[i].autoSize = 'center';
				this.annotations[i].blendMode = BlendMode.OVERLAY;
				
				this.addChild(this.annotations[i]);
			}
		}
	}
	
}
