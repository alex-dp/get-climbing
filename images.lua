images = {
	icons = {
		stairs = love.graphics.newImage("gfx/stairs_icon.png")
	},
	stamps = {
		[1] = love.graphics.newImage("gfx/stamps/one.png")
	},
	rooms  = {
		love.graphics.newImage("gfx/room1.png"),
		love.graphics.newImage("gfx/room2.png")
	},
	player_sprites = {
		[true] = {
			love.graphics.newImage("gfx/idle.png"),
			love.graphics.newImage("gfx/walk1.png"),
			love.graphics.newImage("gfx/walk2.png")
		},

		[false] = {
			love.graphics.newImage("gfx/f_idle.png"),
			love.graphics.newImage("gfx/f_walk1.png"),
			love.graphics.newImage("gfx/f_walk2.png")
		}
	},
	cloud = love.graphics.newImage("gfx/cloud.png"),
	elevator = love.graphics.newImage("gfx/elevator_open.png")
}
