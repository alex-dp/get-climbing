Foe = Object:extend()
local changed = false
local filter = {r = 0, g = 0, b = 0}

function Foe:new(x, y, w, h, world)
	self.x = x
	self.y = y
	self.w = w
	self.h = h
	self.world = world

	self.delay = 0
	self.heading = 1
	self.health = 4
	self.maxhealth = 4
	self.xp = 1			--CHANGE ME
	self.power = {low = 1, high = 2}		--CHANGE ME AS WELL

	self.body = love.physics.newBody(self.world, self.x, self.y, "dynamic")
	self.shape = love.physics.newRectangleShape(self.w, self.h)
	self.fixture = love.physics.newFixture(self.body, self.shape, 1)

	self.fixture:setFriction(0)
	self.fixture:setRestitution(0)

	self.body:setLinearVelocity(self:randomVel(), 0)
	self.body:setUserData({type = "foe", w = self.w, h = self.h})
end

function Foe:update(dt, dy)
	self.delay = self.delay + dt
	local x, y = self.body:getLinearVelocity()

	if x < 0 then
		self.heading = -1
	else
		self.heading = 1
	end

	if round(x, -2) == 0 and not changed then
		self.heading = math.floor(math.random(0, 2)) -1
		changed = true
	elseif round(x, -2) ~= 0 then
		changed = false
	end
	
	if filter.r > 0 then filter.r = filter.r - 5 end
	if filter.g > 0 then filter.g = filter.g - 5 end
	if filter.b > 0 then filter.b = filter.b - 5 end
end

function Foe:draw(dx, dy)
	local side, ii
	local xs, ys = self.body:getLinearVelocity()

	if round(xs, -2) ~= 0 then
	    if math.floor(self.delay * 10) % 8 < 4 then
	    	ii = 2
	    else ii = 3
	    end
	else ii = 1		--is still
	end

	if self.heading == 1 then
		side = edge(self.body, "left")
	else
		side = edge(self.body, "right")
	end
	
	love.graphics.setColor(255 - filter.r, 255 - filter.g, 255 - filter.b)
	love.graphics.draw(objects.player.sprites[not objects.player.gender][ii], side, edge(self.body, "top"), 0, self.heading, 1)
	
	love.graphics.setColor(215, 40, 40, 0x80)
	love.graphics.rectangle("fill", edge(self.body, "left"), edge(self.body, "top") - 24, 64, 8)
	
	love.graphics.setColor(215, 40, 40)
	love.graphics.rectangle("fill", edge(self.body, "left"), edge(self.body, "top") - 24, self.health * 64 / self.maxhealth, 8)
	
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

function Foe:deal(damage)
	self.health = self.health - damage
	objects.player:deal(math.random(self.power.low, self.power.high))
	filter.g = 100
	filter.b = 100
end
