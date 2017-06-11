Game = Object:extend()

local wall_count = 1
objects = {}
droppables = {one = stamps[1], two = stamps[2], beer = alterers.beer, acid = alterers.acid}
room = {w = 1500, h = 300}

local function add_floor()
	objects.storeys[wall_count] = Storey(wall_count, world)	
	wall_count = wall_count + 1
end

function Game:load()
	wall_count = 0
	objects = {}

	objects.player = Player(width/2, height - 400, world)
	objects.storeys = {}
	objects.clouds = {}
	objects.boundaries = {}

	repeat
		add_floor()
	until #objects.storeys * room.h > height
	
	elevator = Wall(width / 2 + room.w / 2 + 50, height - 300, 100, 1, world, "elev")
	elevator.fixture:setCategory(3)
	elevator_joint = love.physics.newPrismaticJoint(elevator.body, objects.storeys[1].floor.body,
		0, 0,
		0, 1, true)
	elevator_joint:setMotorEnabled(true)
	elevator_joint:setMaxMotorForce(75000)
	elevator_joint:setLimitsEnabled(false)
	
	elevator_ceiling = Wall(width / 2 + room.w / 2 + 50, height - 420, 80, 1, world, "ceil")
	ceiling_joint = love.physics.newPrismaticJoint(elevator.body, elevator_ceiling.body, 0,0,0,120)
	ceiling_joint:setMotorEnabled(false)
	ceiling_joint:setLimits(3.75, 3.75)
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

	if objects.storeys[#objects.storeys].y + height > camera.y then
		add_floor()
	end
	
	for k, v in ipairs(objects.storeys) do
		if not v.destroyed then
			if v.y > camera.y + height + 1200 then
				v:destroy()
			else
				v:update(dt, camera.y)
			end
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
	local dx = 0
	local dy = 0
	
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
	
	if dx ~= 0 then
		camera.x = math.floor(camera.x + dx)		--rounding prevents interpolation
	end
	if dy ~= 0 then
		camera.y = math.floor(camera.y + dy)
	end
	
	camera:set()
	
	love.graphics.setColor(80, 80, 80)
	love.graphics.rectangle("fill", (width + room.w) / 2 + dx, camera.y - 200, 100, height + 400) --overflow for drunk oscillation
	love.graphics.setColor(140, 120, 100)
	love.graphics.rectangle("fill", (width + room.w) / 2 + 48 + dx, camera.y - 200, 4, height + 400)
	love.graphics.setColor(255, 255, 255)
	
	love.graphics.draw(images.elevator, math.floor(edge(elevator.body, "left")), math.floor(edge(elevator.body, "top") - 120))
	
	for k, v in ipairs(objects.storeys) do
		if not v.destroyed then
			v:draw()
		end
	end
	
	objects.player:draw(camera.x, camera.y)
	camera:unset()
end
