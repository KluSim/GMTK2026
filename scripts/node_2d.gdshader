shader_type canvas_item;

// Assign a Godot NoiseTexture2D here (make sure it's set to Seamless!)
uniform sampler2D noise_texture : repeat_enable, filter_linear_mipmap;

uniform vec4 sky_color : source_color = vec4(0.3, 0.6, 0.9, 1.0);
uniform vec4 cloud_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

// Behavior controls
uniform float cloud_density : hint_range(0.0, 1.0) = 0.5;
uniform float cloud_fuzziness : hint_range(0.01, 1.0) = 0.3;
uniform vec2 base_velocity = vec2(0.02, 0.0);

void fragment() {
    // Layer 1: Slow, large background clouds
    vec2 uv_layer1 = UV + (TIME * base_velocity);
    float noise1 = texture(noise_texture, uv_layer1).r;
    
    // Layer 2: Faster, smaller foreground clouds for shifting depth
    vec2 uv_layer2 = (UV * 2.0) + (TIME * base_velocity * 1.8) + vec2(0.2, 0.5);
    float noise2 = texture(noise_texture, uv_layer2).r;
    
    // Combine both layers (FBM approximation)
    float combined_noise = mix(noise1, noise2, 0.4);
    
    // Adjust cloud thickness and edge sharpness using smoothstep
    // High density cuts deeper into the noise texture
    float low_bound = 1.0 - cloud_density;
    float high_bound = clamp(low_bound + cloud_fuzziness, 0.0, 1.0);
    
    float cloud_mask = smoothstep(low_bound, high_bound, combined_noise);
    
    // Mix sky background and final cloud colors
    vec4 final_color = mix(sky_color, cloud_color, cloud_mask);
    
    COLOR = final_color;
}