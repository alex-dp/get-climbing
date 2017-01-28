function count(t)
	local count = 0
	for _ in ipairs(t) do
		count = count + 1
	end
	return count
end

--{body = Body()}, {body = Body()}, returns distance
function distance(foe, player)
	local fX, fY = foe.body:getPosition()
	local pX, pY = player.body:getPosition()
	
	local dx, dy = fX - pX, fY - pY
	return math.sqrt(dx ^ 2 + dy ^ 2)
end

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end
