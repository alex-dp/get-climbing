Game = Object:extend()

local wall_count = 1
objects = {}

room = {w = 1500, h = 300}

local function add_floor()
	objects.walls[wall_count] = Wall(width/2, height - wall_count*room.h, room.w, 1, world, "floor")
	
	objects.boundaries[wall_count] = {
		Wall((width - room.w) / 2, -(wall_count - 1)*300 + height, 1, 300, world, "wall"),
		Wall((width + room.w) / 2 + 100, -(wall_count - 1)*300 + height, 1, 300, world, "wall")
	}
	
	wall_count = wall_count + 1
end

function Game:load()
	wall_count = 1
	objects = {}

	objects.player = Player(width/2, height - 128, world)
	objects.walls = {Wall(width / 2 + 50, height, room.w + 100, 1, world, "floor")}
	objects.clouds = {}
	objects.boundaries = {}
	
	elevator = Wall(width / 2 + room.w / 2 + 50, height, 100, 1, world, "elev")
	elevator.fixture:setCategory(2)
	
	elevator_joint = love.physics.newPrismaticJoint(elevator.body, objects.walls[1].body,
		0, 0,
		0, 1, true)
	elevator_joint:setMotorEnabled(true)
	elevator_joint:setMaxMotorForce(60000)
	elevator_joint:setLimitsEnabled(false)

	repeat
		add_floor()
	until #objects.walls * 300 > height
end

function Game:update(dt)
	objects.player:update(dt, camera.y)
	world:update(dt)
	if round(love.timer.getTime() * 2, 2) % 20 == 0 then
		objects.clouds[#objects.clouds + 1] = {}
		objects.clouds[#objects.clouds].x = -images.cloud:getWidth()
		objects.clouds[#objects.clouds].y = math.random(0, height)
	end

	for k, v in ipairs(objects.clouds) do
		v.x = v.x + 60 * dt
		if v.x > width then
			table.remove(objects.clouds, k)
		end
	end

	if objects.walls[#objects.walls].y + height > camera.y then
		add_floor()
	end
	
	for k, v in ipairs(objects.walls) do
		if not v.body:isDestroyed() and v.body:getY() > camera.y + height + 600 then
			v.body:destroy()
			objects.boundaries[k][1].body:destroy()
			objects.boundaries[k][2].body:destroy()
		end
	end
	
	if elevator.active then
		if elevator.elevate then
			elevator_joint:setMotorSpeed(300)
		elseif elevator.body:getY() < -objects.player:storey() * 300 + height -2 then
			elevator_joint:setMotorSpeed(-500)
		elseif elevator.body:getY() > -objects.player:storey() * 300 + height +2 then
			elevator_joint:setMotorSpeed(500)
		else
			elevator_joint:setMotorSpeed(0)
			elevator.active = false
		end
	end
end

function Game:draw()
	local dy = 0
	local dx = 0
	
	local xPos, yPos = objects.player.body:getPosition()

	for k, v in ipairs(objects.clouds) do	--clouds are the farthest away
		love.graphics.draw(images.cloud, round(v.x), v.y)
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
	
	if dy ~= 0 then
		camera.y = round(camera.y + dy)		--rounding prevents interpolation
	end
	if dx ~= 0 then
		camera.x = round(camera.x + dx)
	end
	camera:set()
	
	for k, v in ipairs(objects.walls) do
		if not v.body:isDestroyed() then
			local index
			if k % 10 == 4 then
				index = 2
			else index = 1
			end
			love.graphics.draw(images.rooms[index], edge(v.body, "left"), v.y)
		end
	end
	love.graphics.setColor(80, 80, 80)
	love.graphics.rectangle("fill", (width + room.w) / 2, camera.y, 100, height)
	love.graphics.setColor(140, 120, 100)
	love.graphics.rectangle("fill", (width + room.w) / 2 + 48, camera.y, 4, height)
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(images.elevator, round(edge(elevator.body, "left")), round(edge(elevator.body, "top") - 120))
	objects.player:draw(camera.x, camera.y)
	camera:unset()
end
