Bullet = Object:extend()

function Bullet:new(x, y, heading, world)
	self.x = x
	self.y = y

	self.body = love.physics.newBody(world, self.x, self.y, "dynamic")
	self.shape = love.physics.newRectangleShape(4, 4)
	self.fixture = love.physics.newFixture(self.body, self.shape, 1)
	--self.fixture:setMask(1)
	self.body:setGravityScale(0)

	self.body:setLinearVelocity(heading * 1000, 0)
end

function Bullet:update(dt)
end

function Bullet:draw()
	love.graphics.rectangle("fill", self.body:getX(), self.body:getY(), 4, 4)
end