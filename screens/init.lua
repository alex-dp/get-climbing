Init = Object:extend()

local notice = "DP Development 2016\nGNU GPLv3"

function Init:load()
end

function Init:update(dt)
end

function Init:draw()

	love.graphics.setColor(255, 255, 255, 128)
	love.graphics.rectangle("fill", 0, 0, width, height)
	love.graphics.setColor(60, 60, 60)

	love.graphics.setFont(fonts[80])
	love.graphics.printf("GET CLIMBING!", 0, height/2 - 150, width, "center")
	if math.floor(love.timer.getTime() * 5) % 5 < 3 then
		love.graphics.setFont(fonts[25])
		love.graphics.printf("PRESS ANY KEY TO START", 0, height/2 + 150, width, "center")
	end

	love.graphics.setFont(fonts[15])
	love.graphics.printf(notice, 0, height - 30, width, "right")
	
	if hiscore then
		love.graphics.setFont(fonts[20])
		love.graphics.printf("HIGH SCORE", 0, height/2 + 30, width, "center")
		love.graphics.setFont(fonts[50])
		love.graphics.printf(hiscore, width/2 + 15, height/2 + 60, width, "left")
		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(images.icons.stairs, width/2 - 79, height / 2 + 40)
	end

	if touch then
		love.graphics.setColor(255, 255, 255)
		love.graphics.rectangle("fill", width/2 - 64, height - 192, 128, 128)
		love.graphics.draw(images.player_sprites[objects.player.gender][1], width/2 - 32, height - 160)
		love.graphics.setFont(fonts[25])
		love.graphics.printf("<        >", width/2 - 125, height - 128, width)
	end
	
	love.graphics.setColor(255, 255, 255)
end

function Init:touchpressed(x, y)
	if x > width/2 - 192 and x < width/2 + 192 and
		y > height - 192 and y < height - 64 then
		objects.player.gender = not objects.player.gender

	else
		if y > height - 30 and x > width - 300 then
			mode = "credits"
		else
			mode = "play"
			TEsound.resume("music")
		end
	end
end

function Init:mousepressed(x, y)
	if y > height - 30 and x > width - 300 then
		mode = "credits"
	end
end
