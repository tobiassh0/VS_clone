shader_type canvas_item;

//: repeat_enable
uniform sampler2D noise_img; 

void fragment() {
//	vec2 uv = vec2(UV.x, UV.y);
	COLOR = texture(noise_img, UV);
//	COLOR.a = texture(TEXTURE, uv).a;
}
