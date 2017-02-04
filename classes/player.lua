Player = Object:extend()

local foe_del = 0
local filter = {r = 0, g = 0, b = 0}
xs, ys = 0, 0

function Player:new(x, y, world)
	self.x = x
	self.y = y
	self.w = 64
	self.h = 64
	self.world = world
	
	self.jumpable = true
	self.heading = 1
	self.gender = true
	self.maxhealth = 25
	self.health = self.maxhealth
	self.power = {low = 1, high = 3}
	self.lvl = 1
	self.xp = 0
	self.nextlvl = 8
	self.stamps = 0
	self.dead = false

	self.body = love.physics.newBody(self.world, self.x, self.y, "dynamic")
	self.shape = love.physics.newRectangleShape(self.w, self.h)
	self.fixture = love.physics.newFixture(self.body, self.shape, 1)
	
	self.body:setFixedRotation(true)
	self.body:setUserData({type = "player", w = self.w, h = self.h})
	
	self.fixture:setFriction(0)
	self.fixture:setRestitution(0)
	self.fixture:setCategory(1)

	self.foes = {}
	self.drops = {}
end

function Player:update(dt, dy)
	xs, ys = self.body:getLinearVelocity()
	
	if mode == "play" then foe_del = foe_del + dt end
	
	if foe_del > 5 then
		if math.floor(foe_del) % 10 == 0 and count(self.foes) < 5 then
			local foe = Foe(math.random(width / 2 - 500, width / 2 + 500), edge(self.body, "top") - math.random(height, height + 600), self.world)
			table.insert(self.foes, foe)
			foe_del = 1
		end
	end

	for k, v in ipairs(self.foes) do
		if math.random(100) == 1 then
			v.heading = -v.heading
		end
		
		foeXv, foeYv = v.body:getLinearVelocity()
		v.body:setLinearVelocity(v.heading * math.abs(xs), foeYv)
		v:update(dt, dy)
		
		if v.health <= 0 then
			self.xp = self.xp + v.xp
			table.remove(self.foes, k)
			table.insert(self.drops, Item(stamps[v.value], v.body:getX(), v.body:getY(), world))
			v.body:destroy()
		elseif v.body:getY() > camera.y + height + 256 then
			table.remove(self.foes, k)
			v.body:destroy()
		end
	end
	
	if self.xp >= self.nextlvl then
		self.lvl = self.lvl + 1
		self.xp = self.xp - self.nextlvl
		self.netxlvl = math.floor(2.5 * self.lvl) + 5
		for i = 1, 5 do
			local dest = math.random(3)
			if dest == 1 then
				self.health = self.health + math.floor(self.lvl / 2)
				self.maxhealth = self.maxhealth + math.floor(self.lvl / 2)
			elseif dest == 2 and self.power.low < self.power.high then
				self.power.low = self.power.low + 1
			elseif dest == 3 then
				self.power.high = self.power.high + 1
			end			
		end
	end
	
	if filter.r > 0 then filter.r = filter.r - 5 end
	if filter.g > 0 then filter.g = filter.g - 5 end
	if filter.b > 0 then filter.b = filter.b - 5 end
	
	if self.health <= 0 then
		mode = "init"
		if not hiscore or self:storey() > tonumber(hiscore) then
			love.filesystem.write("hiscore", self:storey())
			hiscore = self:storey()
			print(love.filesystem.getSaveDirectory())
		end
		self.dead = true
	end
end

