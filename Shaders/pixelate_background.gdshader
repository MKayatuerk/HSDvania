shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform float pixel_size : hint_range(1.0, 320.0);  // Control pixel size

void fragment() {
   	vec2 scaling = SCREEN_PIXEL_SIZE / 0.0010;
    vec2 uv = floor(SCREEN_UV * pixel_size / scaling) / (pixel_size / scaling);
    COLOR = texture(SCREEN_TEXTURE, uv);
}
