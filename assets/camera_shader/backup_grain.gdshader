shader_type canvas_item;

uniform float intensity : hint_range(0.0, 1.0) = 0.1; // Controls grain intensity
uniform float speed : hint_range(0.0, 10.0) = 1.0;    // Controls grain animation speed
uniform float grain_scale : hint_range(1.0, 10.0) = 2.0; // Controls grain scale
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

float random(vec2 uv) {
    return fract(sin(dot(uv.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    vec2 uv = FRAGCOORD.xy / SCREEN_PIXEL_SIZE;

    // Add time-based noise offset for smoother motion
    vec2 noise_uv = uv * grain_scale + vec2(TIME * speed);

    // Generate smooth grain using random function
    float grain = random(noise_uv);
    grain = grain * 2.0 - 1.0; // Normalize to range [-1, 1]

    // Mix the grain with the original color
    vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV);
    color.rgb += grain * intensity;

    COLOR = color;
}