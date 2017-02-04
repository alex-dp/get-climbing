Wall = Object:extend()

function Wall:new(x, y, w, h, world, tp) --implement last argument
	self.x = x
	self.y = y
	self.w = w
	self.h = h

	self.body = love.physics.newBody(world, self.x, self.y, (tp == "elev" and "dynamic") or "static")
	self.shape = love.physics.newRectangleShape(self.w, self.h)
	self.fixture = love.physics.newFixture(self.body, self.shape, 1)
	
	self.body:setGravityScale(0)
	self.fixture:setRestitution(0)
	self.body:setFixedRotation(true)
	self.elevate = false
	self.active = false
	self.fixture:setMask(2)
	
	self.body:setUserData({type = tp or "floor", w = self.w, h = self.h})
end

function Wall:update(dt)
end

function Wall:draw() --walls are thin
end
