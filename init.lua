Init = Object:extend()

local delay = 0
local notice = "DP Development 2016\nGNU GPLv3"

function Init:load()
end

function Init:update(dt)
	delay = delay + dt
end

function Init:draw()

	love.graphics.setColor(50, 50, 50, 128)
	love.graphics.rectangle("fill", 0, 0, width, height)
	love.graphics.setColor(255, 255, 255, 255)

	love.graphics.setFont(fonts[80])
	love.graphics.printf("TROVAMI\nUN\nNOME", 0, height/2 - 150, width, "center")
	if math.floor(delay * 5)%5 < 3 then
		love.graphics.setFont(fonts[25])
		love.graphics.printf("PRESS ANY KEY TO START", 0, height/2 + 150, width, "center")
	end

	love.graphics.setFont(fonts[15])
	love.graphics.printf(notice, 0, height - 30, width, "right")

	if touch then
		love.graphics.rectangle("fill", width/2 - 64, height - 192, 128, 128)
		love.graphics.draw(objects.player.sprites[objects.player.gender][1], width/2 - 32, height - 160)
		love.graphics.setFont(fonts[25])
		love.graphics.printf("<        >", width/2 - 125, height - 128, width)
	end
end

function Init:touchpressed(x,y)
	if x > width/2 - 192 and x < width/2 + 192 and
		y > height - 192 and y < height - 64 then
		objects.player.gender = not objects.player.gender

	else
		mode = "play"
		TEsound.resume("music")
	end
end