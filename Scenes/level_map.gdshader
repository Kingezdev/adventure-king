shader_type canvas_item;

uniform float blur_amount : hint_range(0.0, 10.0) = 0.0;

void fragment() {
	vec4 sum = vec4(0.0);
	vec2 size = vec2(blur_amount) / SCREEN_PIXEL_SIZE;
	vec2 uv = UV;

	// 9-tap Gaussian blur
	sum += texture(TEXTURE, uv + size * vec2(-1.0, -1.0)) * 0.0625;
	sum += texture(TEXTURE, uv + size * vec2( 0.0, -1.0)) * 0.125;
	sum += texture(TEXTURE, uv + size * vec2( 1.0, -1.0)) * 0.0625;

	sum += texture(TEXTURE, uv + size * vec2(-1.0,  0.0)) * 0.125;
	sum += texture(TEXTURE, uv) * 0.25;
	sum += texture(TEXTURE, uv + size * vec2( 1.0,  0.0)) * 0.125;

	sum += texture(TEXTURE, uv + size * vec2(-1.0,  1.0)) * 0.0625;
	sum += texture(TEXTURE, uv + size * vec2( 0.0,  1.0)) * 0.125;
	sum += texture(TEXTURE, uv + size * vec2( 1.0,  1.0)) * 0.0625;

	COLOR = sum;
}
