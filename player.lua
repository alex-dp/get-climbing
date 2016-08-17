Player = Object:extend()

--require "bullet"

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
	self.health = 3

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
		},

		heart = love.graphics.newImage("gfx/heart.png")
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
			local foe = Foe(math.random(width / 2 - 500, width / 2 + 500), self:edge("top") - math.random(400, 800), 64, 64, self.world)
			table.insert(self.foes, foe)
			foe_del = 1
		end
	end

	for k, v in ipairs(self.foes) do
		v:update(dt, dy)
	end

	for k, v in ipairs(self.foes) do
		if v.body:getY() > camera.y + height + 256 then
			table.remove(self.foes, k)
			v.body:destroy()
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
		love.graphics.setColor(255, 255, 255)
	end

	for i = 1, self.health do
		love.graphics.draw(self.sprites.heart, (i-1) * 84 + 16*i + dx, 16 + dy)
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

function Player:onStairs()
	return (self:edge("right") < (width - room:getWidth() - 100) / 2 + 100 and --left side stairs
		(height - self:edge("bottom")) % 600 > 300) or
		(self:edge("left") > (width + room:getWidth() + 100) / 2 - 100 and --right side stairs
		(height - self:edge("bottom")) % 600 < 300)
end

function count (t)
	local count = 0
	for _ in ipairs(t) do
		count = count + 1
	end
	return count
end