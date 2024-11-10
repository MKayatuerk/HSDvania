shader_type canvas_item;
uniform float opacity;
uniform float r;
uniform float g;
uniform float b;
uniform float mix_color;

void vertex() {
}

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	if (texture_color.a != 0.0)
		COLOR = vec4(mix(texture_color.rgb, vec3(r,g,b), mix_color), opacity);
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	float cNdotL = max(1.0, dot(NORMAL, LIGHT_DIRECTION));
	LIGHT = vec4(LIGHT_COLOR.rgb * COLOR.rgb * LIGHT_ENERGY * cNdotL, LIGHT_COLOR.a);
}
