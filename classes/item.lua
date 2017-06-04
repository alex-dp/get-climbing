Item = Object:extend()

function Item:new(item, x, y, world)
	self.x, self.y = x, y
	self.item = item
	self.w, self.h = item.userdata.w, item.userdata.h
	self.world = world	
	self.image = self.item.image
	
	self.body = love.physics.newBody(self.world, self.x, self.y, "dynamic")
	self.shape = love.physics.newRectangleShape(self.w - 8, self.h - 8)
	self.fixture = love.physics.newFixture(self.body, self.shape, 1)
	
	self.fixture:setRestitution(0.5)
	self.fixture:setMask(2)
	self.body:setMass(0.0001)
	self.body:setUserData(item.userdata)
end

function Item:update(dt)
end

function Item:draw()
	if not self.body:isDestroyed() then
		love.graphics.draw(self.image, round(edge(self.body, "left")), round(edge(self.body, "top")))
	end
end
