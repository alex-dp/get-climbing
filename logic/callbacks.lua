function beginContact(fix1, fix2, coll)
	local player, ext = nil, nil
	
	if fix1:getBody():getUserData().type == "player" then
		player = fix1
		ext = fix2
	elseif fix2:getBody():getUserData().type == "player" then
		player = fix2
		ext = fix1
	end
	
	if player ~= nil then
		local ud = ext:getBody():getUserData()
		if ud.type == "floor" then
			if elevator.elevate and edge(player:getBody(), "top") >= ext:getBody():getY() then
				elevator.elevate = false
			end
			objects.player.jumpable = true
		elseif ud.type == "elev" then
			elevator.elevate = true
			elevator.active = true
		elseif ud.type == "stamp" then
			objects.player.stamps = objects.player.stamps + ud.value
			objects.player:addLine("You found $" .. ud.value .. " worth of food stamps!")
			ext:getBody():destroy()
		elseif ud.type == "food" then
			objects.player.health = objects.player.health + ud.value
			if objects.player.health > objects.player.maxhealth then
				objects.player.health = objects.player.maxhealth
			end
			objects.player:addLine("You eat the food you found.")
			ext:getBody():destroy()
		end
	end
end

function endContact(fix1, fix2, coll)
	local player, ext = nil, nil
	
	if fix1:getBody():getUserData().type == "player" then
		player = fix1
		ext = fix2
	elseif fix2:getBody():getUserData().type == "player" then
		player = fix2
		ext = fix1
	end
	
	if player ~= nil then
		local ud = ext:getBody():getUserData()
		if ud.type == "floor" then
			objects.player.jumpable = false
		elseif ud.type == "elev" then
			elevator.elevate = false
		end
	end
end

function preSolve(fix1, fix2, coll) end

function postSolve(fix1, fix2, coll) end
