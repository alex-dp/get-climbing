Player = Object:extend()

local filter = {r = 0, g = 0, b = 0}

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
	self.age = 0
	self.elevation = 0
	self.state = "sober"
	self.alteration = 0
	self.mr_text, self.lr_text = "", "" --most recent, least recent
	self.xs, self.ys = 0, 0

	self.body = love.physics.newBody(self.world, self.x, self.y, "dynamic")
	self.shape = love.physics.newRectangleShape(self.w, self.h)
	self.fixture = love.physics.newFixture(self.body, self.shape, 1)
	
	self.body:setFixedRotation(true)
	self.body:setUserData({type = "player", w = self.w, h = self.h})
	self.body:setMass(0.5)
	
	self.fixture:setFriction(touch and 0 or 1)
	self.fixture:setRestitution(0)
	self.fixture:setCategory(1)

	self.foes = {}
	self.drops = {}
end

function Player:update(dt, dy)
	self.age = self.age + dt
	self.xs, self.ys = self.body:getLinearVelocity()
	
	if mode == "play" and love.keyboard.isDown("a") then
		self.body:setLinearVelocity(-400, self.ys)
		self.heading = -1
	end
	if mode == "play" and love.keyboard.isDown("d") then
		self.body:setLinearVelocity(400, self.ys)
		self.heading = 1
	end
	
	if self.xp >= self.nextlvl then
		self.lvl = self.lvl + 1
		self.xp = self.xp - self.nextlvl
		self.netxlvl = math.floor(2.5 * self.lvl) + 5
		for i = 1, self.lvl do
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
		
		print(self.lvl .. "=lvl")
		print(self.nextlvl .. "=nextlvl")
	end
	
	if self.state ~= "sober" then
		self.alteration = self.alteration - dt
		if self.alteration <= 0 then
			self:addLine("You sober up!")
			self.alteration = 0
			self.state = "sober"
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
	local side = edge(self.body, self.heading == 1 and "left" or "right")
	local im

	if round(self.xs, -1) ~= 0 then
	    if math.floor(love.timer.getTime() * 10) % 8 < 4 then
			im = 2
	    else im = 3
	    end
	else im = 1
	end
	
	love.graphics.setColor(255 - filter.r, 255 - filter.g, 255 - filter.b)
	
	if self.state == "high" then
		love.graphics.setShader(rainbow)
		rainbow:send("time", self.age)
	end
	love.graphics.draw(images.player_sprites[self.gender][im], math.floor(side), math.floor(edge(self.body, "top")), 0, self.heading, 1)
	--love.graphics.setShader()
	
	camera:unset()
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
		love.graphics.rectangle("fill", 30, 20, width / 3, 36)
		
		love.graphics.setColor(215, 40, 40)
		love.graphics.rectangle("fill", 30, 20, self.health * (width / 3) / self.maxhealth, 36)
		
		love.graphics.setColor(245, 230, 75, 0x80)
		love.graphics.rectangle("fill", 30, 56, width / 3, 18)
		
		love.graphics.setColor(245, 230, 75)
		love.graphics.rectangle("fill", 30, 56, self.xp * (width / 3) / self.nextlvl, 18)
		
		love.graphics.setColor(65, 65, 65)
		
		love.graphics.setFont(fonts[15])
		love.graphics.printf("level " .. self.lvl, 32, 62, width / 3, "left")
		
		love.graphics.setFont(fonts[20])
		love.graphics.printf(self.stamps, 30, 160, 64, "center")
		love.graphics.printf(self.elevation, 124, 160, 64, "center")
		
		love.graphics.setColor(255, 255, 255)
		
		love.graphics.draw(images.stamps[1], 30, 90)
		love.graphics.draw(images.icons.stairs, 124, 90)
		
		love.graphics.setColor(255, 255, 255, 0x80)
		love.graphics.rectangle("fill", width / 5 - 5, height - 70, 3*width / 5 + 10, 50)
		
		love.graphics.setColor(65, 65, 65)
		love.graphics.printf(self.mr_text, width/5, height - 40, 3*width / 5)
		
		love.graphics.setColor(65, 65, 65, 0x80)
		love.graphics.printf(self.lr_text, width/5, height - 60, 3*width / 5)
		
		love.graphics.setColor(255, 255, 255)
	end
	camera:set()
end

function Player:keypressed(key, code, rep)
	if key == "space" then
	    self:jump()
	elseif key == "k" then
		self:hit()
	end
end

function Player:keyreleased(key, code, rep)
	if (key == "a" and self.xs < 0) or (key == "d" and self.xs > 0) then
		self.body:setLinearVelocity(0, self.ys)
	end
end

function Player:touchpressed(x, y)
	if mode == "play" then
		touch = true

		if y > height - 158 and y < height - 30 then
			if x < 158 then
				self.body:setLinearVelocity(-400, self.ys)
				self.heading = -1
			elseif x < 316 then
				self.body:setLinearVelocity(400, self.ys)
				self.heading = 1
			elseif x > width - 158 then
				self:jump()
			elseif x > width - 316 then
				self:hit()
			end
		end
	end
end

function Player:touchreleased(x, y)
	if mode == "play" then
		if count(love.touch.getTouches()) == 0 then
			self.body:setLinearVelocity(0, self.ys)
		end
	end
end

function Player:jump()
	if self.jumpable then
		self.body:setLinearVelocity(self.xs, -1100)
	end
end

function Player:hit()
	for k, v in ipairs(objects.storeys[self:storey()].foes) do
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

function Player:addLine(line)
	objects.player.lr_text = objects.player.mr_text
	objects.player.mr_text = line
end

function Player:storey() --make more efficient with floor collisions
	return math.floor((height - self.body:getY() - 32) / 300)
end
