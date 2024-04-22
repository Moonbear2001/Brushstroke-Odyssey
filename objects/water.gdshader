shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform vec2 scale;

void fragment() {
	
	float uv_height = SCREEN_PIXEL_SIZE.y / TEXTURE_PIXEL_SIZE.y;
	//vec2 reflected_screen_uv = vec2(SCREEN_UV.x - (distortion * intensity * y_zoom), SCREEN_UV.y - uv_height * UV.y * y_zoom * scale.y * 2.0);
	vec2 reflected_screen_uv = vec2(SCREEN_UV.x, SCREEN_UV.y + uv_height * UV.y * 2.0);
	
	COLOR = texture(SCREEN_TEXTURE, reflected_screen_uv);
	
}

