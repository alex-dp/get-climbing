Foe = Object:extend()

function Foe:new(x, y, world)
	self.x = x
	self.y = y
	self.w = 64
	self.h = 64
	self.world = world

	self.age = 0			--time passed since creation
	self.hit_age = 0		--age at which to hit the player. used to delay hitting.
	self.has_hit = true		--whether the damage of which above has been dealt yet
	self.heading = 1		--looking left or right
	self.changed = false
	self.health = 4			--health points left before death
	self.maxhealth = 4		--health points at birth
	self.xp = 1				--experience given upon slaying	(CHANGE ME)
	self.power = {low = 1, high = 4}		--CHANGE ME AS WELL
	self.drop = nil	--item to drop upon death
	
	self.filter = {r = 0, g = 0, b = 0}

	self.body = love.physics.newBody(self.world, self.x, self.y, "dynamic")
	self.shape = love.physics.newRectangleShape(self.w, self.h)
	self.fixture = love.physics.newFixture(self.body, self.shape, 1)

	self.fixture:setFriction(0)
	self.fixture:setRestitution(0)
	self.fixture:setCategory(2)
	
	self.body:setUserData({type = "foe", w = self.w, h = self.h})
	self.body:setFixedRotation(true)
	
	repeat
		self.drop = droppables[weightedchoice({one = 10, two = 7.5, beer = 5, acid = 100})]
	until self.drop ~= nil
end

function Foe:update(dt, dy)
	local x, y = self.body:getLinearVelocity()
	
	if x == 0 or math.random(300) == 1 then
		self.heading = -self.heading
	end
	
	self.age = self.age + dt
	
	self.body:setLinearVelocity(self.heading * 300, y)
	
	if self.age >= self.hit_age and not self.has_hit then
		self:hit()
		self.has_hit = true
	end
	
	if self.filter.r > 0 then self.filter.r = self.filter.r - 5 end
	if self.filter.g > 0 then self.filter.g = self.filter.g - 5 end
	if self.filter.b > 0 then self.filter.b = self.filter.b - 5 end
end

function Foe:draw(dx, dy)
	local side = edge(self.body, self.heading == 1 and "left" or "right")
	local ii
	local xs, ys = self.body:getLinearVelocity()

	if round(xs, -2) ~= 0 then
	    if math.floor(self.age * 10) % 8 < 4 then
	    	ii = 2
	    else ii = 3
	    end
	else ii = 1		--is still
	end
	
	love.graphics.setColor(255 - self.filter.r, 255 - self.filter.g, 255 - self.filter.b)
	love.graphics.draw(images.player_sprites[not objects.player.gender][ii], math.floor(side), math.floor(edge(self.body, "top")), 0, self.heading, 1)
	
	love.graphics.setColor(215, 40, 40, 0x80)
	love.graphics.rectangle("fill", edge(self.body, "left"), edge(self.body, "top") - 24, 64, 8)
	
	love.graphics.setColor(215, 40, 40)
	love.graphics.rectangle("fill", edge(self.body, "left"), edge(self.body, "top") - 24, self.health * 64 / self.maxhealth, 8)
	
	love.graphics.setColor(255, 255, 255)
end

function Foe:hit()
	if distance(objects.player, self) < 100 then
			objects.player:deal(math.random(self.power.low, self.power.high))
	end
end

function Foe:deal(damage)
	self.health = self.health - damage
	if self.health > 0 then
		self.hit_age = self.age + 0.2
		self.has_hit = false
	end
	self.filter.g = 100
	self.filter.b = 100
end
