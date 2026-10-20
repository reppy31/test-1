shader_type canvas_item;

// Match this EXACTLY to your background wall color using the eyedropper
uniform vec4 wall_color : source_color = vec4(0.25, 0.25, 0.25, 1.0); 
uniform float margin_thickness : hint_range(0.0, 20.0, 0.5) = 4.0;

void fragment() {
    vec4 current_pixel = texture(TEXTURE, UV);
    
    // 1. If it's your actual hand-drawn black stick figure line, draw it perfectly
    if (current_pixel.a > 0.1) {
        COLOR = current_pixel;
    } else {
        // 2. Scan a circular radius around the empty space
        float max_alpha = 0.0;
        vec2 size = TEXTURE_PIXEL_SIZE * margin_thickness;
        
        // 16-point circle sampling for perfectly smooth, non-pixelated circles
        for (int i = 0; i < 16; i++) {
            float angle = float(i) * 0.392699; // 2 * PI / 16
            vec2 direction = vec2(cos(angle), sin(angle));
            float alpha = texture(TEXTURE, UV + direction * size).a;
            max_alpha = max(max_alpha, alpha);
        }
        
        // 3. If the character's legs are nearby, fill this space with a SOLID block of wall color
        if (max_alpha > 0.1) {
            COLOR = vec4(wall_color.rgb, 1.0); // 1.0 opacity completely erases the sidewalk line beneath it
        } else {
            // 4. Pure empty space remains completely transparent
            COLOR = current_pixel;
        }
    }
}