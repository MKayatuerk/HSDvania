shader_type canvas_item;

uniform float progress : hint_range(0, 1);
uniform sampler2D noise_texture;
uniform sampler2D screen_texture : hint_screen_texture;
uniform sampler2D mask_texture;  // The texture that defines the mask (grayscale)
uniform float pixelation_amount = 0.2; // Controls the pixelation size
uniform vec2 mask_scale = vec2(1.0, 1.0); // Scale factor for the mask
uniform vec2 mask_offset = vec2(0.0, 0.0); // Offset for the mask texture


vec2 transform_texture(vec2 uv, vec2 scale, vec2 offset, float aspect_ratio) {
    vec2 centered_uv = uv - 0.5;
    centered_uv.x *= aspect_ratio;
    centered_uv = centered_uv / scale + offset;
    return centered_uv + 0.5;
}

void fragment() {
    // Calculate the aspect ratio for the screen
    float aspect_ratio = float(SCREEN_PIXEL_SIZE.y) / float(SCREEN_PIXEL_SIZE.x);

    // Transform UVs for the mask texture
    vec2 mask_uv = transform_texture(UV, mask_scale, mask_offset, aspect_ratio);

    // Sample the mask texture
    vec4 mask_color = texture(mask_texture, mask_uv);

    // Sample the original screen texture
    vec4 scene_tex = texture(screen_texture, SCREEN_UV);

    // Overlay the mask texture as a colored image
    COLOR = scene_tex; // Blend between the screen texture and the mask
}
