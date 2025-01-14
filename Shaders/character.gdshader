shader_type canvas_item;

uniform float width : hint_range(0.0, 64) = 5;
uniform vec3 outline_color : source_color = vec3(0.0, 0.0, 0.0);

uniform vec2 pixel_count = vec2(64.0);

uniform bool is_hit;
uniform vec3 hit_color : source_color = vec3(1.0, 1.0, 1.0);
uniform float hit_flicker_speed : hint_range(1, 100);

float hit() {
    float flash = 0.5 + 0.5 * sin(TIME * hit_flicker_speed);
    return flash * float(is_hit);
}

vec2 pixelate(vec2 uv) {
    uv *= pixel_count;
    uv = floor(uv);
    uv = uv / pixel_count;
    return uv;
}

float outline(sampler2D texture, vec2 uv, float outline_width) {
    if (outline_width == 0.0)
        return 0.00;

    vec2 unit = 1.0 / vec2(textureSize(texture, 0));
    float alpha_sum = 0.0;

    // Loop through surrounding pixels, but pixelate the offsets
    for (float x = -floor(outline_width); x <= floor(outline_width); x++) {
        for (float y = -floor(outline_width); y <= floor(outline_width); y++) {
            if (x == 0.0 && y == 0.0)
                continue; // Skip the center pixel

            // Pixelate the offset UV coordinates
            vec2 offset = vec2(x * unit.x, y * unit.y);
            vec2 neighborUV = pixelate(uv + offset);

            // Sample the neighbor alpha from the passed texture
            float neighbor_alpha = texture(texture, neighborUV).a;

            if (neighbor_alpha > 0.0) {
                alpha_sum += 1.0;
            }
        }
    }

    return clamp(alpha_sum, 0.0, 1.0);
}

void fragment() {
    vec2 pixelUV = pixelate(UV);

    vec4 pixel_color = texture(TEXTURE, UV);

    if (pixel_color.a == 0.0) {
        pixel_color.rgb = outline_color;
        pixel_color.a = outline(TEXTURE, UV, width);
    }
	else {
        pixel_color.rgb = mix(pixel_color.rgb, hit_color, hit());
    }

    COLOR = pixel_color;
}
