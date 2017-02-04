Credits = Object:extend()

function Credits:load()
end

function Credits:update(dt)
end

function Credits:draw()

	love.graphics.setColor(255, 255, 255, 128)
	love.graphics.rectangle("fill", 0, 0, width, height)
	love.graphics.setColor(60, 60, 60)

	love.graphics.setFont(fonts[65])
	love.graphics.printf("GET CLIMBING!", 0, height/2 - 200, width, "center")
	
	love.graphics.setFont(fonts[15])
	love.graphics.printf("CONCEPT\nCODE\nGRAPHICS", width / 4, height/2 - 50, width, "left")
	love.graphics.printf("deeepaaa", width / 3, height/2 - 50, width / 3, "right")
	
	love.graphics.setFont(fonts[15])
	love.graphics.printf("MUSIC", width / 4, height/2 + 10, width, "left")
	love.graphics.printf("Riccardo Ronchi", width / 3, height/2 + 10, width / 3, "right")
	
	love.graphics.setColor(255, 255, 255)
end

function Credits:touchpressed(x, y)
	mode = "init"
end

function Credits:mousepressed(x, y)
	mode = "init"
end
