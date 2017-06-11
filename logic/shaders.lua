rainbow = love.graphics.newShader [[
	extern number time;
	vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
	{
		vec4 pixel = Texel(texture, texture_coords);
		if (pixel.a == 0) {return vec4(0.0);}
		return vec4(	((1.0+sin(time * 5.0))			/2.0 + pixel.r)/2.0,
						((1.0+cos(time * 5.0 * 2.0))	/2.0 + pixel.g)/2.0,
						((1.0+sin(time * 5.0 * 2.0))	/2.0 + pixel.b)/2.0, pixel.a);
	}
]]

trippy = love.graphics.newShader [[
	extern number time;
	vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
	{
		vec2 new_coords = vec2(	texture_coords.x + sin(texture_coords.y * 5.0 + time) / 15,
								texture_coords.y + sin(texture_coords.x * 5.0 + time) / 15);
		vec4 pixel = Texel(texture, new_coords);
		if (pixel.a == 0) return vec4(0.0);
		return pixel;
	}
]]
