Foe = Object:extend()

function Foe:new(x, y, w, h, world)
	self.x = x
	self.y = y
	self.w = w
	self.h = h
	self.world = world

	self.delay = 0
	self.heading = 1
	self.health = 4
	self.maxhealth = 6
	self.xp = 1			--CHANGE ME

	self.body = love.physics.newBody(self.world, self.x, self.y, "dynamic")
	self.shape = love.physics.newRectangleShape(self.w, self.h)
	self.fixture = love.physics.newFixture(self.body, self.shape, 1)

	self.fixture:setFriction(0)
	self.fixture:setRestitution(0)

	self.body:setLinearVelocity(self:randomVel(), 0)
end

function Foe:edge(s)
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

function Foe:update(dt, dy)
	self.delay = self.delay + dt
	local x, y = self.body:getLinearVelocity()

	if x < 0 then
		self.heading = -1
	else
		self.heading = 1
	end

	if round(x, -2) == 0 then
		self.heading = math.floor(math.random(0, 2)) -1
	end
end

function Foe:draw(dx, dy)
	local edge, ii
	local xs, ys = self.body:getLinearVelocity()

	if round(xs, -2) ~= 0 then
	    if math.floor(self.delay * 10) % 8 < 4 then
	    	ii = 2
	    else ii = 3
	    end
	else ii = 1		--is still
	end

	if self.heading == 1 then
		edge = self:edge("left")
	else
		edge = self:edge("right")
	end
	
	local scale = self.heading
	if round(xs, -2) == 0 then
		scale = 1
		edge = self:edge("left")
	end
	
	love.graphics.draw(objects.player.sprites[not objects.player.gender][ii], edge, self:edge("top"), 0, scale, 1)
	
	love.graphics.setColor(215, 40, 40, 0x80)
	love.graphics.rectangle("fill", self:edge("left"), self:edge("top") - 24, 64, 8)
	
	love.graphics.setColor(215, 40, 40)
	love.graphics.rectangle("fill", self:edge("left"), self:edge("top") - 24, self.health * 64 / self.maxhealth, 8)
	
	love.graphics.setColor(255, 255, 255)
end

function Foe:randomVel()
	local vel
	if math.random() < 0.5 then
		vel = math.random(-500, -250)
	else
		vel = math.random(250, 500)
	end
	return vel
end
