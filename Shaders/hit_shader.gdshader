shader_type canvas_item;

uniform bool hit;
uniform float flicker_speed : hint_range(1, 100);

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	if (texture_color.a == 0.0)
		discard;

	float flash = 0.5 + 0.5 * sin(TIME * flicker_speed);
	vec4 flash_color = vec4(1.0, 1.0, 1.0, 1.0);
	COLOR = mix(texture_color, flash_color, flash * float(hit));
}

void light() {
	float cNdotL = max(1.0, dot(NORMAL, LIGHT_DIRECTION));
	LIGHT = vec4(LIGHT_COLOR.rgb * COLOR.rgb * LIGHT_ENERGY * cNdotL, LIGHT_COLOR.a);
}
