shader_type canvas_item;

uniform float speed = 1.7;
uniform float amplitude = 0.008;
uniform float aspect_ratio = 1;
uniform vec2 offset_scale = vec2(1, 1);
uniform float hit = 0.0;


void vertex() {
	VERTEX.x += (sin(TIME * speed) + hit) * amplitude * (VERTEX.y - 18.0);
	
}
/*void fragment() {
	
	vec2 wave_uv_offset;
	wave_uv_offset.x = UV.x + 1.0;
	wave_uv_offset.y = UV.y;
	COLOR = vec4(wave_uv_offset, 0.0, 1.0);
	//COLOR = texture(TEXTURE, wave_uv_offset);
}*/