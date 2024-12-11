shader_type canvas_item;

uniform vec2 pixel_count = vec2(64.0);
render_mode blend_add;

void fragment()
{
	vec2 uv = UV;
	uv *= pixel_count;
	uv = floor(uv);
	uv = uv / pixel_count;
	
	COLOR = texture(TEXTURE, uv);
}
