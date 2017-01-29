Game = Object:extend()

local delay = 0
local wall_count = 1
objects = {}

room = {w = 1500, h = 300}

local function add_floor()
	local diff, xpos
	if wall_count % 2 == 0 then
			diff = 50
		else
			diff = -50
	end
	objects.walls[wall_count] = Wall(width/2 + diff, height - wall_count*room.h, room.w, 1, world)
	
	objects.boundaries[wall_count] = {
		Wall((width - room.w - 100) / 2, -(wall_count - 1)*300 + height, 1, 300, world),
		Wall((width + room.w + 100) / 2, -(wall_count - 1)*300 + height, 1, 300, world)
	}
	
	objects.steps[wall_count] = {}
	
	if wall_count % 2 == 0 then
			xpos = (width - room.w) / 2
		else
			xpos = (width + room.w) / 2
	end
	
	for i = 1, 5 do
		objects.steps[wall_count][i] = Wall(xpos, 300*(i/5 - wall_count) + height - 60, 100, 1, world, "step")
	end
	
	wall_count = wall_count + 1
end

function Game:load()
	rooms  = {love.graphics.newImage("gfx/room1.png"),
		love.graphics.newImage("gfx/room2.png")}
	stairs = love.graphics.newImage("gfx/stairs.png")
	cloud = love.graphics.newImage("gfx/cloud.png")

	objects.player = Player(width/2, height - 128, 64, 64, world)
	objects.ground = Wall(width / 2, 7*height/6, room.w + 100 + 2*width/3, height/3, world)
	objects.walls = {}
	objects.clouds = {}
	objects.boundaries = {}
	objects.steps = {}

	repeat
		add_floor()
	until #objects.walls * 300 > height
end

function Game:update(dt)
	delay = delay + dt
	objects.player:update(dt, camera.y)
	world:update(dt)
	if math.floor(delay) % 20 == 0 then
		objects.clouds[#objects.clouds + 1] = {}
		objects.clouds[#objects.clouds].x = -cloud:getWidth()
		objects.clouds[#objects.clouds].y = math.random(0, height)
		delay = 1
	end

	for k, v in ipairs(objects.clouds) do
		v.x = v.x + 60 * dt
		if v.x > width then
			table.remove(objects.clouds, k)
		end
	end

	if objects.walls[#objects.walls].y > camera.y then
		add_floor()
	end
	
	for k, v in ipairs(objects.walls) do
		if not v.body:isDestroyed() then
			if v.body:getY() > camera.y + height + 600 then
				v.body:destroy()
				--table.remove(objects.walls, k)
				objects.boundaries[k][1].body:destroy()
				objects.boundaries[k][2].body:destroy()
				--table.remove(objects.boundaries, k)
			end
		end
	end
	
	for k, v in ipairs(objects.steps) do
		for i, s in ipairs(v) do
			if edge(objects.player.body, "bottom") < s.body:getY() then
				s.fixture:setMask()
			else
				s.fixture:setMask(1)
			end
		end
	end
end

function Game:draw()
	local dy = 0
	local dx = 0
	
	local xPos, yPos = objects.player.body:getPosition()

	for k, v in ipairs(objects.clouds) do	--clouds are the farthest away
		love.graphics.draw(cloud, v.x, v.y)
	end

	if yPos - camera.y < height / 3 then
		dy = yPos - camera.y - height / 3
	elseif yPos - camera.y > 2 * height / 3 then
		dy = yPos - camera.y - 2 * height / 3
	end

	if xPos - camera.x < width / 3 then
		dx = xPos - camera.x - width / 3
	elseif xPos - camera.x > 2 * width / 3 then
		dx = xPos - camera.x - 2 * width / 3
	end

	camera.y = camera.y + dy
	camera.x = camera.x + dx
	camera:set()
	love.graphics.setColor(150, 150, 150)
	objects.ground:draw()
	love.graphics.setColor(255, 255, 255)
	for k, v in ipairs(objects.walls) do
		if not v.body:isDestroyed() then
			local xpos
			if k % 2 == 1 then
				xpos = v.x + room.w / 2
			else
				xpos = v.x - room.w / 2 - 100
			end
			local index
			if k % 10 == 4 then
				index = 2
			else index = 1
			end
			love.graphics.draw(rooms[index], v.x - room.w/2, v.y)
			love.graphics.draw(stairs, xpos, v.y)
		end
	end

	objects.player:draw(camera.x, camera.y)
	camera:unset()
end
