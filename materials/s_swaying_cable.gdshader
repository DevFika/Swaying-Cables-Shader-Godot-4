shader_type spatial;

uniform vec3 base_color: source_color;

uniform float speed = 4.0;
uniform float intensity = 2.3;

varying float height_mask;

float sine_three_combine(float time, vec3 frequencies) {
	float sum = 0.0;
	sum += sin(time * frequencies.x);
	sum += sin(time * frequencies.y);
	sum += sin(time * frequencies.z);
	return sum * 0.333;
}

float get_position_sum(vec3 world_position) {
	return world_position.x + world_position.y + world_position.z;
}

void vertex() {
	vec3 sway_direction = vec3(1.0, 0.0, 0.0);
	vec3 cross_direction = normalize(cross(sway_direction, vec3(0.0, 1.0, 0.0)));
	
	height_mask = COLOR.r;
	height_mask *= height_mask;
	
	float position_sum = get_position_sum(NODE_POSITION_WORLD);
	float sway_offset = position_sum * 25.5;
	
	float time = TIME * speed;
	time *= max(fract(position_sum), 0.8);
	
	float sway_amount = sine_three_combine(
		time + sway_offset,
		vec3(1.0, 1.22, 1.41)
	) * intensity;
	
	float sway_cross_amount = sine_three_combine(
		time + sway_offset,
		vec3(1.114, 1.32, 1.64)
	) * intensity;
	
	VERTEX += sway_amount * sway_direction * height_mask * 0.5;
	VERTEX += sway_cross_amount * cross_direction * height_mask;
}

void fragment() {
	ALBEDO = base_color;
	//ALBEDO = vec3(height_mask);
	ROUGHNESS = 0.4;
}


















