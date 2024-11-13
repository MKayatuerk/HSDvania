shader_type canvas_item;

uniform float width : hint_range(0.0, 64) = 1.0;
uniform float noise_scale : hint_range(1.0, 100) = 100;
uniform vec3 outline_color : source_color = vec3(0.0, 1.0, 1.0);
uniform sampler2D noise_texture : repeat_enable;
uniform vec2 direction = vec2(0, 1);
uniform float speed = 0.5;

void fragment() {

    vec2 unit = 1.0 / vec2(textureSize(TEXTURE, 0));

	//uv nach oben bewegen
    vec2 noise_uv = (UV + (direction * speed * TIME));
	//uvs verpixel
	noise_uv = floor(noise_uv * float(noise_scale)) / float(noise_scale);

    float noise_mask = texture(noise_texture, noise_uv).r;

	//gradient von unten nach oben
	float gradient_mask = clamp((UV.y * 3.0 - 0.5), 0.0, 1.0);

    vec4 pixel_color = texture(TEXTURE, UV);

    if (pixel_color.a == 0.0) {
        pixel_color.rgb = outline_color;
        pixel_color.a = 0.0;

        float alpha_sum = 0.0;
        float distance_scale = 1.0 - pow(2.0, -width);

        for (float x = -floor(width); x <= floor(width); x++) {
            for (float y = -floor(width); y <= floor(width); y++) {
                if (x == 0.0 && y == 0.0)
					continue; //mittleren pixel skippen

				//umliegende Pixel samplen
                vec2 offset = vec2(x * unit.x, y * unit.y);
                float neighbor_alpha = texture(TEXTURE, UV + offset).a;

                if (neighbor_alpha > 0.0) { //if transparent
                    float distance_squared = x * x + y * y;
                    alpha_sum += 1.0 / distance_squared * distance_scale;
                }
            }
        }
		float outline_mask =  clamp(pixel_color.a + alpha_sum, 0.0, 1.0);

		//outline mask * noise mask * gradient mask
		pixel_color.a = outline_mask * noise_mask * gradient_mask;
    }

	//mit 10% opacity auf rgb anwenden
	pixel_color.rgb = mix(pixel_color.rgb, outline_color.rgb * vec3(noise_mask * gradient_mask), 0.1);
    COLOR = pixel_color;
}

void light() {
    float cNdotL = max(1.0, dot(NORMAL, LIGHT_DIRECTION));
    LIGHT = vec4(LIGHT_COLOR.rgb * COLOR.rgb * LIGHT_ENERGY * cNdotL, LIGHT_COLOR.a);
}
