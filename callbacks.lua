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
		if ud.type == "stamp" then
			objects.player.stamps = objects.player.stamps + ud.value
			ext:getBody():destroy()
		end
		if ud.type == "floor" then
			objects.player.jumpable = true
		elseif ud.type == "elev" then
			elevator.elevate = true
			elevator.active = true
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
