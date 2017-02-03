Item = Object:extend()

function Item:new(item, x, y, world)
	self.x, self.y = x, y
	self.item = item
	self.w, self.h = item.userdata.w, item.userdata.h
	self.world = world	
	self.image = self.item.image
	
	self.body = love.physics.newBody(self.world, self.x, self.y, "dynamic")
	self.shape = love.physics.newRectangleShape(self.w, self.h)
	self.fixture = love.physics.newFixture(self.body, self.shape, 1)
	
	self.body:setGravityScale(0)
	self.body:setUserData(item.userdata)
end

function Item:update(dt)
end

function Item:draw()
	if not self.body:isDestroyed() then
		love.graphics.draw(self.image, edge(self.body, "left"), edge(self.body, "top"))
	end
end
