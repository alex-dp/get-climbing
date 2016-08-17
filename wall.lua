Wall = Object:extend()

function Wall:new(x, y, w, h, world)
	self.x = x
	self.y = y
	self.w = w
	self.h = h

	self.body = love.physics.newBody(world, self.x, self.y, "static")
	self.shape = love.physics.newRectangleShape(self.w, self.h)
	self.fixture = love.physics.newFixture(self.body, self.shape, 1)
end

function Wall:update(dt)
end

function Wall:draw()
	love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
end