shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

// Control pixelation and blur independently
uniform float pixel_size : hint_range(1.0, 50.0) = 8.0; // Pixelation strength
uniform float blur_radius : hint_range(1.0, 20.0) = 5.0; // Blur strength

void fragment() {
    // Get the size of the texture
    vec2 tex_size = vec2(textureSize(screen_texture, 0));
    vec2 texel_size = 1.0 / tex_size;

    // Pixelation step
    vec2 pixel_uv = floor(UV * tex_size / pixel_size) * pixel_size / tex_size;
    vec4 pixel_color = texture(screen_texture, pixel_uv);

    // Blur step
    vec4 blurred_color = vec4(0.0);
    float total_weight = 0.0;

    for (float x = -blur_radius; x <= blur_radius; x++) {
        for (float y = -blur_radius; y <= blur_radius; y++) {
            vec2 offset = vec2(x, y) * texel_size;
            float weight = 1.0 / (1.0 + length(vec2(x, y))); // Gaussian-like weighting
            blurred_color += texture(screen_texture, pixel_uv + offset) * weight;
            total_weight += weight;
        }
    }

    // Normalize the blurred color
    blurred_color /= total_weight;

    // Final output
    COLOR = blurred_color;
}
