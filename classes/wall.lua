Wall = Object:extend()

function Wall:new(x, y, w, h, world, tp)
	self.x = x
	self.y = y
	self.w = w
	self.h = h

	self.body = love.physics.newBody(world, self.x, self.y, ((tp == "elev" or tp == "ceil") and "dynamic") or "static")
	self.shape = love.physics.newRectangleShape(self.w, self.h)
	self.fixture = love.physics.newFixture(self.body, self.shape, 1)
	
	self.body:setGravityScale(0)
	self.fixture:setRestitution(0)
	if tp == "wall" then
		self.fixture:setFriction(0)
	end
	self.body:setFixedRotation(true)
	self.elevate = false
	self.active = false
	self.fixture:setMask(tp == "en_wall" and 1 or 16, 3)
	
	self.body:setUserData({type = tp or "floor", w = self.w, h = self.h})
end

function Wall:update(dt)
end

function Wall:draw() --walls are thin
end
