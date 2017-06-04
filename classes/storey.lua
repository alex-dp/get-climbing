Storey = Object:extend()

function Storey:new(count, world)
	self.count = count
	self.y = height - count * room.h
	self.idx = count % 4 == 3 and 2 or 1
	self.world = world
	self.foesleft = math.random(2, 4)

	self.floor = Wall(width/2, self.y, room.w, 1, world, "floor")
	self.walls = {
		Wall((width - room.w) / 2, (-count) * room.h + height, 1, room.h, world, "wall"),
		Wall((width + room.w) / 2 + 100, (-count) * room.h + height, 1, room.h, world, "wall"),
		Wall((width + room.w) / 2, (-count) * room.h + height, 1, room.h, world, "en_wall")
	}
	
	self.foes = {}
	self.foe_del = 0
	
	self.drops = {}
	self.destroyed = false
	
	if math.random(5) == 2 then
		table.insert(self.drops, Item(food.sammich, math.random((width - room.w) / 2 + 31, (width + room.w) / 2) - 32, self.y - 50, world))
	end
end

function Storey:update(dt, dy)
	if mode == "play" then
		self.foe_del = self.foe_del + dt
	end
	
	if self.foesleft > 0 and math.floor(self.foe_del) % 10 == 0 and count(self.foes) < 2 then
		local foe = Foe(math.random(edge(self.floor.body, "left") + 32, edge(self.floor.body, "right") - 32), self.y - 32, self.world)
		table.insert(self.foes, foe)
		self.foesleft = self.foesleft - 1
	end

	for k, v in ipairs(self.foes) do
		if math.random(100) == 1 then
			v.heading = -v.heading
		end
		
		local foeXv, foeYv = v.body:getLinearVelocity()
		v.body:setLinearVelocity(v.heading * math.abs(objects.player.xs), foeYv)
		v:update(dt, dy)
		
		if v.health <= 0 then
			objects.player.xp = objects.player.xp + v.xp
			table.remove(self.foes, k)
			table.insert(self.drops, Item(stamps[v.value], v.body:getX(), v.body:getY() - 40, world))
			v.body:destroy()
			
			objects.player:addLine("You slew a colleague!")
		end
	end
end

function Storey:draw(dx, dy)
	love.graphics.draw(images.rooms[self.idx], edge(self.floor.body, "left"), self.y - 300)
	for k, v in ipairs(self.foes) do
		v:draw()
	end
	
	for k, v in ipairs(self.drops) do
		v:draw()
	end
end

function Storey:destroy()
	if self.count ~= 1 then
		self.floor.body:destroy()
	end
	self.walls[1].body:destroy()
	self.walls[2].body:destroy()
	self.walls[3].body:destroy()
	
	for k, v in ipairs(self.foes) do
		if not v.body:isDestroyed() then
			v.body:destroy()
		end
	end
	
	for k, v in ipairs(self.drops) do
		if not v.body:isDestroyed() then
			v.body:destroy()
		end
	end
	
	self.destroyed = true
end
