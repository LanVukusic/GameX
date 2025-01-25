shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;
uniform float pixel_size : hint_range(1.0, 100.0) = 10.0; // Pixelation intensity

void fragment() {
    // Get the screen resolution
    vec2 screen_res = vec2(textureSize(SCREEN_TEXTURE, 0));

    // Snap UV coordinates to the pixel grid precisely
    vec2 pixel_uv = floor(UV * screen_res / pixel_size) * pixel_size / screen_res;

    // Sample the screen texture using pixelated UV
    vec4 screen_color = texture(SCREEN_TEXTURE, pixel_uv);

    // Output the pixelated color
    COLOR = screen_color;
}
