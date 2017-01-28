Game = Object:extend()

local delay = 0
local wall_count = 1
objects = {}

room = {w = 1500, h = 300}

local function add_floor()
	local diff
	if wall_count % 2 == 0 then
			diff = 50
		else diff = -50
	end
	objects.walls[wall_count] = Wall(width/2 + diff, height - wall_count*room.h, room.w, 1, world)
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

	objects.boundaries = {Wall((width - room.w - 100) / 2, -50*300 + height, 1, 100*300, world),
			Wall((width + room.w + 100) / 2, -50*300 + height, 1, 100*300, world)}

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
		v.x = v.x + 60*dt
		if v.x > width then
			table.remove(objects.clouds, k)
		end
	end

	if objects.walls[#objects.walls].y > camera.y then
		add_floor()
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
		local xpos
		if k % 2 == 1 then
			xpos = v.body:getX() + room.w / 2
		else xpos = v.body:getX() - room.w / 2 - 100
		end
		local index
		if k % 10 == 4 then
			index = 2
		else index = 1
		end
		love.graphics.draw(rooms[index], v.body:getX() - room.w/2, v.y)
		love.graphics.draw(stairs, xpos, v.y)
	end

	objects.player:draw(camera.x, camera.y)
	camera:unset()
end
