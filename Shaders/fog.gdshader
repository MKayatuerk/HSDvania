shader_type canvas_item;

uniform vec3 color : source_color = vec3(0.0, 1.0, 0.5);
uniform sampler2D noise_texture: repeat_enable, filter_nearest;
uniform float density: hint_range(0.0, 1.0) = 0.25;
uniform vec2 speed = vec2(0.02, 0.005);
uniform vec2 pixel_count = vec2(256.0);

void fragment() {

	vec2 uv = UV * 10.0 + speed * TIME;

	uv *= pixel_count;
	uv = floor(uv);
	uv = uv / pixel_count;

	float noise = texture(noise_texture, uv).r;

	float fog = clamp(noise * 2.0 - 1.0, 0.0, 1.0);

	COLOR.a *= fog * density;
	COLOR.rgb = color;
}
