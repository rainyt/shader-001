package;

import openfl.geom.PerspectiveProjection;
import openfl.geom.Utils3D;
import VectorMath.sqrt;
import VectorMath;
import VectorMath.vec2;
import VectorMath.sin;
import glsl.GLSL.texture2D;
import glsl.OpenFLShader;
import openfl.geom.Vector3D;
import openfl.geom.Matrix3D;
import openfl.geom.Point;
import openfl.geom.Matrix;
import openfl.display.Bitmap;
import openfl.Vector;
import openfl.Assets;
import openfl.display.Sprite;
import openfl.display.Sprite;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.display.Graphics;
import openfl.display.TriangleCulling;
import openfl.geom.*;
import openfl.Vector;
import openfl.events.Event;
import openfl.Assets;
import openfl.display.FPS;
import motion.*;
import motion.easing.*;

class Main extends Sprite {
	public function new() {
		super();
		// var bitmap = new Bitmap(Assets.getBitmapData("assets/test.jpg"));
		var bitmap = new Bitmap(Assets.getBitmapData("assets/icon.png"));
		this.addChild(bitmap);
		var shader = new Shader();
		bitmap.shader = shader;
		bitmap.scaleX = bitmap.scaleY = 0.5;
		shader.u_scale.value = [0.];
		var time = 0.;
		this.addEventListener(Event.ENTER_FRAME, (e) -> {
			time += 0.01;
			shader.u_scale.value[0] = 0.8 * Math.abs(Math.sin(time));
			bitmap.invalidate();
		});
		bitmap.x = 100;
		bitmap.y = 100;
	}
}

/**
 * 矩形着色器
 */
class Shader extends OpenFLShader {
	@:uniform public var scale:Float;

	override function fragment() {
		super.fragment();
		// 获取UV坐标
		var coord:Vec2 = gl_openfl_TextureCoordv;
		// 缩放偏移
		var iy:Float = 1 - scale + scale * (gl_openfl_TextureCoordv.y);
		var c:Vec2 = (coord - vec2((1 - iy) * 0.5, 0)) / vec2(iy, 1);
		// 超出范围的，取透明值
		if (c.x < 0 || c.x > 1) {
			this.gl_FragColor = vec4(0);
		} else {
			// 取值
			var color2:Vec4 = texture2D(gl_openfl_Texture, c);
			this.gl_FragColor = color2;
		}
	}
}
