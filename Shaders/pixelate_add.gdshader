shader_type canvas_item;
render_mode blend_add;

uniform vec2 pixel_count = vec2(64.0);

void fragment()
{
	vec2 uv = UV;
	uv *= pixel_count;
	uv = floor(uv);
	uv = uv / pixel_count;
	
	COLOR = texture(TEXTURE, uv);
}
