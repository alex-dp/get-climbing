Dead = Object:extend()

function Dead:load()
end

function Dead:update(dt)
end

function Dead:draw()

	love.graphics.setColor(255, 255, 255, 128)
	love.graphics.rectangle("fill", 0, 0, width, height)
	love.graphics.setColor(60, 60, 60)

	love.graphics.setFont(fonts[65])
	love.graphics.printf("You are dead!", 0, height/2 - 200, width, "center")
	
	love.graphics.setFont(fonts[25])
	love.graphics.printf(string.format("You will be buried with %d food stamps.", self.fs), 0, height/2 - 50, width, "center")
	
	if math.floor(love.timer.getTime() * 5) % 5 < 3 then
		love.graphics.printf("PRESS ANY KEY TO START", 0, height/2 + 150, width, "center")
	end
	
	love.graphics.setColor(255, 255, 255)
end

function Dead:touchpressed(x, y)
	mode = "init"
end

function Dead:mousepressed(x, y)
	mode = "init"
end