function Player:draw(dx, dy)
	local side, im

	if self.heading == -1 then
		side = edge(self.body, "right")
	else
		side = edge(self.body, "left")
	end

	if round(xs, -1) ~= 0 then
	    if math.floor(love.timer.getTime() * 10) % 8 < 4 then
			im = 2
	    else im = 3
	    end
	else im = 1
	end

	for k, v in ipairs(self.foes) do
		v:draw(dx, dy)
	end
	
	love.graphics.setColor(255 - filter.r, 255 - filter.g, 255 - filter.b)
	love.graphics.draw(images.player_sprites[self.gender][im], side, edge(self.body, "top"), 0, self.heading, 1)
	
	for k, v in ipairs(self.drops) do
		v:draw()
	end

	if touch then
		love.graphics.setColor(255, 255, 255, 0x80)
		love.graphics.rectangle("fill", 30 + dx, height - 158 + dy, 128, 128)
		love.graphics.rectangle("fill", 188 + dx, height - 158 + dy, 128, 128)
		love.graphics.rectangle("fill", width - 158 + dx, height - 158 + dy, 128, 128)
		love.graphics.rectangle("fill", width - 316 + dx, height - 158 + dy, 128, 128)
		love.graphics.setColor(255, 255, 255)
	end
	
	if mode == "play" then
		love.graphics.setColor(215, 40, 40, 0x80)
		love.graphics.rectangle("fill", 30 + dx, 20 + dy, width / 3, 36)
		
		love.graphics.setColor(215, 40, 40)
		love.graphics.rectangle("fill", 30 + dx, 20 + dy, self.health * (width / 3) / self.maxhealth, 36)
		
		love.graphics.setColor(245, 230, 75, 0x80)
		love.graphics.rectangle("fill", 30 + dx, 56 + dy, width / 3, 18)
		
		love.graphics.setColor(245, 230, 75)
		love.graphics.rectangle("fill", 30 + dx, 56 + dy, self.xp * (width / 3) / self.nextlvl, 18)
		
		love.graphics.setColor(65, 65, 65)
		
		love.graphics.setFont(fonts[15])
		love.graphics.printf("level " .. self.lvl, 32 + dx, 62 + dy, width / 3, "left")
		
		love.graphics.setFont(fonts[20])
		love.graphics.printf(self.stamps, 30 + dx, 160 + dy, 64, "center")
		love.graphics.printf(self:storey(), 124 + dx, 160 + dy, 64, "center")
		
		love.graphics.setColor(255, 255, 255)
		
		love.graphics.draw(images.stamps[1], 30 + dx, 90 + dy)
		love.graphics.draw(images.icons.stairs, 124 + dx, 90 + dy)
	end
end

function Player:keypressed(key, code, rep)
	if key == "space" then
	    self:jump(xs, ys)
	elseif key == "k" then
		self:hit()
	elseif key == "a" then
		self.body:setLinearVelocity(-400, ys)
		self.heading = -1
	elseif key == "d" then
		self.body:setLinearVelocity(400, ys)
		self.heading = 1
	end
end

function Player:keyreleased(key, code, rep)
	if (key == "a" and xs < 0) or (key == "d" and xs > 0) then
		self.body:setLinearVelocity(0, ys)
	end
end

function Player:touchpressed(x, y)
	if mode == "play" then
		touch = true

		if y > height - 158 and y < height - 30 then
			if x < 158 then
				self.body:setLinearVelocity(-400, ys)
				self.heading = -1
			elseif x < 316 then
				self.body:setLinearVelocity(400, ys)
				self.heading = 1
			elseif x > width - 158 then
				self:jump(xs, ys)
			elseif x > width - 316 then
				self:hit()
			end
		end
	end
end

function Player:touchreleased(x, y)
	if mode == "play" then
		if count(love.touch.getTouches()) == 0 then
			self.body:setLinearVelocity(0, ys)
		end
	end
end

function Player:jump(xs, ys)
	if self.jumpable then
		self.body:setLinearVelocity(xs, -1100)
	end
end

function Player:hit()
	for k, v in ipairs(self.foes) do
		if distance(v, self) < 100 then
				v:deal(math.random(self.power.low, self.power.high))
		end
	end
end

function Player:deal(damage)
	self.health = self.health - damage
	filter.g = 100
	filter.b = 100
end

function Player:storey()
	return math.floor((height - self.body:getY() - 32) / 300)
end
