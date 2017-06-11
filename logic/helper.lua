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

--Body(), string, returns distance of a body's edge from (y=0) or (x=0)
function edge(body, s)
	if s == "top" then
		return body:getY() - body:getUserData().h / 2
	elseif s == "right" then
		return body:getX() + body:getUserData().w / 2
	elseif s == "bottom" then
		return body:getY() + body:getUserData().h / 2
	elseif s == "left" then
		return body:getX() - body:getUserData().w / 2
	end
end

--{name = weight, ...}
function weightedchoice(t)
  local sum = 0
  for _, v in pairs(t) do
    sum = sum + v
  end
  
  local rnd = math.random(sum)
  
  for k, v in pairs(t) do
    if rnd < v then return k end
    rnd = rnd - v
  end
end
