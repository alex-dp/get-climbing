Player = Object:extend()

local room  = love.graphics.newImage("gfx/room1.png")
local delay = 0
local foe_del = 0

function Player:new(x, y, w, h, world)
	self.x = x
	self.y = y
	self.w = w
	self.h = h
	self.world = world

	self.heading = 1
	self.gender = true
	self.health = 5
	self.maxhealth = 5
	self.power = {low = 1, high = 3}
	self.lvl = 1
	self.xp = 0
	self.nextlvl = 8

	self.body = love.physics.newBody(self.world, self.x, self.y, "dynamic")
	self.shape = love.physics.newRectangleShape(self.w, self.h)
	self.fixture = love.physics.newFixture(self.body, self.shape, 1)

	self.fixture:setFriction(1)
	self.fixture:setRestitution(0)

	self.sprites = {
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
	}

	self.foes = {}
end

function Player:edge(s)
	if s == "top" then
		return self.body:getY() - self.h / 2
	elseif s == "right" then
		return self.body:getX() + self.w / 2
	elseif s == "bottom" then
		return self.body:getY() + self.h / 2
	elseif s == "left" then
		return self.body:getX() - self.w / 2
	end
end

function Player:update(dt, dy)
	delay = delay + dt
	if mode == "play" then foe_del = foe_del + dt end
	local xs, ys = self.body:getLinearVelocity()
	if love.keyboard.isDown("a") and mode == "play" then
		self.heading = -1
	    self.body:setLinearVelocity(-400, ys)
	elseif love.keyboard.isDown("d") and mode == "play" then
		self.heading = 1
		self.body:setLinearVelocity(400, ys)
	end

	if touch then
		self.fixture:setFriction(0)
	end

	if self:onStairs() then
		self.body:setGravityScale(0)
	else self.body:setGravityScale(1)
	end

	if foe_del > 5 then
		if math.floor(foe_del) % 10 == 0 and count(self.foes) < 5 then
			local foe = Foe(math.random(width / 2 - 500, width / 2 + 500), self:edge("top") - math.random(200, 400), 64, 64, self.world)
			table.insert(self.foes, foe)
			foe_del = 1
		end
	end

	for k, v in ipairs(self.foes) do
		foeXv, foeYv = v.body:getLinearVelocity()
		v.body:setLinearVelocity(v.heading * math.abs(xs), foeYv)
		v:update(dt, dy)
		if v.health == 0 then
			self.xp = self.xp + v.xp
			table.remove(self.foes, k)
			v.body:destroy()
		end
	end

	for k, v in ipairs(self.foes) do
		if v.body:getY() > camera.y + height + 256 then
			table.remove(self.foes, k)
			v.body:destroy()
		end
	end
	
	if self.xp == self.nextlvl then
		self.lvl = self.lvl + 1
		self.xp = 0
		self. netxlvl = math.floor(2.5 * self.lvl) + 5
		for i = 1, 5 do
			local dest = math.random(3)
			if dest == 1 then
				self.health = self.health + math.floor(self.lvl / 2)
				self.maxhealth = self.maxhealth + math.floor(self.lvl / 2)
			elseif dest == 2 and self.power.low < self.power.high then
				self.power.low = self.power.low + 1
			elseif dest == 3 then
				self.power.high = self.power.high + 1
			end			
		end
	end
end

function Player:draw(dx, dy)
	local xs, ys = self.body:getLinearVelocity()
	local edge, im

	if self.heading == -1 then
		edge = self:edge("right")
	else
		edge = self:edge("left")
	end

	if round(xs, -1) ~= 0 then
	    if math.floor(delay * 10) % 8 < 4 then
	    	im = 2
	    else im = 3
	    end
	else im = 1
	end

	for k, v in ipairs(self.foes) do
		v:draw(dx, dy)
	end
	love.graphics.draw(self.sprites[self.gender][im], edge, self:edge("top"), 0, self.heading, 1)

	if touch then
		love.graphics.setColor(255, 255, 255, 0x80)
		love.graphics.rectangle("fill", 30 + dx, height - 158 + dy, 128, 128)
		love.graphics.rectangle("fill", 188 + dx, height - 158 + dy, 128, 128)
		love.graphics.rectangle("fill", width - 158 + dx, height - 158 + dy, 128, 128)
		love.graphics.rectangle("fill", width - 316 + dx, height - 158 + dy, 128, 128)
		love.graphics.setColor(255, 255, 255)
	end
	
	if mode == "play" then
		love.graphics.setColor(215, 40, 40, 0x80)
		love.graphics.rectangle("fill", 30 + dx, 20 + dy, width / 3, 36)
		
		love.graphics.setColor(215, 40, 40)
		love.graphics.rectangle("fill", 30 + dx, 20 + dy, self.health * (width / 3) / self.maxhealth, 36)
		
		love.graphics.setColor(215, 195, 30, 0x80)
		love.graphics.rectangle("fill", 30 + dx, 70 + dy, width / 3, 18)
		
		love.graphics.setColor(215, 195, 30)
		love.graphics.rectangle("fill", 30 + dx, 70 + dy, self.xp * (width / 3) / self.nextlvl, 18)
		
		love.graphics.setColor(255, 255, 255)
		
		love.graphics.setFont(fonts[15])
		love.graphics.printf("level " .. self.lvl, 32 + dx, 76 + dy, width, "left")
	end
end

function Player:keypressed(key, code, rep)

	local xs, ys = self.body:getLinearVelocity()
	if key == "space" then
	    self:jump(xs, ys)
	end
end

function Player:keyreleased(key, code, rep)
	local xs, ys = self.body:getLinearVelocity()
	if key == "a" or key == "d" then
		self.body:setLinearVelocity(0, ys)
	end
end

function Player:touchpressed(x, y)
	if mode == "play" then
		touch = true
		local xs, ys = self.body:getLinearVelocity()


		if y > height - 158 and y < height - 30 then
			if x < 158 then
				self.body:setLinearVelocity(-400, ys)
				self.heading = -1
			elseif x < 316 then
				self.body:setLinearVelocity(400, ys)
				self.heading = 1
			elseif x > width - 158 then
				self:jump(xs, ys)
			elseif x > width - 316 then
				self:hit()
			end
		end
	end
end

function Player:touchreleased(x, y)
	if mode == "play" then
		local xs, ys = self.body:getLinearVelocity()


		if y > height - 158 and y < height - 30 then
			if x < 158 --[[and xs < 0]] then
				self.body:setLinearVelocity(0, ys)
				self.heading = -1
			elseif x < 316 --[[and xs > 0]] then
				self.body:setLinearVelocity(0, ys)
				self.heading = 1
			end
		end
	end
end

function Player:jump(xs, ys)
	if round(ys, 0) == 0 then
		self.body:setLinearVelocity(xs, -1000)
	end
end

function Player:hit()
	print("hitting...")
	for k, v in ipairs(self.foes) do
		if distance(v, self) < 100 then
				v.health = v.health - 1
		end
	end
end

function Player:onStairs()
	return (self:edge("right") < (width - room:getWidth() - 100) / 2 + 100 and --left side stairs
		(height - self:edge("bottom")) % 600 > 300) or
		(self:edge("left") > (width + room:getWidth() + 100) / 2 - 100 and --right side stairs
		(height - self:edge("bottom")) % 600 < 300)
end
