shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;
uniform float blur_radius = 4.0;
uniform bool active = true;

void fragment() {
    vec4 final_color;

    if (active) {
        vec4 sum = vec4(0.0);
        vec2 texel_size = blur_radius / vec2(textureSize(screen_texture, 0));

        for (int x = -2; x <= 2; x++) {
            for (int y = -2; y <= 2; y++) {
                vec2 offset = vec2(float(x), float(y)) * texel_size;
                sum += texture(screen_texture, SCREEN_UV + offset);
            }
        }

        final_color = sum / 25.0;
    } else {
        final_color = texture(screen_texture, SCREEN_UV);
    }

    COLOR = final_color;
}
